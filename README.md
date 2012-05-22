I am the Intuit Chef repository.  My goal is to provide an easy path for you to boot strap a Intuit Linux instance with Chef.  We are based on the RHEL 6 baseline.

Getting Started
---------------

* Launch one of the supported AMIs.  Currently this is tested on RHEL 6u2.
* Download this repository and copy it to the target system.  (I include the Intuit Cookbooks Git Submodule, so if you clone me, make sure to do a **git submodule init && git submodule update**)
* SSH to that system and in the downloaded directory, run the following

```
umask 022 ; ./scripts/rhel6/bootstrap-rhel6.sh
```

This will boot strap the instance with chef.

Apply Chef Roles
----------------

We include a base that installs a few common packages

* Build Essentials
* Git
* Cloud Formation Bootstrap Utilities

To apply the base role run:

```
chef-solo -c config/solo.rb -j nodes/base.json
```

Supported AMIs
--------------

This currently supports the Intuit RedHat 6 AMI. It has been tested with the following version:
