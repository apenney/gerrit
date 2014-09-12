require_relative '../spec_helper'

describe 'gerrit::default' do
  describe 'with mysql configured in gerrit.config' do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['gerrit']['config']['database']['type'] = 'MySQL'
        node.set['gerrit']['mysql-connector']['packages'] = %w(libmysql-java test)
      end.converge(described_recipe)
    end

    describe 'should setup the MySQL connector' do
      it 'installs packages' do
        expect(chef_run).to install_package('libmysql-java')
        expect(chef_run).to install_package('test')
      end
      it 'creates a link' do
        expect(chef_run).to create_link('/home/gerrit2/review_site/lib/mysql-connector-java.jar')
      end
    end
  end

  describe 'with mysql not in gerrit.config' do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['gerrit']['config']['database']['type'] = 'H2'
        node.set['gerrit']['mysql-connector']['packages'] = %w(libmysql-java test)
      end.converge(described_recipe)
    end

    describe 'should not setup the MySQL connector' do
      it 'installs packages' do
        expect(chef_run).to_not install_package('libmysql-java')
        expect(chef_run).to_not install_package('test')
      end
      it 'shouldnt create a link' do
        expect(chef_run).to_not create_link('/home/gerrit2/review_site/lib/mysql-connector-java.jar')
      end
    end
  end
end
