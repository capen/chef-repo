#
# Cookbook Name:: git
# Recipe:: default
#
# Copyright 2011, Intuit, Inc.
#
# All rights reserved - Do Not Redistribute
#
case node[:platform]
when "redhat"
  package "git"
end
