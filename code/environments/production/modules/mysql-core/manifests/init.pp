class mysqlprofile::mysqlmaster {

 class { '::mysql::server':
    restart                 => true,
    root_password           => '*BB46AE99452DD250C5A791F16CDD15AC36F1993A',#523
    remove_default_accounts => true,
    override_options        => {
    mysqld => {
      bind-address   => '0.0.0.0', #Allow remote connections
    #Replication settings
    'server-id'    => 1,
    'log_bin'      => '/var/log/mysql/mysql-bin.log',
    'binlog_do_db' => 'app_db',
   }

    mysql_user { 'slave_user@%':
     ensure        => 'present',
     password_hash => mysql_password('357'),
     }

  mysql_grant { 'slave_user@%/*.*':
  ensure     => 'present',
  privileges => ['REPLICATION SLAVE'],
  table      => '*.*',
  user       => 'slave_user@%',
        }

  }
 }

 mysql::db { 'app_db':
  user     => 'dbuser',
  password => '*23AE809DDACAF96AF0FD78ED04B6A265E05AA257',
  host     => '%',
  }
}
