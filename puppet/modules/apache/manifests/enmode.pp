define apache::enmode($mode) {
  exec { "enable mode ${mode}":
    command => "a2enmode ${mode}",
    require => Package['apache2'],
    notify  => Service['apache2']
  }
}
