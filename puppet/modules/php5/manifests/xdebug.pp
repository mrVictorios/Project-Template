define php5::xdebug(
  $idekey             = 'PHPSTORM',
  $remote_enable             = true,
  $remote_handler            = 'dbgp',
  $remote_port               = 9000,
  $remote_autostart          = true,
  $remote_connect_back       = true,
  $remote_cookie_expire_time = 3600,
  $remote_host               = 'localhost',
  $remote_log                = '',
  $remote_mode               = 'req',
  $collect_assignments       = false,
  $collect_includes          = true,
  $collect_params            = 0,
  $collect_return            = false,
  $collect_vars              = false,
  $profiler_enable           = false,
  $profiler_enable_trigger   = false,
  $profiler_output_dir       = '/tmp',
  $profiler_output_name      = 'cachegrind.out%p',
  $profiler_aggregate        = false,
  $profiler_append           = false,
  $dump_COOKIE               = '',
  $dump_ENV                  = '',
  $dump_FILES                = '',
  $dump_GET                  = '',
  $dump_POST                 = '',
  $dump_SESSION              = '',
  $dump_globals              = true,
  $dump_once                 = true,
  $dump_undefined            = false,
  $trace_enable_trigger      = false,
  $trace_format              = 0,
  $trace_options             = 0,
  $trace_output_dir          = '/tmp',
  $trace_output_name         = 'trace.%c',
  $var_display_max_children  = 128,
  $var_display_max_data      = 512,
  $var_display_max_depth     = 3,
  $scream                    = false,
  $auto_trace                = false,
  $show_exception_trace      = false,
  $show_local_vars           = false,
  $show_mem_delta            = false,
  $extended_info             = true,
  $coverage_enable           = true,
  $max_nesting_level         = 100,
  $overload_var_dump         = true
) {

  package { "php5-xdebug":
    require => Package['php5-dev']
  }

  file { "/etc/php5/mods-available/xdebug.ini":
    ensure  => present,
    content => template("php5/xdebug.erb"),
    require => Package['php5', 'php5-xdebug'],
  }

  exec { "set xdebug path":
    command => "echo \"zend_extension = $(php-config --extension-dir)/xdebug.so\" >> /etc/php5/mods-available/xdebug.ini",
    require => [File['/etc/php5/mods-available/xdebug.ini'], Package['php5-xdebug']]
  }

  php5::enmod { "enable xdebug":
    modulename => 'xdebug',
    notify     => Service['apache2'],
    require    => Exec['set xdebug path']
  }
}
