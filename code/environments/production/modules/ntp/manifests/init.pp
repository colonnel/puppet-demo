class ntp {
 package { 'ntp':
  ensure => installed,
 }
 service { 'ntp':
  ensure  => running,
  enable  => true,
  require => Package[ntp],
 }
}

