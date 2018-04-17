# Adding users 
class accounts {

  $username = 'ops'
  $rootgroup = $osfamily ? {
    'Debian'  => 'sudo',
    'RedHat'  => 'wheel',
    default   => warning('This distribution is not supported by the Accounts module'),
  }
  package { 'sudo':
    ensure => installed,
  }
  group { $username:
    ensure => 'present',
    gid    => '502',
  }

  user { $username:
    ensure     => present,
    home       => '/home/ops',
    shell      => '/bin/bash',
    managehome => true,
    gid        => '1001',
    groups     => [$rootgroup, $username],
    password   => '$1$T4Cr.OZ.$rRAWVd8DVK4WKIcqOHz36.',
  }
}
