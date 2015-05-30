class mongodb {
  package { ["mongodb", "mongodb-clients"]:
    ensure  => installed,
    require => Exec["update sources ${operatingsystem}"]
  }
}
