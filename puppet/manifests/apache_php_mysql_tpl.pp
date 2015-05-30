### Apache PHP MySql Template
#
#   Default Template
#
#   include:  Apache
#             PHP 5.5 with xdebug
#             MySql
#

### Paths
Exec { path => [ "/usr/local/sbin", "/usr/local/bin", "/usr/sbin", "/usr/bin", "/sbin", "/bin" ] }

### stages
stage { 'update' : before => Stage['main'] }

### modules
class { "system" : stage => update }
class { "apache" : stage => main }
class { "php5"   : stage => main }
class { "mysql"  : stage => main }

### configuration
$servername     = 'www.vagrant.local'

$mysql_dump_path = '/vagrant/puppet/database/mysql'
$mysql_database  = 'vagrant'
$mysql_password  = 'vagrant'

system::copy { "copy project":
  source      => '/vagrant/src/*',
  destination => '/var/www',
  require     => Package['apache2']
}

system::cleanup { "clean up":
  require => System::Copy['copy project']
}

# certificates
$caFilepath          = "/etc/apache2/${servername}_ca-key.pem"
$rootCaFilepath      = "/etc/apache2/${servername}_ca-root.pem"
$certificateFilepath = "/etc/apache2/${servername}_certificate"

openssl::generateSSLCertificates { "default SSL Certificates":
  caFilepath          => $caFilepath,
  rootCaFilepath      => $rootCaFilepath,
  commonname          => $servername,
  certificateFilepath => $certificateFilepath,
  require             => Package['apache2'],
}

# apache
apache::vhost { "add vhost ${servername}":
  servername        => $servername,
  ssl               => true,
  ssl_cert_file     => "${certificateFilepath}-pub.pem",
  ssl_cert_key_file => "${certificateFilepath}-key.pem",
}

apache::enmod { "enable ssl support"    : mod => 'ssl' }
apache::enmod { "enable rewrite support": mod => 'rewrite' }

# php
package { "php5-mysql":
    require => Package['php5']
}

php5::xdebug      { "install and configure xdebug": }

## mysql
mysql::db_create { "create ${mysql_database}" : databasename   => $mysql_database }

#### dump import
mysql::import    { "import structure" :
  database => $mysql_database,
  filepath => "${mysql_dump_path}/structure.sql"
}
mysql::import    { "import data dump" :
  database => $mysql_database,
  filepath => "${mysql_dump_path}/dump.sql"
}
mysql::import    { "update data" :
  database => $mysql_database,
  filepath => "${mysql_dump_path}/development.sql"
}

mysql::root { "set mysql root" : password => "${mysql_password}"}

# make sure you import all needed data before set the root password
Mysql::Db_create["create ${mysql_database}"] ->
Mysql::Import['import structure']            ->
Mysql::Import['import data dump']            ->
Mysql::Import['update data']                 ->
Mysql::Root['set mysql root']
