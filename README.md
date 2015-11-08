# Puppet Windows XML Task


##Overview

Creating windows schedule task from previously exported.
Origin: [puppet-windows_xmltask](https://github.com/noma4i/puppet-windows_xmltask) at Puppet Forge. See also: [custom scheduled task module](https://github.com/sergueik/puppetmaster_vagrant/blob/master/modules/custom_command/manifests/init.pp)

##Module Description

Windows schedule tasks are tricky. Sometimes you need to setup very special attributes like *parallel process run*. I have ended with simple solution: create task via GUI and export as xml file and import it later.

##Usage


	windows_xmltask {'My Task Name':
    	ensure => present,
    	overwrite => 'false',
    	xmlfile => 'puppet:///config/soft/my_exported_task.xml',
  	}


##License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html)


