# Class: skyline
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#  class { 'skyline': }
#
class skyline {

  $system_packages = [
    'python-pip',
    $skyline::params::python_dev_pkg,
    $skyline::params::redis_package,
    'python-redis',
    'git',
    'python-nose',
  ]

  $buils_tools = [
    'autoconf',
    'automake',
    'bison',
    'byacc',
    'cscope',
    'ctags',
    'cvs',
    'diffstat',
    'doxygen',
    'flex',
    'gcc-c++',
    'gcc-gfortran',
    'gettext',
    'indent',
    'intltool',
    'libtool',
    'patch',
    'patchutils',
    'rcs',
    'redhat-rpm-config',
    'rpm-build',
    'subversion',
    'swig',
    'systemtap',
    'blas-devel',
    'lapack-devel',
  ]

  $python_packages = [
    'hiredis',
    'python-daemon',
    'flask',
    'simplejson',
    'unittest2',
    'mock',
  ]

  $directories = [
    '/var/log/skyline',
    '/var/run/skyline',
    '/var/log/redis',
    '/var/dump',
  ]

  $required_scipy_packages = [
    Package['numpy'],
    Package['blas-devel'],
    Package['lapack-devel']
  ]

  package { [$system_packages, $buils_tools]:
    ensure  => installed,
  }

  package { $python_packages:
    ensure   => installed,
    provider => pip,
    require  => Package['python-pip'],
  }

  package { 'numpy':
    ensure   => installed,
    provider => pip,
    require  => Package['python-pip'],
  }

  package { 'scipy':
    ensure   => installed,
    provider => pip,
    require  => $required_scipy_packages,
    ,
  }

  package { 'pandas':
    ensure   => installed,
    provider => pip,
    require  => Package['scipy'],
  }

  package { 'patsy':
    ensure   => installed,
    provider => pip,
    require  => Package['pandas'],
  }

  package { 'statsmodels':
    ensure   => installed,
    provider => pip,
    require  => Package['patsy'],
  }

  package { 'msgpack_python':
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

  file { '/etc/redis.conf':
    ensure  => present,
    content => template('skyline/redis.conf.erb'),
    notify  => Service['redis'],
  }

  service { 'redis':
    ensure  => running,
    enable  => true,
    require => Package[$skyline::params::redis_package],
  }

  #include skyline::service

}
