class skyline inherits skyline::params {

  $system_packages = [
    'python-pip',
    'python-numpy',
    'python-scipy',
    $redis_package,
    'python-redis',
    'git',
  ]

  $python_packages = [
    'hiredis',
    'python-daemon',
    'flask',
    'simplejson',
    'pandas',
    'patsy',
    'msgpack_python',
    'unittest2',
    'mock',
  ]

  $directories = [
    '/var/log/skyline',
    '/var/run/skyline',
    '/var/log/redis',
    '/var/dump',
  ]

  package { $system_packages:
    ensure  => installed,
  }

  package { $python_packages:
    ensure   => installed,
    provider => pip,
    require  => Package['python-pip'],
  }

  package { "statsmodels":
    ensure   => installed,
    provider => pip,
    require  => Package['patsy'],
  }

  file { $directories:
    ensure => directory,
  }

  vcsrepo { '/opt/skyline':
    ensure   => present,
    provider => 'git',
    source   => 'https://github.com/etsy/skyline.git',
    require  => Package['git'],
  }

  file { '/opt/skyline/src/settings.py':
    ensure  => present,
    content => template('skyline/settings.py.erb'),
  }

  include skyline::service

}
