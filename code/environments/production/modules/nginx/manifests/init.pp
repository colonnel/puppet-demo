class nginx {
 package { 'nginx':
  ensure => installed,
 }
 service { 'nginx':
  ensure  => running,
  enable  => true,
  require => Package[nginx],
 }
 file { 'app4.conf':
  ensure  => present,
  path    => '/etc/nginx/sites-available/default',
  source  => 'puppet:///modules/files/app4.conf',
  replace => true,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  notify  => Service['nginx'],
 }
}

