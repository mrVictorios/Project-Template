define system::copy ($source, $destination) {
  exec { "copy ${source} _> ${destination}":
    command => "cp -a ${source} ${destination}"
  }
}
