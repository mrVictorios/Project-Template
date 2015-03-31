# puppet

1. Description
2. Configure
3. Apache
4. MySql
5. PHP
6. SSL
7. Misc

### Description

Simple Vagrant Puppet project template for development.



### Configure

    puppet/manifests/site.pp

### Apache
#### Add vhost
    
    ! configuration not complete
    ! enable site automatic
    
    
    Parameter:
    
    name                default value
    
    servername        = "www.vagrant.local.de",
    port              = 80,
    docroot           = "/var/www",
    webmaster         = "webmaster@domain.tld",
    ssl               = false,
    ssl_only          = false,
    ssl_port          = 443,
    ssl_cert_file     = '/etc/ssl/certs/ssl-cert-snakeoil.pem',
    ssl_cert_key_file = '/etc/ssl/private/ssl-cert-snakeoil.key',
    vhostloglevel     = "warn"
    
    apache::vhost{ "create Vhost Example.com":
        servername => 'example.com',
        docroot    => '/var/www/example'
    }

#### Enable mod
    Parameter:
    
    name         default value
    mode       = undefined

    apache::enmode { "enable apache module ssl":
        mode => 'ssl'
    }

### Enable site
    Parameter:
    
    name         default value
    site       = undefined
    
    apache::ensite { "enable apache site":
            conf => 'mysite.conf'
    }

### MySql
#### Create Database
    Parameter:
    
    name             default value
    databasename   = undefined

    mysql::db_create { "create ${mysql_database}": 
        databasename => $mysql_database 
    }

#### Import Data into Database
    Parameter:
    
    name          default value
    database    = ''
    filepath    = ''

    mysql::import { "import dump":
        database => $mysql_database,
        filepath => 'path/to/file'
    }

### PHP
#### Configure xdebug
    Parameter:
    
    name                        default value
    idekey                    = 'PHPSTORM'
    remote_enable             = true
    remote_handler            = 'dbgp'
    remote_port               = 9000
    remote_autostart          = true
    remote_connect_back       = true
    remote_cookie_expire_time = 3600
    remote_host               = 'localhost'
    remote_log                = ''
    remote_mode               = 'req'
    collect_assignments       = false
    collect_includes          = true
    collect_params            = 0
    collect_return            = false
    collect_vars              = false
    profiler_enable           = false
    profiler_enable_trigger   = false
    profiler_output_dir       = '/tmp'
    profiler_output_name      = 'cachegrind.out%p'
    profiler_aggregate        = false
    profiler_append           = false
    dump_COOKIE               = ''
    dump_ENV                  = ''
    dump_FILES                = ''
    dump_GET                  = ''
    dump_POST                 = ''
    dump_SESSION              = ''
    dump_globals              = true
    dump_once                 = true
    dump_undefined            = false
    trace_enable_trigger      = false
    trace_format              = 0
    trace_options             = 0
    trace_output_dir          = '/tmp'
    trace_output_name         = 'trace.%c'
    var_display_max_children  = 128
    var_display_max_data      = 512
    var_display_max_depth     = 3
    scream                    = false
    auto_trace                = false
    show_exception_trace      = false
    show_local_vars           = false
    show_mem_delta            = false
    extended_info             = true
    coverage_enable           = true
    max_nesting_level         = 100
    overload_var_dump         = true

    php5::xdebug      { "xdebug default": 
        remote_enable => true,
        idekey        => 
    }


#### Enable PHP Module
    Parameter:
    
    name         default value
    modulename = undefined

    php5::enmod { "enable wahtever":
        modulename => 'wahtever'
    }
    
### SSL
### genrate a SSL certificate
    Parameter:
    
    name                  default value
    numbits             = 2048
    aes                 = 256
    caFilepath          = '/etc/ssl/private/snakeOil_ca-key.pem'
    rootCaFilepath      = '/etc/ssl/private/snakeOil_ca-root.pem'
    certificateFilepath = '/etc/ssl/private/snakeOil_certificate'
    commonname          = 'vagrant.local.de'
    country             = 'DE'
    state               = 'Saxony'
    location            = 'Dresden'
    password            = 'vagrant'
    company             = 'example'
    email               = 'example@example.de'
    unit                = 'development'
    expireDays          = 1024

    openssl::generateSSLCertificates { "default SSL Certificates":
      caFilepath          => '/etc/ssl/private/snakeOil_ca-key.pem',
      rootCaFilepath      => '/etc/ssl/private/snakeOil_ca-root.pem',
      commonname          => 'www.domain.tld',
      certificateFilepath => '/etc/ssl/private/snakeOil_certificate'
      require             => Package['apache2'],
    }

### Misc
#### Connect to MySql over client

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
