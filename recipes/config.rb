#
# Cookbook Name:: gerrit
# Recipe:: config
#
# Copyright 2014, MetaCloud, Inc.
#

template "#{node['gerrit']['install_dir']}/etc/gerrit.config" do
  source   'config/gerrit.config.erb'
  owner    node['gerrit']['user']
  group    node['gerrit']['group']
  mode     0644
  notifies :restart, 'service[gerrit]'
end

template "#{node['gerrit']['install_dir']}/etc/secure.config" do
  source   'config/secure.config.erb'
  owner    node['gerrit']['user']
  group    node['gerrit']['group']
  mode     0600
  notifies :restart, 'service[gerrit]'
end

template "#{node['gerrit']['install_dir']}/etc/replication.config" do
  source   'config/replication.config.erb'
  owner    node['gerrit']['user']
  group    node['gerrit']['group']
  mode     0600
  notifies :restart, 'service[gerrit]'
  only_if  { node['gerrit']['features']['replication'] }
end
