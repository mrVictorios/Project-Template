define mongo::addUser (
  $user     = 'vagrant',
  $password = 'vagrant',
  $database = 'test'
) {

  file { "/addUser_${user}.js":
    ensure  => present,
    content => template('mongo/addUser.erb'),
    require => Package['mongodb-clients', 'mongodb']
  }

  exec { "add user ${user} to db":
    command => "mongo < /addUser_${user}.js",
    require => [Service['mongodb'], Package['mongodb-clients', 'mongodb'], File["/addUser_${user}.js"]]
  }

  exec { "remove script ${user}":
    command => "rm /addUser_${user}.js",
    require => Exec["add user ${user} to db"]
  }

}
