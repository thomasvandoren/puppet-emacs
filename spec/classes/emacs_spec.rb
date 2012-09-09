require 'spec_helper'

describe 'emacs', :type => 'class' do

  context "On non Debian systems" do
    let :facts do
      {
        :osfamily => 'RedHat'
      }
    end

    it do
      expect { should raise_error(Puppet::Error) }
    end
  end

  context "On a Debian OS" do
    let :facts do
      {
        :osfamily => 'Debian'
      }
    end

    it do
      should contain_package('build-essential').with_ensure('present')
      should contain_package('make').with_ensure('present')
      should contain_group('local-build').with_ensure('present')
      should contain_user('local-build').with('ensure' => 'present',
                                              'gid'    => 'local-build')
      should contain_file('emacs.tar.gz').with('ensure' => 'present',
                                               'path'   => '/opt/emacs-src/emacs.tar.gz')
      should contain_exec('build-dep-emacs').with('user'  => 'root',
                                                  'group' => 'root')
      should contain_exec('configure-emacs').with('user'  => 'local-build',
                                                  'group' => 'local-build')
    end
  end

end
