#!/bin/bash

BUCKET=cto-baseline-rhel5

# Must be run as root
if [ `whoami` != "root" ]; then
  echo -e "\n$0 must be run as root."
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

# Fucking umask!!!!
umask 022
umask 022 ; for x in /root/.bashrc /root/.bash_profile /etc/bashrc /etc/profile; do 
  chmod 664 $x; sed -i '/umask 077/d' $x
done

if [ -z $AWS_ACCESS_KEY_ID ]; then
  read -p "LC Infrastructure Account Access Key? : " AWS_ACCESS_KEY_ID
fi

if [ -z $AWS_SECRET_ACCESS_KEY ]; then
  read -p "LC Infrastructure Account Secret Key? : " AWS_SECRET_ACCESS_KEY
fi

# Update the system
status 'Running Yum Update'
yum -q -y update

# Install S3 cmd
status 'Installing s3cmd'
curl -s https://s3.amazonaws.com/$BUCKET/s3cmd-1.0.0-4.1.x86_64.rpm > /tmp/s3cmd-1.0.0-4.1.x86_64.rpm
rpm -i /tmp/s3cmd-1.0.0-4.1.x86_64.rpm
if [ $? -ne 0 ]; then
  echo "Error Installing S3cmd"
  exit 1
fi

# Configure s3cmd to access our acct
echo "access_key = $AWS_ACCESS_KEY_ID" >> /root/.s3cfg
echo "secret_key = $AWS_SECRET_ACCESS_KEY" >> /root/.s3cfg
chmod 700 /root/.s3cfg

# Download rpms from S3
status 'Downloading RPMs'
s3cmd --no-progress get s3://$BUCKET/libyaml-0.1.2-3.el5.x86_64.rpm
s3cmd --no-progress get s3://$BUCKET/libffi-3.0.5-1.el5.x86_64.rpm
s3cmd --no-progress get s3://$BUCKET/intu-rhel5-ruby-1.9.3-p125.x86_64.rpm
s3cmd --no-progress get s3://$BUCKET/perl-Error-0.17010-1.el5.noarch.rpm
s3cmd --no-progress get s3://$BUCKET/perl-Git-1.7.4.1-1.el5.x86_64.rpm
s3cmd --no-progress get s3://$BUCKET/git-1.7.4.1-1.el5.x86_64.rpm

# Download python for cfn-commands
s3cmd --no-progress get s3://$BUCKET/aws-cfn-bootstrap-1.0-6.zip
s3cmd --no-progress get s3://$BUCKET/python25-2.5.1-bashton1.x86_64.rpm
s3cmd --no-progress get s3://$BUCKET/python25-devel-2.5.1-bashton1.x86_64.rpm
s3cmd --no-progress get s3://$BUCKET/python25-libs-2.5.1-bashton1.x86_64.rpm
s3cmd --no-progress get s3://$BUCKET/simplejson-2.3.2.tar.gz

# Install ruby dn ruby gems
status 'Installing Ruby'
rpm -i libyaml-0.1.2-3.el5.x86_64.rpm \
         libffi-3.0.5-1.el5.x86_64.rpm \
         intu-rhel5-ruby-1.9.3-p125.x86_64.rpm
if [ $? -ne 0 ]; then
  echo "Error Installing Ruby"
  exit 1
fi

# Don't prelink ruby
cat > /etc/prelink.conf.d/ruby.conf << EOF
-b /usr/bin/ruby
EOF

# Install git
status 'Installing Git'
rpm -i perl-Error-0.17010-1.el5.noarch.rpm \
         perl-Git-1.7.4.1-1.el5.x86_64.rpm \
         git-1.7.4.1-1.el5.x86_64.rpm
if [ $? -ne 0 ]; then
  echo "Error Installing Git"
  exit 1
fi

# Install pythong version 2.5
status 'Installing Python2.5'
rpm -i python25-2.5.1-bashton1.x86_64.rpm \
         python25-devel-2.5.1-bashton1.x86_64.rpm \
         python25-libs-2.5.1-bashton1.x86_64.rpm
if [ $? -ne 0 ]; then
  echo "Error Installing Python 2.5"
  exit 1
fi

# Install cfn util
status 'Installing CFN Tools'
/usr/bin/unzip aws-cfn-bootstrap-1.0-6.zip
cd aws-cfn-bootstrap-1.0 && /usr/bin/python2.5 setup.py install
if [ $? -ne 0 ]; then
  echo "Error Installing cfn-bootstrap"
  exit 1
fi
cd $OLDPWD

# Install simple JSON for cfn util
status 'Installing Simple JSON'
/bin/tar xvzf simplejson-2.3.2.tar.gz
cd simplejson-2.3.2 && /usr/bin/python2.5 setup.py install
if [ $? -ne 0 ]; then
  echo "Error Installing Simple JSON"
  exit 1
fi
cd $OLDPWD

# Update cfn-get-metadata to use pythong 2.5
sed -i 's/env python$/python2.5/' /usr/bin/cfn-get-metadata
sed -i 's/env python$/python2.5/' /usr/bin/cfn-signal

# Install chef dependencies
status 'Installing Build Essentials'
yum -q -y install gcc cpp libgcc
if [ $? -ne 0 ]; then
  echo "Error Installing Build Essentials"
  exit 1
fi

# Install Chef
gem install chef -v '0.10.8' --no-ri --no-rdoc
if [ $? -ne 0 ]; then
  echo "Error Installing Chef"
  exit 1
fi
mkdir -p -m 700 /var/log/chef /etc/chef

# Remove S3 Config
/bin/rm -f /root/.s3cfg

# Cleanup RPMs
/bin/rm *.rpm
