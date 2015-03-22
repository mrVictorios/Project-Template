define apache::vhost(
  $servername        = "puppet",
  $port              = 80,
  $docroot           = "/var/www",
  $webmaster         = "webmaster@domain.tld",
  $ssl               = false,
  $ssl_only          = false,
  $ssl_port          = 443,
  $ssl_cert_file     = '',
  $ssl_cert_key_file = '',
  $vhostloglevel     = "warn") {

  if(!$ssl_only) {
    file { ['/etc/apache2/sites-available']:
      ensure  => directory,
      before  => File["/etc/apache2/sites-available/${servername}.conf"],
      require => Package["apache2"]
    }

    file { "/etc/apache2/sites-available/${servername}.conf":
      ensure  => present,
      content => template("apache/vhost.erb"),
      require => Package['apache2'],
      notify  => Service['apache2']
    }
  }

  if($ssl or $ssl_only) {
    $port = $ssl_port

    file { ['/etc/apache2/sites-available']:
      ensure  => directory,
      before  => File["/etc/apache2/sites-available/${servername}-ssl.conf"],
      require => Package["apache2"]
    }

    file { "/etc/apache2/sites-available/${servername}-ssl.conf":
      ensure  => present,
      content => template("apache/vhost.erb"),
      require => Package['apache2'],
      notify  => Service['apache2']
    }

    apache::ensite { "enable vhost-ssl":
      site => "${servername}-ssl"
    }
  }

  apache::ensite { "enable vhost":
    site => $servername
  }
}
