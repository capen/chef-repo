#!/bin/bash

chef_version='0.10.8'

# Must be run as root
if [ `whoami` != "root" ]; then
  echo -e "\n$0 must be run as root."
  exit 1
fi

# Must be run on RHEL 6
if [ `cat /etc/redhat-release |awk '{print $7}'|cut -d. -f1` != "6" ]; then
  echo -e "\n $0 must be run on RHEL 6"
  exit 1
fi

# Status function
function status {
  let current_operation=current_operation+1
  echo "`date +'%H:%M:%S'`: $1 ($current_operation of $total_operations)"
}

# Read number of operations
let current_operation=0
let total_operations=`egrep ^status $0 | wc -l`

# Change umask to something sane
status 'Setting umask to something sane'
umask 022
umask 022 ; for x in /root/.bashrc /root/.bash_profile /etc/bashrc /etc/profile; do 
  chmod 664 $x; sed -i '/umask 077/d' $x
done

# Update the system
status 'Running Yum Update'
yum -q -y update

# Install Dependencies
status 'Installing Chef Dependencies'
yum -q -y install gcc cpp libgcc
if [ $? -ne 0 ]; then
  echo "Error Installing Build Essentials"
  exit 1
fi

# Install Ruby
status 'Installing Ruby'
yum -q -y install ruby rubygems ruby-devel
if [ $? -ne 0 ]; then
  echo "Error Installing Chef"
  exit 1
fi

# Install Chef
status 'Installing Chef'
gem install chef -v $chef_version --no-ri --no-rdoc
if [ $? -ne 0 ]; then
  echo "Error Installing Chef"
  exit 1
fi

# Create Chef Log Directory
status 'Creating Chef Log Directory'
mkdir -p -m 700 /var/log/chef
