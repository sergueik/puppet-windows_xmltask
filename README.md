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
Sample serverspec
-----------------
```
  context 'Application Task Scheduler configuration' do
    describe file('C:/Programdata/LogRotate_scheduled_task.xml') do
      it { should exist }
      it { should be_file }
      ['<Command>"C:\\\\Program Files \\(x86\\)\\\\LogRotate\\\\logrotate.exe"</Command>','<Arguments>"C:\\\\Program Files \\(x86\\)\\\\LogRotate\\\\Content\\\\sample.conf"</Arguments>','<WorkingDirectory>c:\\\\windows\\\\temp</WorkingDirectory>'].each do |line| 
        it { should contain /#{Regexp.new(line)}/i }
      end 
      it { should contain '<Task xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task" version="1.3">' }
      it { should contain '<UserId>S-1-5-18</UserId>' }

    end
  end
```  
```
  context 'Application Task Scheduler' do
    name = 'LogRotate' 
    describe command(<<-EOF
schtasks.exe /Query /TN #{name} /xml
EOF
    ) do
      its(:exit_status) {should eq 0 }
      ['<Command>"C:\\\\Program Files \\(x86\\)\\\\LogRotate\\\\logrotate.exe"</Command>','<Arguments>"C:\\\\Program Files \\(x86\\)\\\\LogRotate\\\\Content\\\\sample.conf"</Arguments>','<WorkingDirectory>c:\\\\windows\\\\temp</WorkingDirectory>'].each do |line| 
        its(:stdout) {should match /#{Regexp.new(line)}/i }
      end 
    end
  end

```

Sample spec
-----------

```
      it 'task is scheduled daily' do
        should contain_file('C:/ProgramData/logRotate_scheduled_task.xml').with_content(/<ScheduleByDay>\r?\n\s+<DaysInterval>1<\/DaysInterval>\r?\n\s+<\/ScheduleByDay>/).that_comes_before('Exec[application_create_scheduled_task]')
      end
      it 'creates scheduled task' do
        should contain_exec('application_create_scheduled_task').with('require' => 'File[C:/ProgramData/logRotate_scheduled_task.xml]')
      end

```
Author
------
[Serguei Kouzmine](kouzmine_serguei@yahoo.com)


