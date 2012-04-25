#
# Cookbook Name:: base
# Recipe:: umask
#
# Copyright 2011, Intuit, Inc.
#
# All rights reserved - Do Not Redistribute
#

execute "umask" do
  command "umask 022 ; for x in /root/.bashrc /root/.bash_profile /etc/bashrc /etc/profile; do chmod 664 $x; sed -i '/umask 077/d' $x; done"
  action :run
end
