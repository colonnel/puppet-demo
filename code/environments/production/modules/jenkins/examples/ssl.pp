## first generate a certificate
## puppet cert generate jenkins.hacklab

java_ks { 'jenkins_keystore_base':
  ensure       => latest,
  certificate  => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
  target       => '/opt/jenkins.ks',
  password     => 'puppet',
  trustcacerts => true,
}

java_ks { 'jenkins_keystore_certs':
  ensure              => latest,
  certificate         => '/etc/puppetlabs/puppet/ssl/certs/jenkins.hacklab.pem',
  private_key         => '/etc/puppetlabs/puppet/ssl/private_keys/jenkins.hacklab.pem',
  private_key_type    => 'rsa',
  target              => '/opt/jenkins.ks',
  password            => 'puppet',
  password_fail_reset => true,
}

class { 'jenkins':
  enable_https            => true,
  http_listen_address     => '192.168.250.80',
  https_listen_address    => '192.168.250.80',
  https_port              => 8081,
  https_keystore          => '/opt/jenkins.ks',
  https_keystore_password => 'puppet',
}

## now you can access
##   access https://jenkins.hacklab:8081
