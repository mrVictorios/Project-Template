define mysql::root ($password = 'vagrant') {
  exec { "set mysql root password":
    command => "mysqladmin -u root password '${password}'",
    require => Package['mysql-server', 'mysql-client']
  }
}
