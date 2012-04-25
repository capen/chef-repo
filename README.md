I am the Intuit Chef repository.  My goal is to provide an easy path for you to boot strap a Intuit Linux instance with Chef.

Getting Started
---------------

* Launch one of the supported AMIs, I'm using **ami-db0b509e** (see below for full list).
* Download this repository and copy it to the target system.
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
chef-solo -c config/solo.r -j nodes/base.rb
```

Supported AMIs
--------------

This currently supports the Intuit RedHat 6 AMI. It has been tested with the following version:

bl-rhel6u2-1.0.x86_64.ami1 

US-East-1 (Virginia):     ami-7fba6216  
US-West-2 (Oregon):       ami-12fe7222  
US-West-1 (N.California): ami-db0b509e  
