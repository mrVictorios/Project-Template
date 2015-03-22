define apache::ensite($site) {
  exec { "enable ${site}":
    command => "a2ensite ${site}.conf",
    require => [ Package['apache2'], File["/etc/apache2/sites-available/${site}.conf"] ],
    notify  => Service['apache2']
  }
}
