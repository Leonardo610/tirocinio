#!/bin/bash
#
# A simple provisioning script that is run on both the app and lb nodes.

# Piping curl to bash is always an interesting idea.
# We'll, however, trust this now for installing Chef.


echo 'Downloading template chef'
sudo yum -y install wget && sudo yum -y install nano
wget https://packages.chef.io/stable/el/7/chefdk-0.11.2-1.el7.x86_64.rpm
sudo rpm -ivh chefdk-0.11.2-1.el7.x86_64.rpm
rm chefdk-0.11.2-1.el7.x86_64.rpm
wget http://github.com/opscode/chef-repo/tarball/master
# echo '1'
tar -zxf master
# echo '2'
mv chef-* chef
rm master
# echo '3'
cd chef/
# echo '4'
mkdir .chef
echo "cookbook_path [ '/home/centos/chef/cookbooks' ]" > .chef/knife.rb
# echo '6'
knife cookbook create tirocinio
cd cookbooks/tirocinio


echo 'Creating Berksfile'
# #Creo il Berksfile
echo 'source "https://supermarket.chef.io"

metadata' > Berksfile

echo 'depends "tomcat"
depends "java"
depends "google-chrome"' >> metadata.rb

echo 'Modifico recipes/default.rb'

echo "include_recipe \"tomcat\"
include_recipe \"java\"

package 'tomcat' do
  action :install
#  install_path '/opt/tomcat'
end

service 'tomcat' do
  action [:start, :enable]
end" >> recipes/default.rb

# #Scarico i cookbooks e le relative dipendenze
echo 'Downloading cookbooks'
berks vendor

cd ../..
echo 'file_cache_path "home/centos/chef-solo"
cookbook_path "/home/centos/chef/cookbooks/tirocinio/berks-cookbooks"' > solo.rb
echo '{  "run_list": [ "recipe[tirocinio]" ] }' > web.json
cd ..
rm provision.sh
cd chef
sudo chef-solo -c solo.rb -j web.json
cd /home/centos
wget http://yourserver:port/jnlpJars/slave.jar
java -jar slave.jar -jnlpUrl http://52.19.16.51:8080//computer/terraform/slave-agent.jnlp 
