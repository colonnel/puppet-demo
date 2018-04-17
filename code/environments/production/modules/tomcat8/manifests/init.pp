class { '::tomcat': }

class tomcat8 {
tomcat::instance { 'tom':
  catalina_home => '/opt/tomcat-8.5',
  source_url    => 'https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.28/bin/apache-tomcat-8.5.28.tar.gz',
  catalina_base => '/opt/tomcat-8.5',
}
->tomcat::config::server::tomcat_users {
  'tet-role-manager-script':
    ensure        => present,
    catalina_base => '/opt/tomcat-8.5',
    element       => 'role',
    element_name  => 'manager-script';
  'tet-user-mzol':
    ensure        => present,
    catalina_base => '/opt/tomcat-8.5',
    element       => 'user',
    element_name  => 'tom',
    password      => 'tom',
    roles         => ['manager-script'];
   }
}
