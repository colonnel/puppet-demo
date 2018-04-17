require 'spec_helper'
describe 'jenkins', :type => :class do
  on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

    it { is_expected.to compile }
    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_class('jenkins') }
    it { is_expected.to contain_class('jenkins::install').that_comes_before('Class[jenkins::config]') }
    it { is_expected.to contain_class('jenkins::config').that_comes_before('Class[jenkins::service]') }
    it { is_expected.to contain_class('jenkins::service') }

    context 'jenkins::install defaults' do
      it { is_expected.to contain_package('jenkins') }
      it { is_expected.to contain_yumrepo('jenkins') }
    end

    context 'jenkins::config defaults' do
      it { is_expected.to contain_augeas('jenkins_homedir').with({
        'context' => '/files/etc/sysconfig/jenkins',
         })
      }
      it { is_expected.to contain_augeas('jenkins_user').with({
        'context' => '/files/etc/sysconfig/jenkins',
        })
      }
      it { is_expected.to contain_augeas('jenkins_java_args').with({
        'context' => '/files/etc/sysconfig/jenkins',
         })
      }
      it { is_expected.to contain_augeas('jenkins_http_listen_address').with({
        'context' => '/files/etc/sysconfig/jenkins',
         })
      }
      it { is_expected.to contain_augeas('jenkins_http_port').with({
        'context' => '/files/etc/sysconfig/jenkins',
         })
      }
      it { is_expected.to contain_augeas('jenkins_debug_level').with({
        'context' => '/files/etc/sysconfig/jenkins',
         })
      }
      it { is_expected.to contain_augeas('jenkins_enable_access_log').with({
        'context' => '/files/etc/sysconfig/jenkins',
         })
      }
      it { is_expected.to contain_augeas('jenkins_handler_max').with({
        'context' => '/files/etc/sysconfig/jenkins',
         })
      }
      it { is_expected.to contain_augeas('jenkins_handler_idle').with({
        'context' => '/files/etc/sysconfig/jenkins',
         })
      }
    end

    context 'jenkins::service defaults' do
      it { is_expected.to contain_service('jenkins').with({
        'ensure' => 'running',
        'enable' => true,
        })
      }
    end

    context 'jenkins::config when enable_https true' do

      let(:params) { {'enable_https' => true} }

      it { is_expected.to contain_augeas('jenkins_https_port').with({
        'context' => '/files/etc/sysconfig/jenkins',})
      }
      it { is_expected.to contain_augeas('jenkins_https_keystore').with({
        'context' => '/files/etc/sysconfig/jenkins',})
      }
      it { is_expected.to contain_augeas('jenkins_https_keystore_password').with({
        'context' => '/files/etc/sysconfig/jenkins',})
      }
      it { is_expected.to contain_augeas('jenkins_https_listen_address').with({
        'context' => '/files/etc/sysconfig/jenkins',})
      }

    end

    end
  end

end
