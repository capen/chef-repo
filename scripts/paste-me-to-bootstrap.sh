# On an Intuit instance
# Paste the below commands to install chef
# And download the starter cookbooks repo

chef_repo=git://github.com/live-community/chef-repo.git
chef_dir=/var/chef
chef_log_dir=/var/log/chef
chef_cache_dir=/var/chef/cache

# Un-hork the umask
umask 022

# Install git and clone the chef repo
yum -y -q install git
git clone $chef_repo $chef_dir

# Make addition chef dirs, must be done after clone
mkdir -p $chef_dir $chef_log_dir $chef_cache_dir

# Bootstrap the instance
/var/chef/scripts/bootstrap.sh

# Download the cookbooks submodule
cd /var/chef ; git submodule init && git submodule update ; cd -
