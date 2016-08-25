#!/bin/bash
#
# A simple provisioning script that is run on both the app and lb nodes.

# Piping curl to bash is always an interesting idea.
# We'll, however, trust this now for installing Chef.

curl -L https://www.opscode.com/chef/install.sh | sudo bash
echo 'Downloading template chef'
curl http://github.com/opscode/chef-repo/tarball/master
echo '1'
tar -zxf master
echo '2'
mv chef-chef-repo* chef
rm master
echo '3'
cd chef/
echo '4'
mkdir .chef
echo '5'
echo "cookbook_path [ '/home/centos/chef/cookbooks' ]" > .chef/knife.rb
echo '6'
knife cookbook create tirocinio
echo '7'
cd tirocinio

echo 'Creating Berksfile'
#Creo il Berksfile
echo 'source "https://supermarket.chef.io"

metadata

cookbook "mysql"
cookbook "tomcat"
cookbook "java"' > Berksfile

#Scarico i cookbooks e le relative dipendenze
echo 'Downloading cookbooks'
berks vendor

