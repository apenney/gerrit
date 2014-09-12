require_relative '../spec_helper'

describe 'gerrit::default' do
  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end

  describe 'features' do
    describe 'user_management' do
      describe 'disabled' do
        let(:chef_run) do
          ChefSpec::Runner.new do |node|
            node.set['gerrit']['features']['user_management'] = false
            node.set['gerrit']['group'] = 'gerrit'
            node.set['gerrit']['user'] = 'gerrit'
          end.converge(described_recipe)
        end

        it 'doesnt create the group' do
          expect(chef_run).not_to create_group('gerrit')
        end
        it 'doesnt create the user' do
          expect(chef_run).not_to create_user('gerrit')
        end
      end

      describe 'enabled' do
        let(:chef_run) do
          ChefSpec::Runner.new do |node|
            node.set['gerrit']['features']['user_management'] = true
            node.set['gerrit']['group'] = 'gerrit'
            node.set['gerrit']['user'] = 'gerrit'
          end.converge(described_recipe)
        end

        it 'creates the group' do
          expect(chef_run).to create_group('gerrit')
        end
        it 'creates the user' do
          expect(chef_run).to create_user('gerrit')
        end
      end
    end
  end

  describe 'ssh feature' do
    describe 'disabled' do
      let(:chef_run) do
        ChefSpec::Runner.new do |node|
          node.set['gerrit']['features']['ssh'] = false
          node.set['gerrit']['home'] = '/var/gerrit'
          node.set['gerrit']['group'] = 'gerrit'
          node.set['gerrit']['user'] = 'gerrit'
        end.converge(described_recipe)
      end

      it 'doesnt create the .ssh directory' do
        expect(chef_run).not_to create_directory('/var/gerrit/.ssh')
      end
    end
    describe 'enabled' do
      let(:chef_run) do
        ChefSpec::Runner.new do |node|
          node.set['gerrit']['features']['ssh'] = true
          node.set['gerrit']['home'] = '/var/gerrit'
          node.set['gerrit']['group'] = 'gerrit'
          node.set['gerrit']['user'] = 'gerrit'
        end.converge(described_recipe)
      end

      it 'creates the .ssh directory' do
        expect(chef_run).to create_directory('/var/gerrit/.ssh')
      end
    end
  end

  describe 'ssl feature' do
    describe 'disabled' do
      let(:chef_run) do
        ChefSpec::Runner.new do |node|
          node.set['gerrit']['features']['ssl'] = false
          node.set['gerrit']['home'] = '/var/gerrit'
          node.set['gerrit']['group'] = 'gerrit'
          node.set['gerrit']['user'] = 'gerrit'
        end.converge(described_recipe)
      end

      it 'doesnt create the ssl directory' do
        expect(chef_run).not_to create_directory('/var/gerrit/ssl')
      end
      it 'doesnt create the ssl files' do
        %w(cert key).each do |file|
          expect(chef_run).not_to create_cookbook_file(file)
        end
      end
    end
    describe 'enabled' do
      let(:chef_run) do
        ChefSpec::Runner.new do |node|
          node.set['gerrit']['features']['ssl'] = true
          node.set['gerrit']['home'] = '/var/gerrit'
          node.set['gerrit']['group'] = 'gerrit'
          node.set['gerrit']['user'] = 'gerrit'
        end.converge(described_recipe)
      end

      it 'creates the ssl directory' do
        expect(chef_run).to create_directory('/var/gerrit/ssl')
      end
      it 'creates the ssl files' do
        %w(cert key).each do |file|
          expect(chef_run).to create_cookbook_file("/var/gerrit/ssl/#{file}")
        end
      end
    end
  end

  describe 'symlink' do
    it 'is created' do
      expect(chef_run).to create_link('/etc/init.d/gerrit')
    end
  end

  describe 'war installation' do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['gerrit']['home']    = '/var/gerrit'
        node.set['gerrit']['version'] = '2.9'
      end.converge(described_recipe)
    end

    it 'downloads a remote file' do
      expect(chef_run).to create_remote_file_if_missing('/var/gerrit/downloads/2.9.war')
    end

    it 'notifies appropriate resources' do
      resource = chef_run.remote_file('/var/gerrit/downloads/2.9.war')
      expect(resource).to notify('service[gerrit]').to(:stop).immediately
      expect(resource).to notify('execute[gerrit-init]').to(:run).immediately
      expect(resource).to notify('execute[gerrit-reindex]').to(:run).immediately
    end
  end

  # TODO: Add a test for static_files and compile_files with a different
  # cookbook.
  # TODO: Test the executes.
end
