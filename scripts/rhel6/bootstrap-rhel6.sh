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
status 'Installing Chef and Cloud Formation Dependencies'
yum -q -y install gcc g++ cpp libgcc make python-setuptools.noarch python-simplejson.x86_64 git libffi libyaml
if [ $? -ne 0 ]; then
  echo "Error Installing Build Essentials"
  exit 1
fi

# Install Python Daemon
status 'Installing Python Daemon'
wget http://pypi.python.org/packages/source/p/python-daemon/python-daemon-1.5.5.tar.gz
tar xvzf python-daemon-1.5.5.tar.gz
cd python-daemon-* && python setup.py install
if [ $? -ne 0 ]; then
  echo "Error Installing Python Daemon"
  exit 1
fi
cd $OLDPWD

# Install Python Lock File
status 'Installing Python Lock File'
wget http://pylockfile.googlecode.com/files/lockfile-0.8.tar.gz
tar xvzf lockfile-0.8.tar.gz
cd lockfile-* && python setup.py install
if [ $? -ne 0 ]; then
  echo "Error Installing Python Daemon"
  exit 1
fi
cd $OLDPWD

# Install CFN Boostrap Tools
status 'Installing CFN Bootstap Tools'
wget https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz
tar xvzf aws-cfn-bootstrap-latest.tar.gz
cd aws-cfn-bootstrap-* && python setup.py install
if [ $? -ne 0 ]; then
  echo "Error Installing CFN Bootstrap Tools"
  exit 1
fi
cd $OLDPWD

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

# Cleanup RPMs
/bin/rm *.rpm
