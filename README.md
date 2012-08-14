Chef Starter Repo
=================

I am the Intuit Chef repository.  My goal is to provide an easy path for you to boot strap an Linux instance in the AWS EC2 Cloud with Chef and the Intuit cookbooks.

How To Use This Repository
--------------------------

This repo is meant as a starting point to bootstrap an Instance with Chef and give you a foundation to apply Cookbooks from the Intuit open source library within in a couple minutes.

Getting Started
---------------

The easiest way to get started is to launch the [Single Instance Chef Template](https://raw.github.com/live-community/cloud_formation_templates/master/classic/single_instances/base_instance_with_chef.json) in the [Cloud Formation Templates Repo](https://github.com/live-community/cloud_formation_templates).

To manually configure an instance:

* Launch one of the supported AMIs.  Currently this is tested on RHEL 6u2.
* SSH to that system and in the downloaded directory, and download this repository.
* Download the Chef start repo.

```
yum -y install git
git clone git://github.com/live-community/chef-repo.git /var/chef
```

* Once the repo is downloaded, include the Intuit Public Cookbooks submodule and bootstrap the instance by running the below from within the directory:
* Download the cookbooks submodule.

```
cd /var/chef
git submodule init && git submodule update
```

* Bootstrap the system to install Chef.

```
./script/bootstrap.sh
```

* This will bootstrap the Instance with Chef.  See below for more information on configuring the instance from the Intuit cookbooks.

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

Checkout the [Intuit Cookbooks Repo](https://github.com/live-community/cookbooks) for a full list of available cookbooks.

Supported AMIs
--------------

The Intuit Chef Starter Repo is tested with RHEL6.
