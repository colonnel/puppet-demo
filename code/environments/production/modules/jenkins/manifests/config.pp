class jenkins::config {

  augeas {'jenkins_homedir':
    context => '/files/etc/sysconfig/jenkins',
    changes => [ "set JENKINS_HOME '\"${jenkins::homedir}\"'", ],
    notify  => Service['jenkins']
  }

  if $jenkins::java_cmd {
    augeas {'jenkins_java_cmd':
      context => '/files/etc/sysconfig/jenkins',
      changes => [ "set JENKINS_JAVA_CMD '\"${jenkins::java_cmd}\"'", ],
      notify  => Service['jenkins']
    }
  }

  augeas {'jenkins_user':
    context => '/files/etc/sysconfig/jenkins',
    changes => [ "set JENKINS_USER '\"${jenkins::user}\"'", ],
    notify  => Service['jenkins']
  }

  augeas {'jenkins_java_args':
    context => '/files/etc/sysconfig/jenkins',
    changes => [ "set JENKINS_JAVA_OPTIONS '\"${jenkins::java_args}\"'", ],
    notify  => Service['jenkins']
  }

  augeas {'jenkins_http_port':
    context => '/files/etc/sysconfig/jenkins',
    changes => [ "set JENKINS_PORT '\"${jenkins::http_port}\"'", ],
    notify  => Service['jenkins']
  }

  augeas {'jenkins_http_listen_address':
    context => '/files/etc/sysconfig/jenkins',
    changes => [ "set JENKINS_LISTEN_ADDRESS '\"${jenkins::http_listen_address}\"'", ],
    notify  => Service['jenkins']
  }

  if $jenkins::enable_https {
    augeas {'jenkins_https_port':
      context => '/files/etc/sysconfig/jenkins',
      changes => [ "set JENKINS_HTTPS_PORT '\"${jenkins::https_port}\"'", ],
      notify  => Service['jenkins']
    }
    augeas {'jenkins_https_keystore':
      context => '/files/etc/sysconfig/jenkins',
      changes => [ "set JENKINS_HTTPS_KEYSTORE '\"${jenkins::https_keystore}\"'", ],
      notify  => Service['jenkins']
    }
    augeas {'jenkins_https_keystore_password':
      context => '/files/etc/sysconfig/jenkins',
      changes => [ "set JENKINS_HTTPS_KEYSTORE_PASSWORD '\"${jenkins::https_keystore_password}\"'", ],
      notify  => Service['jenkins']
    }
    augeas {'jenkins_https_listen_address':
      context => '/files/etc/sysconfig/jenkins',
      changes => [ "set JENKINS_HTTPS_LISTEN_ADDRESS '\"${jenkins::https_listen_address}\"'", ],
      notify  => Service['jenkins']
    }
  }

  augeas {'jenkins_debug_level':
    context => '/files/etc/sysconfig/jenkins',
    changes => [ "set JENKINS_DEBUG_LEVEL '\"${jenkins::debug}\"'", ],
    notify  => Service['jenkins']
  }

  augeas {'jenkins_enable_access_log':
    context => '/files/etc/sysconfig/jenkins',
    changes => [ "set JENKINS_ENABLE_ACCESS_LOG '\"${jenkins::enable_access_log}\"'", ],
    notify  => Service['jenkins']
  }

  augeas {'jenkins_handler_max':
    context => '/files/etc/sysconfig/jenkins',
    changes => [ "set JENKINS_HANDLER_MAX '\"${jenkins::handler_max}\"'", ],
    notify  => Service['jenkins']
  }

  augeas {'jenkins_handler_idle':
    context => '/files/etc/sysconfig/jenkins',
    changes => [ "set JENKINS_HANDLER_IDLE '\"${jenkins::handler_idle}\"'", ],
    notify  => Service['jenkins']
  }

  if $jenkins::args {
    augeas {'jenkins_args':
      context => '/files/etc/sysconfig/jenkins',
      changes => [ "set JENKINS_ARGS '\"${jenkins::args}\"'", ],
      notify  => Service['jenkins']
    }
  }

}
