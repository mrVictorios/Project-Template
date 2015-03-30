Exec { path => [ "/usr/local/sbin", "/usr/local/bin", "/usr/sbin", "/usr/bin", "/sbin", "/bin" ] }

### stages
stage { 'prepare': before => Stage['update'] }
stage { 'update' : before => Stage['main'] }

### classes
class { "system" : stage => update }
class { "apache" : stage => main }
class { "php5"   : stage => main }
class { "mysql"  : stage => main }

### configuration

$mysql_database = 'vagrant'
$mysql_password = 'vagrant'

$caFilepath          = '/etc/apache2/snakeOil_ca-key.pem'
$rootCaFilepath      = '/etc/apache2/snakeOil_ca-root.pem'
$certificateFilepath = '/etc/apache2/snakeOil_certificate'

openssl::generateSSLCertificates { "default SSL Certificates":
  caFilepath          => $caFilepath,
  rootCaFilepath      => $rootCaFilepath,
  certificateFilepath => $certificateFilepath,
  require             => Package['apache2'],
}

# apache

apache::vhost { "vagrant":
  servername        => 'www.vagrant.local.de',
  docroot           => '/var/www/vagrant/',
  ssl               => true,
  ssl_cert_file     => "${certificateFilepath}-pub.pem",
  ssl_cert_key_file => "${certificateFilepath}-key.pem",
}

apache::enmod { "enable ssl":
  mod => 'ssl'
}

# php

php5::xdebug      { "xdebug default": }

## mysql

mysql::db_create { "create ${mysql_database}" : databasename   => $mysql_database }

system::mysql    { "use mysql autoupdate":
  mysql_password => $mysql_password,
  mysql_database => $mysql_database
}


#### high priority

mysql::import    { "import structure" :
  database => $mysql_database,
  filepath => '/vagrant/database/structure.sql'
}
mysql::import    { "import data dump" :
  database => $mysql_database,
  filepath => '/vagrant/database/dump.sql'
}
mysql::import    { "update data" :
  database => $mysql_database,
  filepath => '/vagrant/database/development.sql'
}

mysql::root { "set mysql root" : password => "${mysql_password}"}

Mysql::Db_create["create ${mysql_database}"] ->
Mysql::Import['import structure']      ->
Mysql::Import['import data dump']      ->
Mysql::Import['update data']           ->
Mysql::Root['set mysql root']
