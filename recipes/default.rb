#
# Cookbook Name:: gerrit
# Recipe:: default
#
# Copyright 2014, MetaCloud, Inc.
#

include_recipe 'java'
include_recipe 'git'

include_recipe 'gerrit::install'
include_recipe 'gerrit::config'

if node['gerrit']['features']['apache'] == true
  include_recipe 'gerrit::apache_proxy'
end

case node['gerrit']['config']['database']['type']
when 'MySQL'
  include_recipe 'gerrit::mysql'
end

include_recipe 'gerrit::service'
