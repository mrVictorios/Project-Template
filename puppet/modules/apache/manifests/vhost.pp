define apache::vhost(
  $servername        = "puppet",
  $port              = 80,
  $docroot           = "/var/www",
  $webmaster         = "webmaster@domain.tld",
  $ssl               = false,
  $ssl_only          = false,
  $ssl_port          = 443,
  $ssl_cert_file     = '/etc/ssl/certs/ssl-cert-snakeoil.pem',
  $ssl_cert_key_file = '/etc/ssl/private/ssl-cert-snakeoil.key',
  $vhostloglevel     = "warn") {

  if(!$ssl_only) {
    file { "/etc/apache2/sites-available/${servername}.conf":
      ensure  => present,
      content => template("apache/vhost.erb"),
      require => Package['apache2'],
      notify  => Service['apache2']
    }
  }

  if($ssl or $ssl_only) {
    file { "/etc/apache2/sites-available/${servername}-ssl.conf":
      ensure  => present,
      content => template("apache/vhost-ssl.erb"),
      require => Package['apache2'],
      notify  => Service['apache2']
    }

    apache::ensite { "enable vhost-ssl":
      site => "${servername}-ssl"
    }
  }

  apache::ensite { "enable vhost ${servername}":
    site => $servername
  }
}
