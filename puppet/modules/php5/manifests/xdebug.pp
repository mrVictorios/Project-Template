define php5::xdebug(
  $remote_enable       = true,
  $remote_handler      = "dbgp",
  $remote_port         = 9000,
  $remote_autostart    = true,
  $remote_connect_back = true) {

  package { "php5-xdebug":
    require => Package['php5-dev']
  }

  file { "/etc/php5/mods-available/xdebug.ini":
    ensure  => present,
    content => template("php5/xdebug.erb"),
    require => Package['php5', 'php5-xdebug'],
  }

  exec { "set xdebug path":
    command => "/bin/bash -c \"export phpextension=$(php-config --extension-dir); echo \"zend_extension = \\\${phpextension}/xdebug.so\" >> /etc/php5/mods-available/xdebug.ini\"",
    require => File['/etc/php5/mods-available/xdebug.ini']
  }

  php5::enmod { "enable xdebug":
    modulename => 'xdebug',
    notify     => Service['apache2'],
    require    => Exec['set xdebug path']
  }
}
