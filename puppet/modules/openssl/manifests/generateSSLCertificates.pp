define openssl::generateSSLCertificates (
  $numbits             = 2048,
  $aes                 = 256,
  $caFilepath          = '/etc/ssl/private/snakeOil_ca-key.pem',
  $rootCaFilepath      = '/etc/ssl/private/snakeOil_ca-root.pem',
  $certificateFilepath = '/etc/ssl/private/snakeOil_certificate',
  $commonname          = 'vagrant.local.de',
  $country             = 'DE',
  $state               = 'Saxony',
  $location            = 'Dresden',
  $password            = 'vagrant',
  $company             = 'example',
  $email               = 'example@example.de',
  $unit                = 'development',
  $expireDays          = 1024,
)
{
  exec { "generate ${caFilepath}":
    command => "openssl genrsa -aes${aes} -passout pass:${password}  -out ${caFilepath} ${numbits}",
  }

  exec { "generate ${rootCaFilepath}":
    command => "openssl req -x509 -new -nodes -extensions v3_ca -passin pass:${password} -key ${caFilepath} -days ${expireDays} -out ${rootCaFilepath} -sha512 -subj \"/C=${country}/ST=${state}/L=${location}/O=${company}/CN=${commonname}/emailAddress=${email}/OU=${unit}\"",
    require => Exec["generate ${caFilepath}"]
  }

  exec { "generate ${certificateFilepath}":
    command => "openssl genrsa -out ${certificateFilepath}-key.pem $numbits; openssl req -new -key ${certificateFilepath}-key.pem -out ${certificateFilepath}.csr -sha512 -subj \"/C=${country}/ST=${state}/L=${location}/O=${company}/CN=${commonname}/emailAddress=${email}/OU=${unit}\"",
    require => Exec["generate ${rootCaFilepath}"]
  }

  exec { "generate public key ${certificateFilepath}":
    command => "openssl x509 -req -passin pass:${password} -in ${certificateFilepath}.csr -CA $rootCaFilepath -CAkey $caFilepath -CAcreateserial -out ${certificateFilepath}-pub.pem -days ${expireDays} -sha512",
    require => Exec["generate ${certificateFilepath}"]
  }

  exec { "set rights ${certificateFilepath}":
    command => "chmod 755 ${caFilepath}; chmod 755 ${rootCaFilepath}; chmod 755 ${certificateFilepath}-key.pem; chmod 755 ${certificateFilepath}.csr",
    require => Exec["generate ${certificateFilepath}"]
  }
}
