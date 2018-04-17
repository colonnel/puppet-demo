require 'spec_helper'

describe 'tomcat', type: :class do
  context 'not installing from source' do
    let :facts do
      {
        osfamily: 'Debian',
      }
    end
    let :params do
      {
        install_from_source: false,
      }
    end

    it { is_expected.not_to contain_file('/opt/apache-tomcat') }
  end

  context 'not managing user/group' do
    let :facts do
      {
        osfamily: 'Debian',
      }
    end
    let :params do
      {
        manage_user: false,
        manage_group: false,
      }
    end

    it { is_expected.not_to contain_user('tomcat') }
    it { is_expected.not_to contain_group('tomcat') }
  end

  context 'with invalid $manage_user' do
    let :facts do
      {
        osfamily: 'Debian',
      }
    end
    let :params do
      {
        manage_user: 'foo',
      }
    end

    it do
      expect {
        catalogue
      }.to raise_error(Puppet::Error, %r{Boolean})
    end
  end

  context 'on windows' do
    let :facts do
      {
        osfamily: 'windows',
      }
    end

    it do
      expect {
        catalogue
      }.to raise_error(Puppet::Error, %r{Unsupported osfamily})
    end
  end
  context 'on Solaris' do
    let :facts do
      {
        osfamily: 'Solaris',
      }
    end

    it do
      expect {
        catalogue
      }.to raise_error(Puppet::Error, %r{Unsupported osfamily})
    end
  end
  context 'on OSX' do
    let :facts do
      {
        osfamily: 'Darwin',
      }
    end

    it do
      expect {
        catalogue
      }.to raise_error(Puppet::Error, %r{Unsupported osfamily})
    end
  end
end
