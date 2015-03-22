class php {
  package { ['php5', 'php5-cli', 'php5-mysql', 'php5-dev', 'libapache2-mod-php5']:
    ensure  => installed,
    require => Package['apache2'],
  }
}
