class skyline::service {

  Service {
    ensure   => running,
    provider => 'upstart',
  }

  service { 'redis-server':
    ensure  => stopped,
    require => Package['redis-server'],
  } ->
  file { '/etc/init.d/redis-server':
    ensure => absent,
  } ->
  file { '/etc/init/skyline-redis.conf':
    ensure  => present,
    content => template('skyline/init/redis.conf.erb'),
  } ~>
  service { 'skyline-redis':
    ensure => running,
  } ->
  file { '/etc/init/skyline-horizon.conf':
    ensure  => present,
    content => template('skyline/init/horizon.conf.erb'),
  } ~>
  service { 'skyline-horizon': } ->
  file { '/etc/init/skyline-analyzer.conf':
    ensure => present,
    content => template('skyline/init/skyline-analyzer.conf.erb'),
  } ~>
  service { 'skyline-analyzer': } ->
  file { '/etc/init/skyline-webapp.conf':
    ensure => present,
    content => template('skyline/init/skyline-webapp.conf.erb'),
  } ~>
  service { 'skyline-webapp': }

}
