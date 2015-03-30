class system
{
  case $operatingsystem {
    'Debian', 'Ubuntu': { $packageManager = 'apt-get' }
  }

  exec { "update sources ${operatingsystem}":
    command => "${packageManager} update"
  }

  package {['mc','vim','htop', 'openssl', 'ssl-cert']:
    ensure  => present,
    require => Exec["update sources ${operatingsystem}"]
  }
}
