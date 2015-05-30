class php5 {
  package { ['php5', 'php5-cli', 'php5-dev', 'libapache2-mod-php5']:
    ensure  => installed,
    require => Package['apache2'],
  }
}
