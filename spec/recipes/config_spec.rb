require_relative '../spec_helper'

describe 'gerrit::default' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['gerrit']['config']['gerrit']['basePath'] = 'git'
      node.set['gerrit']['config']['gerrit']['test']     = '# git'
      node.set['gerrit']['config']['gerrit']['hash']     = { key1: 'test', key2: '# test' }
    end.converge(described_recipe)
  end

  describe 'configuration file' do
    it 'creates sections within []' do
      expect(chef_run).to render_file('/var/gerrit/review/etc/gerrit.config').with_content('[gerrit]')
    end
    it 'renders keys without # without wrapper quotes' do
      expect(chef_run).to render_file('/var/gerrit/review/etc/gerrit.config').with_content('basePath = git')
    end
    it 'renders keys containing # with quotes' do
      expect(chef_run).to render_file('/var/gerrit/review/etc/gerrit.config').with_content('test = "# git"')
    end

    describe 'with values of a hash' do
      it 'creates a section with the name of the hash' do
        expect(chef_run).to render_file('/var/gerrit/review/etc/gerrit.config').with_content('[hash]')
      end
      it 'renders keys without # without wrapper quotes' do
        expect(chef_run).to render_file('/var/gerrit/review/etc/gerrit.config').with_content('key1 = test')
      end
      it 'render values containing # with quotes' do
        expect(chef_run).to render_file('/var/gerrit/review/etc/gerrit.config').with_content('key2 = "# test"')
      end
    end
  end
end
