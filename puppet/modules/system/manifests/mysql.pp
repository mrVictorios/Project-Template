define system::mysql(
  $mysql_password,
  $mysql_database
) {
  file { "/mysql_update.sh":
    ensure  => present,
    content => template("system/mysql_update.erb"),
    mode    => "0755"
  }

  exec { "register mysql autoupdate":
    command => "echo \"@reboot root /mysql_update.sh\" >> /etc/crontab",
    require => File['/mysql_update.sh']
  }
}
