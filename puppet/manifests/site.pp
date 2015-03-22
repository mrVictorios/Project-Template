Exec { path => [ "/usr/local/sbin", "/usr/local/bin", "/usr/sbin", "/usr/bin", "/sbin", "/bin" ] }

### stages
stage { 'prepare': before => Stage['update'] }
stage { 'update' : before => Stage['main'] }

### classes
class { "system" : stage => update }
class { "apache" : stage => main }
class { "php"    : stage => main }
class { "mysql"  : stage => main }

### configuration

$mysql_database = 'test'
$mysql_password = 'testsystem'

# apache

apache::vhost { "mysite":
  servername => 'www.mysite.de',
  webmaster  => 'webmaster@domain.tld',
}

# php

php::xdebug      { "xdebug default"     : }

# mysql

mysql::db_create { "create ${mysql_database}" : databasename   => $mysql_database }

system::mysql    { "use mysql autoupdate":
  mysql_password => $mysql_password,
  mysql_database => $mysql_database
}


### high priority

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
