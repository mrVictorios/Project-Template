define composer::update ($path)
{
  exec { "run composer update on $path":
    command => 'php composer.phar update',
    cwd     => $path
  }
}
