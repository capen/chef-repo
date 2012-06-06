Chef Starter Repo
=================

I am the Intuit Chef repository.  My goal is to provide an easy path for you to boot strap a Intuit Linux instance with Chef and the Intuit cookbooks.

Getting Started
---------------

The easiest way to get started is to launch the single instance baseline template in the Cloud Formation tempaltes repo.

[Cloud Formation Templates](https://github.com/live-community/cloud_formation_templates)

To manually configure an instance.

* Launch one of the supported AMIs.  Currently this is tested on RHEL 6u2.
* Download this repository and copy it to the target instance.  
* SSH to that system and in the downloaded directory, run the following

Once it is on the instance, include the Intuit Public Cookbooks and bootstrap the instance by running the below from within the directory:

```
yum -y install git
git submodule init && git submodule update
./scripts/bootstrap.sh
```

This will boot strap the Instance with Chef.

Apply Chef Roles
----------------

We include a base that configures the Intuit Baseline Tweaks

To apply the baseline role run:

```
chef-solo -c config/solo.rb -j nodes/baseline.json
```

You can specify any recipe in the cookbook repo as follows

```
chef-solo -c config/solo.rb -a 'recipe[jenkins]'
```

Supported AMIs
--------------

The Intuit Chef Starter Repo is tested with RHEL6
