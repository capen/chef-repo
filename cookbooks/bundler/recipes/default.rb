#
# Cookbook Name:: bundler
# Recipe:: default
#
# Copyright 2012, Intuit, Inc.
#
#
gem_package 'bundler' do
  action :install
  version node[:bundler][:version]
end
