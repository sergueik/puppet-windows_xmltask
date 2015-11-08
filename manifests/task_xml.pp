# -*- mode: puppet -*-
# vi: set ft=puppet :

define windows_xmltask::task_xml(
  $script  = $title
  $command = 'notepad.exe',
  $version = '0.1.0',
  $debug   = false
)   {
  # Validate install parameters.
  validate_string($command)
  validate_re($version, '^\d+\.\d+\.\d+(-\d+)*$')
  $taskname = regsubst($name, '[$/\\|:, ]', '_', 'G')
  $random = fqdn_rand(1000,  $taskname)
  $temp_dir = "c:\\windows\\temp\\${taskname}"
  $xml_job_definition_path = "${temp_dir}\\${script}.${random}.xml"

  ensure_resource('file', $temp_dir , {
    ensure => directory,
  }) ->
  file { "${taskname} creating XML task definition":
    ensure             => file,
    path               => $xml_job_definition_path,
    content            => template('custom_command/generic_scheduled_task_xml.erb'),
    source_permissions => ignore,
  }
}
