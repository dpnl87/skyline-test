class skyline::params {

  $oculus_host    = ''
  $graphite_host  = ''
  $carbon_port    = 2003
  $horizon_ip     = '127.0.0.1'
  $webapp_ip      = '127.0.0.1'
  $webapp_port    = 1500

  case $::osfamily {
    'RedHat': {
      $redis_package = 'redis'
    }
    'Debian': {
      $redis_package = 'redis-server'
    }
  }

}
