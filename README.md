Chef Starter Repo
=================

I am the Intuit Chef repository.  My goal is to provide an easy path for you to boot strap a Intuit Linux instance with Chef and the Intuit cookbooks.

Getting Started
---------------

The easiest way to get started is to launch the single instance baseline template in the Cloud Formation tempaltes repo.

[Cloud Formation Templates](https://github.com/live-community/cloud_formation_templates)

To manually configure an instance.

* Launch one of the supported AMIs.  Currently this is tested on RHEL 6u2.
* SSH to that system and in the downloaded directory, and download this repository.

```
yum -y install git
git clone git://github.com/live-community/chef-repo.git /var/chef
```

Once it is on the instance, include the Intuit Public Cookbooks and bootstrap the instance by running the below from within the directory:

```
cd /var/chef
git submodule init && git submodule update
./script/bootstrap.sh
```

This will bootstrap the Instance with Chef.  See below for more information on configuring the instance from the Intuit cookbooks.

Apply Chef Roles
----------------

We include a base that configures the Intuit Baseline Tweaks

To apply the baseline role run:

```
chef-solo -c config/solo.rb -j nodes/baseline.json
```

You can specify any recipe in the cookbook repo as follows:

```
chef-solo -c config/solo.rb -o 'recipe[jenkins]'
```

Supported AMIs
--------------

The Intuit Chef Starter Repo is tested with RHEL6
