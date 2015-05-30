define mongodb::import (
  $database = '',
  $filepath = '',
) {
  exec { "import mongo dump ${filepath} to ${database}":
    command => "mongorestore --drop -d ${database} ${filepath}",
    require => Package['mongodb', 'mongodb-clients']
  }
}
