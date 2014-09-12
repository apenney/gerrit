require_relative '../spec_helper'

describe 'gerrit::default' do
  subject { ChefSpec::Runner.new.converge(described_recipe) }

  it 'contains various recipes' do
    expect(subject).to include_recipe('gerrit::install')
    expect(subject).to include_recipe('gerrit::config')
    expect(subject).to include_recipe('gerrit::service')
  end
end
