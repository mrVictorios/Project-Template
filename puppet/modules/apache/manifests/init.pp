class apache {
  package { "apache2":
    ensure  => present,
    require => Exec["update sources ${operatingsystem}"]
  }

  service { "apache2":
    ensure => running,
    require => Package['apache2']
  }
}
