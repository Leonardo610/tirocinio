#!/bin/bash
#
# A simple provisioning script that is run on both the app and lb nodes.


echo 'Downloading and installing chef'
sudo yum -y install wget && sudo yum -y install nano
wget https://packages.chef.io/stable/el/7/chefdk-0.11.2-1.el7.x86_64.rpm
sudo rpm -ivh chefdk-0.11.2-1.el7.x86_64.rpm
rm chefdk-0.11.2-1.el7.x86_64.rpm
wget http://github.com/opscode/chef-repo/tarball/master
tar -zxf master
mv chef-* chef
rm master
cd chef/
mkdir .chef
echo "cookbook_path [ '/home/centos/chef/cookbooks' ]" > .chef/knife.rb
knife cookbook create tirocinio
cd cookbooks/tirocinio


echo 'Creating Berksfile'
echo 'source "https://supermarket.chef.io"

metadata' > Berksfile

echo 'depends "tomcat"
depends "java", "~>1.7.0"
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

#Scarico i cookbooks e le relative dipendenze
echo 'Downloading cookbooks'
berks vendor

cd ../..
echo 'file_cache_path "home/centos/chef-solo"
cookbook_path "/home/centos/chef/cookbooks/tirocinio/berks-cookbooks"' > solo.rb
echo '{ "java": {
    "install_flavor": "oracle_rpm",
    "jdk_version": "7",
    "oracle": {
      "accept_oracle_download_terms": true
    }
  }, "run_list": [ "recipe[tirocinio]", "recipe[java]" ] }' > web.json
cd ..
rm provision.sh
cd chef
sudo chef-solo -c solo.rb -j web.json
cd /home/centos
wget http://52.50.139.190:8080/jnlpJars/slave.jar
git clone https://github.com/Signorgionzs/inspec.git
java -jar slave.jar -jnlpUrl http://52.50.139.190:8080/computer/terraform/slave-agent.jnlp 