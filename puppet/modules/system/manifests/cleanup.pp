define system::cleanup() {
  exec { "set permissions":
      command => "chown -R www-data:www-data /var/www && chmod -R 775 /var/www"
  }
}
