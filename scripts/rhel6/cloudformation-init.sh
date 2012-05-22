#!/bin/bash

# If entered into user-data on an Intuit baseline
# This will boostrap an instance to the given role

chef_repo=git://github.com/live-community/chef-repo.git
chef_dir=/var/chef
role=image

mkdir -p $chef_dir

yum -y -q install git

git clone $chef_repo $chef_dir

/var/chef/scripts/rhel6/bootstrap.sh

cd /var/chef

git submodule init && git submodule update

umask 022 && chef-solo -c config/solo.rb -j nodes/$role.json

cd $OLDPWD
