#
# Cookbook Name:: gerrit
# Recipe:: install
#
# Copyright 2014, MetaCloud, Inc.
#

if node['gerrit']['features']['user_management']
  group node['gerrit']['group'] do
    action :create
  end

  user node['gerrit']['user'] do
    gid     node['gerrit']['group']
    home    node['gerrit']['home']
    comment 'Gerrit'
    shell   '/bin/false'
    system  true
    action  :create
  end
end

# We need to prepare the ground for both the gerrit home as well as the
# place we install the exploded contents of the war file.

[
  node['gerrit']['home'],
  node['gerrit']['home'] + '/downloads',
  node['gerrit']['install_dir'],
  node['gerrit']['install_dir'] + '/etc',
  node['gerrit']['install_dir'] + '/lib',
  node['gerrit']['install_dir'] + '/static',
  node['gerrit']['install_dir'] + '/plugins'
].each do |dir|
  directory dir do
    owner node['gerrit']['user']
    group node['gerrit']['group']
    recursive true
  end
end

# Set up a couple of bits related to managing the service.
link '/etc/init.d/gerrit' do
  to "#{node['gerrit']['install_dir']}/bin/gerrit.sh"
end

template '/etc/default/gerritcodereview' do
  source   'system/gerritcodereview.erb'
  mode     '0644'
  notifies :restart, 'service[gerrit]'
end

# Make sure we prepare a place for ssh keys if required.
if node['gerrit']['features']['ssh']
  directory node['gerrit']['home'] + '/.ssh' do
    owner node['gerrit']['user']
    group node['gerrit']['group']
    mode  '0700'
  end
end

# Likewise, make sure we're ready for SSL certs.
if node['gerrit']['features']['ssl']
  directory node['gerrit']['home'] + '/ssl' do
    owner node['gerrit']['user']
    group node['gerrit']['group']
    mode  '0700'
  end

  %w(cert key).each do |file|
    cookbook_file "#{node['gerrit']['home']}/ssl/#{file}" do
      source file
      owner  'root'
      group  'root'
      mode   '0755'
      action :create
    end
  end
end

##
## War installation.
##

remote_war = "#{node['gerrit']['download_location']}-#{node['gerrit']['version']}.war"
local_war  = "#{node['gerrit']['home']}/downloads/#{node['gerrit']['version']}.war"

# we have to explicitly list the core plugins that should be installed
plugin_command = ''
node['gerrit']['core_plugins'].each do |plugin|
  plugin_command << " --install-plugin #{plugin}"
end

remote_file local_war do
  owner    node['gerrit']['user']
  source   remote_war
  notifies :stop, 'service[gerrit]', :immediately
  notifies :run, 'execute[gerrit-init]', :immediately
  notifies :run, 'execute[gerrit-reindex]', :immediately
  action   :create_if_missing
end

# Once the war is local, actually install it.
execute 'gerrit-init' do
  user     node['gerrit']['user']
  group    node['gerrit']['group']
  cwd      "#{node['gerrit']['home']}/downloads"
  command  "java -jar #{local_war} init --batch --no-auto-start \
           -d #{node['gerrit']['install_dir']} #{plugin_command}"
  action   :nothing
  notifies :restart, 'service[gerrit]'
end

execute 'gerrit-reindex' do
  user    node['gerrit']['user']
  group   node['gerrit']['group']
  cwd     "#{node['gerrit']['home']}/downloads"
  command "java -jar #{local_war} reindex -d #{node['gerrit']['install_dir']}"
  action  :nothing
end

# Once everything is up and running, drop the compile and static files on top.
node['gerrit']['theme']['compile_files'].each do |file|
  cookbook_file "#{node['gerrit']['install_dir']}/etc/#{file}" do
    source "gerrit/compile/#{file}"
    owner node['gerrit']['user']
    group node['gerrit']['group']
    mode 0644
    cookbook node['gerrit']['theme']['source_cookbook']
  end
end

node['gerrit']['theme']['static_files'].each do |file|
  cookbook_file "#{node['gerrit']['install_dir']}/static/#{file}" do
    source "gerrit/static/#{file}"
    owner node['gerrit']['user']
    group node['gerrit']['group']
    cookbook node['gerrit']['theme']['source_cookbook']
  end
end

