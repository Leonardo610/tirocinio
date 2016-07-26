#
# Cookbook Name:: phpapp
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apache2"
#include_recipe "mysql"

apache_site "default" do
	enable true
end

mysql_service 'default' do
  port '3306'
 # version '5.5'
  initial_root_password 'password'
  action [:create, :start]
end
