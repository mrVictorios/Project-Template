# puppet

### Description

Simple Vagrant Puppet project template for development.



### Configure

    puppet/site.pp


#### Add VHost
    
    apache::vhost{ "create Vhost Example.com":
        servername => 'example.com',
        docroot    => '/var/www/example'
    }

    
#### Enable Mod
    apache::enmode { "enable apache module ssl":
        mode => 'ssl'
    }
    

#### Add Database
    mysql::db_create { "create ${mysql_database}": 
        databasename => $mysql_database 
    }
