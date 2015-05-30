define mongo::import (
  $database = '',
  $filepath = '',
) {
  exec { "import mongo dump ${filepath} to ${database}":
    command => "mongorestore --drop -d ${database} ${filepath}",
    require => [Service['mongodb'], Package['mongodb', 'mongodb-clients']]
  }
}
