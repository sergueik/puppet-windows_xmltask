# Puppet Windows XML Task


##Overview

Creating windows schedule task from previously exported.
Origin: [puppet-windows_xmltask](https://github.com/noma4i/puppet-windows_xmltask) at Puppet Forge. See also: [custom scheduled task module](https://github.com/sergueik/puppetmaster_vagrant/blob/master/modules/custom_command/manifests/init.pp)

##Module Description

Windows schedule tasks are tricky. Sometimes you need to setup very special attributes like *parallel process run*. One possible solution: create task via Scheduled Tasks UI, save and feed to the provider. For common commands one can export generic job definition file (xml) as erb template, let the provider generate a task definition from template, run and wait for completion.

The script is simply a [wrapper for `schtasks.exe` utility](http://stackoverflow.com/questions/18387920/get-scheduledtask-in-powershell-on-windows-server-2003). It was originally designed for and tested against Windows 7 guest as a quick solution for installing legacy applications which lack a console (silent) installer (even if the desktop access is required for an innocent progress bar).

With Windows Server 2008 R2, 2012, Windows 8 and later a collection of
[Scheduled Tasks]( https://technet.microsoft.com/en-us/library/jj649808%28v=wps.630%29.aspx)
powershell cmdlets have been introduced.

On Windows 7,2008 /  powershell 3 where the [Scheduled Tasks]( https://technet.microsoft.com/en-us/library/jj649808%28v=wps.630%29.aspx) is not available, alternative is to use __Schedule.Service__ [COM object](http://msexchange.me/2013/12/22/schedule-task-monitor-script). The COM object in question was distributed as part of [PowerShell Pack](http://code.msdn.microsoft.com/PowerShellPack), which appears to be retired. For the purpose of this module, `schtasts.exe` appears to be sufficient. Switch to Windows 2012 solution is planned in future revisions: it may offer a more granular conrol over the task state.

##Usage

```
windows_xmltask::job_definition { 'my task' :
  program => 'notepad.exe',
  workdir => 'c:/users/vagrant',
} ->
windows_xmltask {'mytask':
  job_definition => 'c:/windows/temp/my_task.xml',
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

Author
------
[Serguei Kouzmine](kouzmine_serguei@yahoo.com)


