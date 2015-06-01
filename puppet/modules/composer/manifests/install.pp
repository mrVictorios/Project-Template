define composer::install ($path)
{
  exec { "run composer install on $path":
    command => 'php composer.phar install',
    cwd     => $path
  }
}
