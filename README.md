This is the Intuit start Chef repository.  My goal is to provide an easy path for you to boot strap a Intuit Linux instance with Chef.

To get started, download this repository and copy it to the target system.

in the downloaded directory, run the following

```
umask 022 ; export HISTSIZE=0 ; ./scripts/rhel6/bootstrap-rhel6.sh
```

This will boot strap the instance with chef.

If you'd like to install the base configuration that includes the following

* Build Essentials
* Git
* Cloud Formation Bootstrap Utilities

run:

```
chef-solo -c config/solo.r -j nodes/base.rb
```

This currently supports the RedHat 6 AMI. It has been tested with the following AMIs:
