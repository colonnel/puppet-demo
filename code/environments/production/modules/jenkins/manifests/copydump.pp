class jenkins::copydump {

    file { '/var/lib/jenkins.tar.gz':
    ensure => present,
    mode   => '0600',
    source => 'puppet:///files/jenkins/files/jenkins.tar.gz',
    before => Exec['unpack_jenkins_dump'],
        }

    exec {'unpack_jenkins_dump':
    command => '/bin/tar -zxvf /var/lib/jenkins.tar.gz -C /var/lib',
         }

}
