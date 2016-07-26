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
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "apache2::mod_php5"

apache_site "default" do
	enable true
end

mysql_service 'default' do
  port '3306'
  version '5.5'
  initial_root_password 'change me'
  action [:create, :start]
end

# Configure the MySQL client.
#mysql_client 'default' do
#  action :create
#end

# Configure the MySQL service.
#mysql_service 'default' do
#  initial_root_password node['awesome_customers_rhel']['database']['root_password']
#  action [:create, :start]
#end
