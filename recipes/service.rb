service 'gerrit' do
  supports status: false, restart: true, reload: true
  action [:enable, :start, :stop]
end
