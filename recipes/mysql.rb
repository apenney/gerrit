#
# Cookbook Name:: gerrit
# Recipe:: mysql
#
# Copyright 2014, MetaCloud, Inc.
#

node['gerrit']['mysql-connector']['packages'].each do |pkg|
  package pkg do
    action :install
  end
end

link "#{node['gerrit']['install_dir']}/lib/mysql-connector-java.jar" do
  to '/usr/share/java/mysql-connector-java.jar'
end
