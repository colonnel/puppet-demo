# Definition: tomcat::instance
#
# This define installs an instance of Tomcat.
#
# Parameters:
# - $catalina_home is the root of the Tomcat installation. This parameter only
#   affects the instance when $install_from_source is true. Default:
#   $tomcat::catalina_home
# - $catalina_base is the base directory for the Tomcat instance if different
#   from $catalina_home. This parameter only affects the instance when
#   $install_from_source is true. Default: $catalina_home
# - $install_from_source is a boolean specifying whether or not to install from
#   source. Defaults to true.
# - The $source_url to install from. Required if $install_from_source is true.
# - $source_strip_first_dir is a boolean specifying whether or not to strip
#   the first directory when unpacking the source tarball. Defaults to true
#   when installing from source. Requires puppet/archive
# - $package_ensure when installing from package, what the ensure should be set
#   to in the package resource.
# - $package_name is the name of the package you want to install. Required if
#   $install_from_source is false.
# - $package_options to pass extra options to the package resource.
# - $user is the owner of the tomcat home and base. Default: $tomcat::user
# - $group is the group of the tomcat home and base. Default: $tomcat::group
# - $manage_dirs is whether to manage sub-directories under $catalina_base. Default: true
# - $dir_list is an array of sub-directories to manage under $catalina_base.
#   Disable vai $manage_dirs. Default: ['bin','conf','lib','logs','temp','webapps','work']
# - $dir_mode is the mode to use for sub-directories under $catalina_base. Default: '2770'
# - $manage_copy_from_home is whether to copy initial files from $catalina_home
#    to $catalina_base. Default: true
# - $copy_from_home_list is an optional custom list of files to copy from $catalina_home
#    to $catalina_base.  Supports log4j.
#    Default: catalina.policy, context.xml, logging.properties, server.xml, web.xml
# - $copy_from_home_mode is the mode to use when copying initial files from $catalina_home
#    to $catalina_base. Defaults to '0660'

define tomcat::instance (
  $catalina_home          = undef,
  $catalina_base          = undef,
  $user                   = undef,
  $group                  = undef,
  $manage_user            = undef,
  $manage_group           = undef,
  $manage_service         = undef,
  $manage_base            = undef,
  $manage_properties      = undef,
  $java_home              = undef,
  $use_jsvc               = undef,
  $use_init               = undef,
  $manage_dirs            = true,
  $dir_list               = ['bin','conf','lib','logs','temp','webapps','work'],
  $dir_mode               = '2770',
  $manage_copy_from_home  = true,
  $copy_from_home_list    = undef,
  $copy_from_home_mode    = '0660',

  #used for single installs. Deprecated.
  $install_from_source    = undef,
  $source_url             = undef,
  $source_strip_first_dir = undef,
  $package_ensure         = undef,
  $package_name           = undef,
  $package_options        = undef,
) {
  include ::tomcat
  $_catalina_home = pick($catalina_home, $::tomcat::catalina_home)
  $_catalina_base = pick($catalina_base, $_catalina_home) #default to home
  tag(sha1($_catalina_home))
  tag(sha1($_catalina_base))
  $_user = pick($user, $::tomcat::user)
  $_group = pick($group, $::tomcat::group)
  $_manage_user = pick($manage_user, $::tomcat::manage_user)
  $_manage_group = pick($manage_group, $::tomcat::manage_group)
  $_manage_base = pick($manage_base, $::tomcat::manage_base)
  $_manage_properties = pick($manage_properties, $::tomcat::manage_properties)

  if $source_url and $install_from_source == undef {
    # XXX Backwards compatibility mode enabled; install_from_source used to default
    # to true.
    $_install_from_source = true
  } else {
    # XXX If install_from_source is undef, then we're in multi-instance mode. If
    # it's true or false, then we're in backwards-compatible mode.
    $_install_from_source = $install_from_source
  }

  tomcat::instance::dependencies { $name:
    catalina_home => $_catalina_home,
    catalina_base => $_catalina_base,
  }

  if $_install_from_source != undef {
    warning('Passing install_from_source, source_url, source_strip_first_dir, package_ensure, package_name, or package_options to tomcat::instance is deprecated. Please use tomcat::install instead and point tomcat::instance::catalina_home there.') # lint:ignore:140chars
    # XXX This file resource is for backwards compatibility. Previously the base
    # class created this directory for source installs, even though it may never
    # be used. Users may have created source installs under this directory, so
    # it must exist. tomcat::install::source will take care of creating base.
    if $_catalina_base != $_catalina_home and $_manage_base {
      ensure_resource('file',$_catalina_home, {
        ensure => directory,
        owner  => $_user,
        group  => $_group,
      })
    }
    # XXX This is for backwards compatibility. Declare a tomcat install, but install
    # the software into the base instead of the home.
    tomcat::install { $name:
      catalina_home          => $_catalina_base,
      install_from_source    => $_install_from_source,
      source_url             => $source_url,
      source_strip_first_dir => $source_strip_first_dir,
      user                   => $_user,
      group                  => $_group,
      manage_user            => $_manage_user,
      manage_group           => $_manage_group,
      manage_home            => $_manage_base,
      package_ensure         => $package_ensure,
      package_name           => $package_name,
      package_options        => $package_options,
    }
    $_manage_service = pick($manage_service, false)
  } else {
    if $_catalina_home != $_catalina_base {
      if $_manage_user {
        ensure_resource('user', $_user, {
          ensure => present,
          gid    => $_group,
        })
      }
      if $_manage_group {
        ensure_resource('group', $_group, {
          ensure => present,
        })
      }

      if $_manage_base {
        # Configure additional instances in custom catalina_base
        file { $_catalina_base:
          ensure => directory,
          owner  => $_user,
          group  => $_group,
        }
      }
      if $manage_dirs {
        # Ensure install finishes before creating instances from it.
        $home_sha = sha1($_catalina_home)
        Tomcat::Install <| tag == $home_sha |> -> File <| tag == 'dir_list' |>
        $dir_list.each |$dir| {
          file { "${_catalina_base}/${dir}":
            ensure => directory,
            owner  => $_user,
            group  => $_group,
            mode   => $dir_mode,
            tag    => 'dir_list',
          }
        }
      }
      # Set default copy_from_home files list if not overridden; requires $_catalina_base
      if $copy_from_home_list == undef {
        $_copy_from_home_list = [
          "${_catalina_base}/conf/catalina.policy",
          "${_catalina_base}/conf/context.xml",
          "${_catalina_base}/conf/logging.properties",
          "${_catalina_base}/conf/server.xml",
          "${_catalina_base}/conf/web.xml",
        ]
      }
      else {
        $_copy_from_home_list = $copy_from_home_list
      }
      if $manage_copy_from_home {
        tomcat::instance::copy_from_home { $_copy_from_home_list:
          catalina_home => $_catalina_home,
          user          => $_user,
          group         => $_group,
          mode          => $copy_from_home_mode,
        }
      }
    }
    $_manage_service = pick($manage_service, true)
  }
  if $_manage_service {
    tomcat::service { $name:
      catalina_home => $_catalina_home,
      catalina_base => $_catalina_base,
      java_home     => $java_home,
      use_jsvc      => $use_jsvc,
      use_init      => $use_init,
      user          => $_user,
    }
  }
  if $_manage_properties {
    tomcat::config::properties { "${_catalina_base} catalina.properties":
      catalina_home => $_catalina_home,
      catalina_base => $_catalina_base,
      user          => $_user,
      group         => $_group,
    }
  }
}
