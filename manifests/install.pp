# == Class test::install
#
class test::install {

  $system_packages = [
    'python-pip',
    'python-numpy',
    'python-scipy',
    'redis-server',
    'git',
  ]

  $python_packages = [
    'redis',
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
    require => Apt::Source['debian'],
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
    notify  => Class['skyline::service'],
  }

}
