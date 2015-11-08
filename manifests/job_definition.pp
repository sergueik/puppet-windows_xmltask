# -*- mode: puppet -*-
# vi: set ft=puppet :

define windows_xmltask::job_definition(
  $script = $title,
  $prorgam = undef,
  $arguments = undef,
  $description = undef,
  $username = 'vagrant',
  $domain = '.',
  $version = '0.1.0',
  $workdir = 'c:/windows/temp',
  $debug = false
)   {
  # validate install parameters
  validate_string($program)
  validate_string($username)
  validate_string($domain)
  validate_re($version, '^\d+\.\d+\.\d+(-\d+)*$')
  $taskname = regsubst($title, '[$/\\|:, ]', '_', 'G')
  # generate job definition from template
  file { "c:\\windows\\temp\\${script}.xml":
    ensure             => file,
    content            => template('windows_xmltask/generic_task_xml.erb'),
    source_permissions => ignore,
  }
}
