class slave {


 class { '::mysql::server':
    remove_default_accounts => true,
    override_options        => {
    'mysqld' => {
     'bind-address'                     => '0.0.0.0',
     'server-id'                        => '2',
     'binlog-format'                    => 'mixed',
     'log-bin'                          => 'mysql-bin',
     'datadir'                          => '/var/lib/mysql',
     'innodb_flush_log_at_trx_commit'   => '1',
     'sync_binlog'                      => '1',
     'binlog-do-db'                     => ['app_db'],
   }
  }
 }


 mysql_user { 'slave_user@%':
    ensure        => 'present',
    password_hash => mysql_password('123'),
    }


 mysql_grant { 'slave_user@%/*.*':
    ensure     => 'present',
    privileges => ['REPLICATION SLAVE'],
    table      => '*.*',
    user       => 'slave_user@%',
    }


mysql_grant { 'dbuser@%/*.*':
    ensure     => 'present',
    privileges => ['RELOAD, SUPER, SHOW DATABASES, REPLICATION CLIENT'],
    table      => '*.*',
    user       => 'dbuser@%',
    }


 mysql::db { 'app_db':
  user => 'dbuser',
  password => '*23AE809DDACAF96AF0FD78ED04B6A265E05AA257',
  host => '%',
  }





}
