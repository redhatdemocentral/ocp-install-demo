OpenShift Container Platform Install Demo
=========================================
If you are looking to develop containerized applications, the OpenShift Container Plaform (OCP) can help you by providing 
private PaaS (Cloud) environment you can install locally. It includes the same container development and run-time 
tools used to create and deploy containers for large data centers. 

This project requires a docker engine, OpenShift command line tools and VirtualBox, but these checks happen when you run the
installation and point you to what is missing. It also checks that you have the right versions running too.


Install on your machine
-----------------------
1. [Download and unzip.](https://github.com/redhatdemocentral/ocp-install-demo/archive/master.zip)

2. Run 'init.sh', then sit back.

3. Follow displayed instructions to log in to your brand new OpenShift Container Platform!


Notes
-----
Log in to the OCP console with:
```
   Developer user:  openshift-dev
   Developer pass:  devel

   Admin user: admin
   Admin pass: admin
```

This project has an install script that is setup to allow you to re-run it without worrying about previous
installations. If you re-run it, it removes old 'openshift' machines and reinstalls for you. If you want
to save your installation of OCP, then use the following to stop and start instead of re-running the install
script provided:
```
   $ docker-machine stop openshift
  
   $ docker-machine start openshift
```


Supporting Articles
-------------------
- [Holiday Homework - Red Hat Cloud demo updates](http://www.schabell.org/2016/12/holiday-homework-redhat-cloud-demo-updates.html)

- [3 Steps to Cloud Happiness with OpenShift Container Platform](http://www.schabell.org/2016/11/3-steps-to-cloud-happiness-with-ocp.html)


Released versions
-----------------
See the tagged releases for the following versions of the product:

- v1.0 - OpenShift Container Platform based on OpenShift command line tools v3.3.1.3.

![OCP Login](https://github.com/redhatdemocentral/ocp-install-demo/blob/master/docs/demo-images/ocp-login.png?raw=true)

![Cloud Suite](https://github.com/redhatdemocentral/ocp-install-demo/blob/master/docs/demo-images/rhcs-arch.png?raw=true)

