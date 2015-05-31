# Project Template

## Description

Simple Vagrant Puppet project templates for development. 
This Template include typical Project configurations, like Apache, PHP with MySql or MongoDB.

## Requirements

- Virtualbox <https://www.virtualbox.org>
- Vagrant <https://www.vagrantup.com>

## Installation easy way (only on UNIX systems available)

use Composer

    "repositories": [
        {
          "type": "vcs",
          "url":  "https://github.com/mrVictorios/Project-Template.git"
        }
      ],
...
      
    "require": {
        "manrog/project-template": "*"
     }

1. run composer
2. run ./vendor/bin/project.sh init "NAME OF THE VM"
3. follow the introductions or configure by self

## How to use? (short)

put you database dump into "pupper/database/$DB"
refactor the templates on your requirements

#### Vagrantfile
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
- Apache PHP MongoDB
    
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
