define php::xdebug(
  $remote_enable       = true,
  $remote_handler      = "dbgp",
  $remote_port         = 9000,
  $remote_autostart    = true,
  $remote_connect_back = true) {

  $module_path = false

  package { "php5-xdebug":
    require => Package['php5-dev']
  }
}
