define mysql::db_create ($databasename) {
  exec { "create DB ${databasename}":
    command => "mysql -u root -e \"CREATE DATABASE ${databasename}\"",
    require => Package['mysql-server', 'mysql-client']
  }
}
