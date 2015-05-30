class mongo {
  package { ["mongodb", "mongodb-clients"]:
    ensure  => installed,
    notify  => Service['mongodb'],
    require => Exec["update sources ${operatingsystem}"]
  }

  service { "mongodb":
    ensure => running,
    require => Package['mongodb', "mongodb-clients"]
  }
}
