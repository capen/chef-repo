#
# Cookbook Name:: aws
# Recipe:: cfn-bootstrap
#
# Copyright 2011, Intuit, Inc.
#
# All rights reserved - Do Not Redistribute
#

include_recipe "python::pip"

["python-setuptools", "python-simplejson"].each do |p|
  package p do
    action :install
  end
end

["lockfile", "python-daemon"].each do |p|
  python_pip p do
    action :install
  end
end

remote_file "/tmp/aws-cfn-bootstrap-latest.tar.gz" do
  source "https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz"
  mode "600"
  not_if "pip freeze |grep aws-cfn-bootstrap"
end

execute "yaws-bootstrap-cfn" do
  command "easy_install /tmp/aws-cfn-bootstrap-latest.tar.gz"
  not_if "pip freeze |grep aws-cfn-bootstrap"
end
