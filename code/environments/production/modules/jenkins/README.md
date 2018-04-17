[![Build Status](https://travis-ci.org/gutocarvalho/puppet-jenkins.svg?branch=master)](https://travis-ci.org/gutocarvalho/puppet-jenkins)  ![License](https://img.shields.io/badge/license-Apache%202-blue.svg) ![Version](https://img.shields.io/puppetforge/v/gutocarvalho/jenkins.svg) ![Downloads](https://img.shields.io/puppetforge/dt/gutocarvalho/jenkins.svg)

# jenkins

#### Table of contents

1. [Overview](#overview)
3. [Supported Platforms](#supported-platforms)
4. [Requirements](#requirements)
5. [Installation](#installation)
6. [Usage](#usage)
7. [References](#references)
8. [Development](#development)

## Overview

This module will install the latest jenkins 2 series in your system.

This module can also configure SSL for Jenkins.

This is a very simple module, usually used for development and test purposes.

Yes, you can use it in production, but it is a simple module, you may miss some parameters for production use.

The main objective is to install jenkins with minimal intervention in the default files.

Augeas resource type is used to change parameters inside the /etc/sysconfig/jenkins.

## Supported Platforms

This module was tested under these platforms

- EL 6 and 7

Tested only in X86_64 arch.  

## Requirements

- Puppet >= 5.0.0
- Hiera >= 3.4 (v5 format)

## Installation

via git

    # cd /etc/puppetlabs/code/environment/production/modules
    # git clone https://github.com/gutocarvalho/puppet-jenkins.git jenkins

via puppet

    # puppet module install gutocarvalho/jenkins

via puppetfile

    mod 'gutocarvalho-jenkins', '1.0.0'

## Usage

### Quick run

    puppet apply -e "include jenkins"

### Using with parameters

#### Example in EL 7 with no SSL

```
class { 'jenkins':
  http_listen_address     => '192.168.250.80',
  http_port               => 8080,
}
```

#### Example in EL 7 with SSL enabled

```
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
  http_port               => 8080,
  https_port              => 8081,
  https_keystore          => '/opt/jenkins.ks',
  https_keystore_password => 'puppet',
}

## now you can access
##   access https://jenkins.hacklab:8081
```

## References

### Classes

```
jenkins
jenkins::install (private)
jenkins::config (private)
jenkins::service (private)
```

### Parameters type

#### `homedir`

Type: String

Directory where Jenkins store its configuration and working

#### `version`

Type: String

The jenkins package version. ( 2.95-1.1.noarch | installed | latest )

#### `user`

Type: String

Unix user account that runs the Jenkins daemon

#### `http_listen_address`

Type: String

IP address Jenkins listens on for HTTPS requests

#### `debug`

Type: Integer

Debug level for logs.

#### `handler_max`

Type: Integer

Maximum number of HTTP worker threads

#### `handler_idle`

Type: Integer

Maximum number of idle HTTP worker threads

#### `java_args`

Type: String

Options to pass to java when running Jenkins

#### `http_port`

Type: Integer

HTTP port Jenkins is listening on

#### `https_port`

Type: Integer

HTTPS port Jenkins is listening on

#### `https_listen_address`

Type: String

IP address Jenkins listens on for HTTPS requests

#### `enable_access_log`

Type: String

Whether to enable access logging or not ( yes | no )

#### `enable_https`

Type: Boolean

Whether to enable access logging or not

#### `https_keystore`

Type: String

Path to the keystore in JKS format (as created by the JDK 'keytool')

#### `https_keystore_password`

Type: String

Password to access the keystore defined in https_keystore

#### `args`

Type: String

Pass arbitrary arguments to Jenkins

#### `java_cmd`

Type: String

Java executable to run Jenkins

### Hiera Keys

```
---
jenkins::homedir: '/var/lib/jenkins'
jenkins::java_args: '-Xms1g -Xmx1g -XX:MaxPermSize=256m'
jenkins::version: 'installed'
jenkins::user: 'jenkins'
jenkins::http_listen_address: '0.0.0.0'
jenkins::http_port: 8080
jenkins::enable_access_log: 'no'

jenkins::debug: 5
jenkins::handler_max: 100
jenkins::handler_idle: 20

jenkins::enable_https: true
jenkins::https_port: 8081
jenkins::https_listen_address: '0.0.0.0'
jenkins::https_keystore: '/opt/jenkins.ks'
jenkins::https_keystore_password: 'puppet'
```

### Hiera module config

This is the Hiera v5 configuration inside the module.

This module does not have params class, everything is under hiera v5.

```
---
version: 5
defaults:
  datadir: data
  data_hash: yaml_data
hierarchy:
  - name: "OSes"
    paths:
     - "oses/distro/%{facts.os.name}/%{facts.os.release.major}.yaml"
     - "oses/family/%{facts.os.family}.yaml"

  - name: "common"
    path: "common.yaml"

```

This is an example of files under modules/jenkins/data

```
oses/family/RedHat.yaml
oses/family/Debian.yaml
oses/distro/CentOS/7.yaml
oses/distro/CentOS/6.yaml
oses/distro/Ubuntu/16.04.yaml
oses/distro/Debian/8.yaml
```

## Development

### My dev environment

This module was developed using

- Puppet 5.3
  - Hiera 3.4 (v5 format)
  - Facter 3.9
- CentOS 7
- Vagrant 2.0
  - box: gutocarvalho/centos7x64puppet5

### Testing

This module uses puppet-lint, puppet-syntax, metadata-json-lint, rspec-puppet, beaker and travis-ci. We hope you use them before submitting your PR.

#### Installing gems

    gem install bundler --no-rdoc --no-ri
    bundle install --without development

#### Running syntax tests

    bundle exec rake syntax
    bundle exec rake lint
    bundle exec rake metadata_lint

#### Running unit tests

    bundle exec rake spec

#### Running acceptance tests

Acceptance tests (Beaker) can be executed using ./acceptance.sh. There is a matrix 1/5 to test this class under Centos 6/7, Debian 8 and Ubuntu 14.04/16.04.

    bash ./acceptance.sh

If you want a detailed output, set this before run acceptance.sh

    export BEAKER_debug=true

If you want to test a specific OS from our matrix

    BEAKER_set=centos-6-x64 bundle exec rake beaker

Our matrix values

    centos-6-x64
    centos-7-x64
    debian-8-x64
    ubuntu-1604-x64

This matrix needs vagrant (>=1.9) and virtualbox (>=5.1) to work properly, make sure that you have both of them installed.

### Author/Contributors

Guto Carvalho (gutocarvalho at gmail dot com)
