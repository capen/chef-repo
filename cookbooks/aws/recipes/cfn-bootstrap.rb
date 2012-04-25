#
# Cookbook Name:: aws
# Recipe:: cfn-bootstrap
#
# Copyright 2011, Intuit, Inc.
#
# All rights reserved - Do Not Redistribute
#

include_recipe "python::pip"

["python-setuptools.noarch", "python-simplejson.x86_64"].each do |p|
  package p do
    action :install
  end
end

["lockfile", "python-daemon", "aws-cfn-bootstrap"].each do |p|
  python_pip p do
    action :install
  end
end
