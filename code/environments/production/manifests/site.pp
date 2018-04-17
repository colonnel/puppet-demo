node default{
  class { 'zabbix::agent':
  server => 'zabbix',}
  package {'openssh-server':
    require => installed,
  }
#include accounts
}
node demoapp{
  include tomcat8
  include java
  exec { 'start':
  command => '/opt/tomcat-8.5/bin/catalina.sh start',
  }
}
node 'jenkins2'{
 include jenkins
 include git
 include maven
}

node 'test'{
 include '::mysql::server'
}

node db{
  include core
#  $db_user = lookup(profiles::db::user)
#  $db_pass = lookup(profiles::db::pass)
#  notice($db_user)
  file {'/etc/zabbix/.my.cnf':
    source => 'puppet:///files/zabbix/files/.my.cnf',
    mode   => '0644',
    ensure => present,
  }
  file {'/etc/zabbix/zabbix_agentd.d/mysql.conf':
    source => 'puppet:///files/zabbix/files/mysql.conf',
    mode   => '0644',
    ensure => present,
  }
}
# class { '::mysql::server':
#   root_password           => '*23AE809DDACAF96AF0FD78ED04B6A265E05AA257',
#   remove_default_accounts => true,
#   override_options        => {
#    mysqld => {
# 	 bind-address => '0.0.0.0'} #Allow remote connections
# }
# }
# mysql::db { 'app_db':
#  user => 'dbuser',
#  password => '*23AE809DDACAF96AF0FD78ED04B6A265E05AA257',
#  host => '%',  }
#}

node db-slave{
  include 'slave'
}

