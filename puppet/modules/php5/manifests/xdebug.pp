define php5::xdebug(
  $remote_enable       = true,
  $remote_handler      = "dbgp",
  $remote_port         = 9000,
  $remote_autostart    = true,
  $remote_connect_back = true) {

  $module_path = false

  package { "php5-xdebug":
    require => Package['php5-dev']
  }

  exec { "get php extension dictionary for xdebug":
    command   => 'php-config --extension-dir',
    require   => Package['php5', 'php5-dev', 'php5-xdebug'],
    logoutput => $module_path
  }

  file { "/etc/php5/mods-available/xdebug.ini":
    ensure      => present,
    content     => template("php5/xdebug.erb"),
    require     => [Package['php5','php5-xdebug'], Exec['get php extension dictionary for xdebug']],
  }

  php5::enmod { "enable xdebug":
    modulename => 'xdebug',
    notify     => Service['apache2']
  }
}
