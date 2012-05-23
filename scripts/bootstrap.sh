#!/bin/bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -f /etc/redhat-release ]; then
  echo 'Must be run on RHEL.'
  exit 1
fi

version=`cat /etc/redhat-release | awk '{print $7}' | cut -d. -f1`

case $version in
  6)
    echo "Bootstraping for RHEL 6 $dir/rhel6/bootstrap.sh"
    $dir/rhel6/bootstrap.sh
    ;;
  *)
    echo "Unsupported RHEL version: $version"
    ;;
esac
