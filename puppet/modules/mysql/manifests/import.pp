define mysql::import (
  $database = '',
  $filepath = '',
) {
  exec { "import mysql dump ${filepath} to ${database}":
    command => "mysql -u root ${database} < ${filepath}",
    require => Package['mysql-server', 'mysql-client']
  }
}
