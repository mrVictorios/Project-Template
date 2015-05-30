# Project Template

1. Description
2. Requirements
3. Configure
4. Misc

## Version 1.0

## Description

Simple Vagrant Puppet project templates for development. 
This Template include typical Project configurations, like Apache, PHP with MySql or Mongo.

## Requirements

- Virtualbox <https://www.virtualbox.org>
- Vagrant <https://www.vagrantup.com>

## How to use? (short description)

In the "puppet/manifests" you will find some templates you can use.
To use a other configuration, replace the puppet manifest file in the Vagrantfile.

Edit the template

add to you "hosts" file

type "vagrant up" in cli on project folder 

when finish check it

#### Vagrantfie
```ruby
...
config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file  = "apache_php_mysql_tpl.pp" #<---- change here the file name to use another configuration
    puppet.module_path   = "puppet/modules"
end
```

#### Available templates

- Apache PHP MySql <-- default configuration
- Apache PHP Mongo
    
some other will follow    

## Misc
#### Connect to MySql over client like MySql Workbench

    use ssh proxy
    
    mysql:
        adress: localhost
        user:   root
        pass:   <mysql_password>
        
    ssh:
        adress: <vagrant host only ip>
        user:   vagrant
        pass:   vagrant
        port:   22
