require_relative '../spec_helper'

describe 'gerrit::default' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['gerrit']['config']['gerrit']['basePath']  = 'git'
      node.set['gerrit']['config']['gerrit']['test']      = '# git'
      node.set['gerrit']['config']['gerrit']['hash']      = { key1: 'test', key2: '"# test"' }
      node.set['gerrit']['config']['commentlink']['hash'] = { key3: 'test', key4: '"# test"' }
    end.converge(described_recipe)
  end

  describe 'configuration file' do
    it 'creates sections within []' do
      expect(chef_run).to render_file('/var/gerrit/review/etc/gerrit.config').with_content('[gerrit]')
    end
    it 'renders keys correctly' do
      expect(chef_run).to render_file('/var/gerrit/review/etc/gerrit.config').with_content('basePath = git')
    end

    describe 'with values of a hash' do
      it 'creates a section with the name of the hash' do
        expect(chef_run).to render_file('/var/gerrit/review/etc/gerrit.config').with_content('[hash]')
      end
      it 'renders keys correctly' do
        expect(chef_run).to render_file('/var/gerrit/review/etc/gerrit.config').with_content('key2 = "# test"')
      end
    end

    describe 'with commentlink sections' do
      it 'creates a section with the name of the hash as an element of commentlink' do
        expect(chef_run).to render_file('/var/gerrit/review/etc/gerrit.config').with_content('[commentlink "hash"]')
      end
      it 'renders keys correctly' do
        expect(chef_run).to render_file('/var/gerrit/review/etc/gerrit.config').with_content('key4 = "# test"')
      end
    end
  end
end
