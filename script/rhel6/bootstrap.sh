#!/bin/bash

# This script will bootstrap an instance with everything
# required to run chef-solo

log='/tmp/bootstrap.log'

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

# Getting started
status "Log file located at $log"

# Change umask to something sane
status 'Setting umask to something sane'
umask 022
umask 022 ; for x in /root/.bashrc /root/.bash_profile /etc/bashrc /etc/profile; do 
  chmod 664 $x; sed -i '/umask 077/d' $x
done

# Create chef directories
status 'Creating chef directories'
mkdir -p /var/chef/cache /var/log/chef
if [ $? -ne 0 ]; then
  echo 'Error creating chef directories'
fi

# Downloading Omnibus package
status 'Download Chef Omnibus Package'
wget -O /root/chef-full.rpm -q http://s3-us-west-1.amazonaws.com/intu-artifacts-us-west-1/rhel6/chef-full-0.10.10-1.x86_64.rpm >> $log 2>&1
if [ $? -ne 0 ]; then
  echo 'Error downloading Omnibus'
  exit 1
fi

# Installing Omnibus
status 'Installing Omnibus RPM'
rpm -i /root/chef-full.rpm >> $log 2>&1
if [ $? -ne 0 ]; then
  echo 'Error installing Omnibus'
  exit 1
fi

# Removing chef binary
status 'Remove chef rpm'
/bin/rm /root/chef-full.rpm
if [ $? -ne 0 ]; then
  echo 'Error removing rpm'
  exit 1
fi

# Done
status 'Completed succesfully, exiting with 0'
exit 0
