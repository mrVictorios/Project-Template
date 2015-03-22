class mysql {
  package { ["mysql-server", "mysql-client"]:
    ensure  => installed,
    require => Exec["update sources ${operatingsystem}"]
  }
}
