define php5::enmod (
  $modulename
) {
  exec { "enable php5 module ${modulename}":
    command => "php5enmod ${modulename}",
    require => Package['php5']
  }
}
