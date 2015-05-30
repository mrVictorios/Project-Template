define mongodb::add_user (
  $user     = 'vagrant',
  $password = 'vagrant',
  $database = 'test'
) {

  file { "/addUser_${user}.js":
    ensure  => present,
    content => template('mongodb/addUser.erb'),
    require => Package[ 'mongodb','mongodb-clients']
  }

  exec { "add user ${user} to db":
    command => "mongo < /addUser_${user}.js",
    require => [Package['mongodb', 'mongodb-clients'], File["/addUser_${user}.js"]]
  }

  exec { "remove script ${user}":
    command => "rm /addUser_${user}.js",
    require => Exec["add user ${user} to db"]
  }

}
