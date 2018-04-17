require 'spec_helper'
describe 'core' do
  context 'with default values for all parameters' do
    it { should contain_class('core') }
  end
end
