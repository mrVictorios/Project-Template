### Apache PHP Mongo Template
#
#   Default Template
#
#   include:  Apache
#             PHP 5.5 with xdebug
#             Mongo
#

### Paths
Exec { path => [ "/usr/local/sbin", "/usr/local/bin", "/usr/sbin", "/usr/bin", "/sbin", "/bin" ] }

### stages
stage { 'update' : before => Stage['main'] }

### modules
class { "system" : stage => update }
class { "apache" : stage => main }
class { "php5"   : stage => main }
class { "mongo"  : stage => main }

### configuration

$servername     = 'www.vagrant.local'

system::copy { "copy project":
  source      => '/vagrant/src/*',
  destination => '/var/www',
  require     => Package['apache2','mongodb']
}

system::cleanup { "clean up":
  require => System::Copy['copy project']
}


# certificates
$caFilepath          = "/etc/apache2/${servername}_ca-key.pem"
$rootCaFilepath      = "/etc/apache2/${servername}_ca-root.pem"
$certificateFilepath = "/etc/apache2/${servername}_certificate"

openssl::generateSSLCertificates { "default SSL Certificates":
  caFilepath          => $caFilepath,
  rootCaFilepath      => $rootCaFilepath,
  commonname          => $servername,
  certificateFilepath => $certificateFilepath,
  require             => Package['apache2'],
}

# apache

apache::vhost { "add vhost ${servername}":
  servername        => $servername,
  ssl               => true,
  ssl_cert_file     => "${certificateFilepath}-pub.pem",
  ssl_cert_key_file => "${certificateFilepath}-key.pem",
}

apache::enmod { "enable ssl support"    : mod => 'ssl' }
apache::enmod { "enable rewrite support": mod => 'rewrite' }

# php
package { "php5-mongo":
    require => Package['php5']
}

php5::xdebug      { "install and configure xdebug": }

#mongo
mongo::import  { "import test dump":
  database => 'test',
  filepath => '/vagrant/puppet/database/mongo/dump/test'
}

mongo::addUser { "mongo user": }
