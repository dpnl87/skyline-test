class skyline inherits skyline::params {

  $system_packages = [
    'python-pip',
    $python_dev_pkg,
    $redis_package,
    'python-redis',
    'git',
    'python-nose',
  ]

  # $python_packages = [
  #   'hiredis',
  #   'python-daemon',
  #   'flask',
  #   'simplejson',
  #   'unittest2',
  #   'mock',
  # ]

  $directories = [
    '/var/log/skyline',
    '/var/run/skyline',
    '/var/log/redis',
    '/var/dump',
  ]

  package { $system_packages:
    ensure  => installed,
  }

  # package { $python_packages:
  #   ensure   => installed,
  #   provider => pip,
  #   require  => Package['python-pip'],
  # }

  package { "numpy":
    ensure   => installed,
    provider => pip,
    require  => Package['python-pip'],
  }

  package { "scipy":
    ensure   => installed,
    provider => pip,
    require  => Package['numpy'],
  }

  package { "pandas":
    ensure   => installed,
    provider => pip,
    require  => Package['scipy'],
  }

  package { "patsy":
    ensure   => installed,
    provider => pip,
    require  => Package['pandas'],
  }

  package { "statsmodels":
    ensure   => installed,
    provider => pip,
    require  => Package['patsy'],
  }

  package { "msgpack_python":
    ensure   => installed,
    provider => pip,
    require  => Package['statsmodels'],
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
