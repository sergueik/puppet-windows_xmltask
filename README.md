# Puppet Windows XML Task


##Overview

Creating windows schedule task from previously exported.
Origin: [puppet-windows_xmltask](https://github.com/noma4i/puppet-windows_xmltask) at Puppet Forge. See also: [custom scheduled task module](https://github.com/sergueik/puppetmaster_vagrant/blob/master/modules/custom_command/manifests/init.pp)

##Module Description

Windows schedule tasks are tricky. Sometimes you need to setup very special attributes like *parallel process run*. One possible solution: create task via Scheduled Tasks UI, save and feed to the provider. For common commands one can export generic job definition file (xml) as erb template, let the provider generate a task definition from template, run and wait for completion.

##Usage

```
windows_xmltask::job_definition { 'mytask' :
  program => 'notepad.exe',
} ->
windows_xmltask {'mytask':
  job_definition => 'c:/windows/temp/mytask.xml',
  wait           => true,
  timeout        => 300,
  create         => false,
}

```
or
```
windows_xmltask { 'mytask' :
  program => 'notepad.exe',
  wait    => true,
  timeout => 300,
  create  => true,
}
```


