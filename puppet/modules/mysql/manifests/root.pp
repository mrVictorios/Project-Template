define mysql::root ($password = $mysql_root_password) {
  exec { "set mysql root password":
    command => "mysqladmin -u root password '${password}'",
    require => Package['mysql-server', 'mysql-client']
  }

  $mysql_root_password = $password
}
