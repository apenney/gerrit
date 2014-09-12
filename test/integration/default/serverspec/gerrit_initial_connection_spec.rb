require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe 'Gerrit' do
  it "is listening on port 8080" do
    expect(port(8080)).to be_listening
  end

  describe command(' wget --no-check-certificate -O - localhost:8080') do
    it { should return_stdout /Gerrit Code Review/ }
  end
end

