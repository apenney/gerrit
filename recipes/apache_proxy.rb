include_recipe 'apache2'
include_recipe 'apache2::mod_proxy'
include_recipe 'apache2::mod_proxy_http'

apache_site 'default' do
  enable false
end

if node['gerrit']['features']['ssl']
  include_recipe 'apache2::mod_ssl'
  ssl_certfile_path = node['gerrit']['apache']['ssl_certfile']
  ssl_keyfile_path  = node['gerrit']['apache']['ssl_keyfile']
  ssl_cabundle_path = node['gerrit']['apache']['ssl_cabundle'] || nil
end

web_app node['gerrit']['hostname'] do
  server_name    node['gerrit']['hostname']
  server_aliases []
  docroot        '/var/www'
  template       'apache/web_app.conf.erb'
  if node['gerrit']['features']['ssl']
    ssl_certfile ssl_certfile_path
    ssl_keyfile  ssl_keyfile_path
    ssl_cabundle ssl_cabundle_path
  end
end
