# -*- mode: puppet -*-
# vi: set ft=puppet :

define windows_xmltask(
  $wait        = true,
  $command     = 'notepad.exe',
  $script      = 'manage_scheduled_task',
  $version     = '0.2.0'
)   {
  # Validate install parameters.
  validate_bool($wait)
  validate_string($script)
  validate_string($command)
  validate_re($version, '^\d+\.\d+\.\d+(-\d+)*$')
  $random = fqdn_rand(1000,  $taskname)
  $taskname = regsubst($name, "[$/\\|:, ]", '_', 'G')
  $temp_dir = "c:\\windows\\temp\\${taskname}"
  $script_path = "${temp_dir}\\${script}.ps1"
  $xml_job_definition_path = "${temp_dir}\\${script}.${random}.xml"
  $log = "${temp_dir}\\${script}.${random}.log"

  # https://github.com/counsyl/puppet-windows/blob/master/templates/refresh_environment.ps1.erb
  ensure_resource('file', $temp_dir , {
    ensure => directory,
  }) ->
  file { "${name} launcher log":
    name               => "${script}${random}.log",
    path               => $log,
    ensure             => absent,
    source_permissions => ignore,
  } ->

  file { "${name} launcher script":
    ensure             => file,
    path               => $script_path,
    content            => template('custom_command/manage_scheduled_task_ps1.erb'),
    source_permissions => ignore,
  } ->

  exec { "Execute script that will create and run scheduled task ${name}":
    command   => "powershell -executionpolicy remotesigned -file ${script_path}",
    logoutout => true,
    require   => File[ "${name} launcher script"],
    path      => 'C:\Windows\System32\WindowsPowerShell\v1.0;C:\Windows\System32',
    provider  => 'powershell',
  }
#    exec { "Importing task $taskname":
#      command => "
#        Try{
#          if((Get-ScheduledTask '$taskname') -eq $null){
#            Register-ScheduledTask -Xml (get-content 'C:\Users\Public\\$temp_filename.xml' | out-string) -TaskName '$taskname' $is_force
#          }
#          Remove-Item 'c:\Users\Public\\$temp_filename.xml'
#        }
#        Catch{
#          exit 0
#        }
#      ",
#      provider  => powershell,
#    }
}
