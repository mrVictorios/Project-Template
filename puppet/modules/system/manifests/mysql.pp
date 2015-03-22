define system::mysql(
  $mysql_password,
  $mysql_database
) {
  file { "/mysql_vagrant_update.sh":
    ensure  => present,
    content => template("system/mysql_vagrant_update.erb"),
  }

  exec { "register mysql autoupdate":
    command => "echo \"@reboot sh /mysql_vagrant_update.sh \" >> /etc/crontab",
    require => File['/mysql_vagrant_update.sh']
  }
}
