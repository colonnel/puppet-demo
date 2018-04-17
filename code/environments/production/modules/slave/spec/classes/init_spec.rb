require 'spec_helper'
describe 'slave' do
  context 'with default values for all parameters' do
    it { should contain_class('slave') }
  end
end
