class skyline::params {

  $oculus_host    = ''
  $graphite_host  = ''
  $carbon_port    = 2003
  $horizon_ip     = '127.0.0.1'
  $webapp_ip      = '127.0.0.1'
  $webapp_port    = 1500

  case $::osfamily {
    'RedHat': {
      $redis_package  = 'redis'
      $python_dev_pkg = 'python-devel'
    }
    'Debian': {
      $redis_package  = 'redis-server'
      $python_dev_pkg = 'python-dev'
    }
  }

}
