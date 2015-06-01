class composer {
  exec { "get composer":
    command => 'curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer'
  }
}
