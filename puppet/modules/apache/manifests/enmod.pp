define apache::enmod($mod) {
  exec { "enable mode ${mod}":
    command => "a2enmod ${mod}",
    require => Package['apache2'],
    notify  => Service['apache2']
  }
}
