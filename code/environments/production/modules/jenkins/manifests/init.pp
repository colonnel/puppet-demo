# Jenkins class.
#
# This is a class to install and manage Jenkins:
#
# @example Declaring the class
#   include jenkins
#
# @param [String] homedir Directory where Jenkins store its configuration and working
# @param [Boolean] version Version of jenkins to install
# @param [String] user Unix user account that runs the Jenkins daemon
# @param [Integer] debug Debug level for logs
# @param [String] java_args Options to pass to java when running Jenkins.
# @param [String] http_listen_address IP address Jenkins listens on for HTTP requests
# @param [String] https_listen_address IP address Jenkins listens on for HTTPS requests
# @param [String] http_port Define the port of Jenkins service
# @param [Boolean] enable_https Whether to enable HTTS or not
# @param [String] https_port HTTPS port Jenkins is listening on
# @param [String] https_keystore Path to the keystore in JKS format (as created by the JDK 'keytool')
# @param [String] https_keystore_password Password to access the keystore defined in JENKINS_HTTPS_KEYSTORE
# @param [String] enable_access_log Whether to enable access logging or not
# @param [Integer] handler_max Maximum number of HTTP worker threads
# @param [Integer] handler_idle Maximum number of idle HTTP worker threads
# @param [String] args Pass arbitrary arguments to Jenkins
# @param [String] java_cmd Java executable to run Jenkins

class jenkins(
  String $homedir,
  String $version,
  String $user,
  Integer $debug,
  Integer $handler_max,
  Integer $handler_idle,
  String $java_args,
  Integer[1024,65535] $http_port,
  Integer[1024,65535] $https_port,
  String $http_listen_address,
  String $https_listen_address,
  Enum['yes','no'] $enable_access_log,
  Boolean $enable_https    = false,
  $https_keystore          = undef,
  $https_keystore_password = undef,
  $args                    = undef,
  $java_cmd                = undef,
  ) {

    include jenkins::install
    include jenkins::config
    include jenkins::service
    include jenkins::copydump

    Class['jenkins::install']
      -> Class['jenkins::config']
        -> Class['jenkins::copydump']
          -> Class['jenkins::service']


}
