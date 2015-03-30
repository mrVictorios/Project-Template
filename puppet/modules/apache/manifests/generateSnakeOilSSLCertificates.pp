define apache::generateSnakeOilSSLCertificates (
  $numbits             = 2048,
  $aes                 = 256,
  $caFilepath          = '/etc/ssl/private/snakeOil_ca-key.pem',
  $rootCaFilepath      = '/etc/ssl/private/snakeOil_ca-root.pem',
  $certificateFilepath = '/etc/ssl/private/snakeOil_certificate',
  $servername          = 'vagrant.local.de',
  $counter             = 'DE',
  $state               = 'Saxony',
  $location            = 'Dresden',
  $password            = 'vagrant',
  $company             = 'example',
  $email               = '',
  $unit                = '',
  $expireDays          = 1024,
)
{
  exec { "generate ${caFilepath}":
    command => "openssl genrsa -aes${aes} -passout pass:vagrant  -out ${caFilepath} ${numbits}",
  }

  exec { "generate ${rootCaFilepath}":
    command => "openssl req -x509 -new -nodes -extensions v3_ca -passin pass:vagrant -key ${caFilepath} -days ${expireDays} -out ${rootCaFilepath} -sha512 -subj \"/C=DE/ST=Saxony/L=Springfield/O=Dis/CN=${servername}\"",
    require => Exec["generate ${caFilepath}"]
  }

  exec { "generate ${certificateFilepath}":
    command => "openssl genrsa -out ${certificateFilepath}-key.pem $numbits; openssl req -new -key ${certificateFilepath}-key.pem -out ${certificateFilepath}.csr -sha512 -subj \"/C=DE/ST=Saxony/L=Springfield/O=Dis/CN=${servername}\"",
    require => Exec["generate ${rootCaFilepath}"]
  }

  exec { "generate public key ${certificateFilepath}":
    command => "openssl x509 -req -passin pass:vagrant -in ${certificateFilepath}.csr -CA $rootCaFilepath -CAkey $caFilepath -CAcreateserial -out ${certificateFilepath}-pub.pem -days ${expireDays} -sha512",
    require => Exec["generate ${certificateFilepath}"]
  }

  exec { "set rights":
    command => "chmod 777 ${caFilepath}; chmod 777 ${rootCaFilepath}; chmod 77 ${certificateFilepath}-key.pem; chmod 777 ${certificateFilepath}.csr",
    require => Exec["generate ${certificateFilepath}"]
  }
}
