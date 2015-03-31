define apache::ensite($conf) {
  exec { "enable ${conf}":
    command => "a2ensite ${conf}.conf",
    require => [ Package['apache2'], File["/etc/apache2/sites-available/${conf}.conf"] ],
    notify  => Service['apache2']
  }
}
