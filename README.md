OpenShift Container Platform Install Demo
=========================================
If you are looking to develop containerized applications, the OpenShift Container Plaform (OCP) can help you by providing 
private PaaS (Cloud) environment you can install locally. It includes the same container development and run-time 
tools used to create and deploy containers for large data centers. 

This project requires a docker engine, OpenShift command line tools and VirtualBox, but these checks happen when you run the
installation and point you to what is missing. It also checks that you have the right versions running too.

Pro Tip: Pay close attention to console output, will guide you to dependencies you need if missing. These dependencies are 
listed here and the install provides pointers to downloads if missing:

   ```
   1. VirtualBox for Windows and OSX
   2. Hyper-V for Windows 10 (Windows Feature Install)
      a. Important - Use Hyper-V Manager to create "ocpNET" Virtual Switch. (name is used in script)
      b. Important - Set "ocpNET" to External Network physical/wireless interface (with DHCP) - Must have Internet.
   3. KVM for Linux
   4. Docker-machine tooling
   5. Ansible-playbook tooling
   5. OpenShift Client (oc) v3.9.14
   ```
Need more help? Follow a lab workshop on [how to install OpenShift Container Platform step-by-step](https://appdevcloudworkshop.github.io/lab01.html).


Install on your machine
-----------------------
1. [Download and unzip.](https://github.com/redhatdemocentral/ocp-install-demo/archive/master.zip)

2. Run 'init.sh', 'init.bat' or 'init-win10.bat' file, then sit back. (Note: 'init.bat' and 'init-win10.bat' must be run with Administrative privileges.)

3. Follow displayed instructions to log in to your brand new OpenShift Container Platform!

4. Still want more help installing? Try <a href="https://appdevcloudworkshop.github.io/lab01.html" target="_blank">these 
instructions (part of an online workshop)</a> that explain the installation in detail.


Notes
-----
Installation reserves default of 6GB memory on your machine for OCP, see comments at top of init scripts to adjust variable 
used to limit memory usage based on your needs.

-----

Log in to the OCP console with:
   
   ```
   Developer user:  openshift-dev
   Developer pass:  devel

   Admin user: admin
   Admin pass: admin
   ```

------

Persisitence is enabled, so to shutdown and restart the openshift cluster with your projects in place DO NOT
run 'docker-machine rm -f openshift' or use init.sh / init.bat, instead:

   ```
   # shutdown using:
   #
   $ oc cluster down --docker-machine=openshift
   $ docker-machine stop openshift

   # restart use the existing data and configuration:
   #
   $ docker-machine start openshift
   $ oc cluster up --image=registry.access.redhat.com/openshift3/ose --host-data-dir=/var/lib/boot2docker/ocp-data  \
        --docker-machine=openshift --host-config-dir=/var/lib/boot2docker/ocp-config --use-existing-config=true     \
        --host-pv-dir=/var/lib/boot2docker/ocp-pv
   ```

You can find these commands for unix based machines in the directory support/{ocp-stop.sh|ocp-restart.sh}.

-----

Network errors? If you recieve the following error, on Linux:

   ```
   Error: did not detect an --insecure-registry argument on the Docker daemon
   ```

Then ensure that the Docker daemon is running with the following argument by:

   ```
   # Add the following to /etc/sysconfig/docker file and
   # restart the docker service:
   #
   INSECURE_REGISTRY='--insecure-registry 172.30.0.0/16'
   ```

Or this network error on osX:

   ```
   Unable to connect to the server: net/http: TLS handshake timeout
   ```

Then add the this IP to the Docker Deamon insecure registry list:

   ```
   172.30.0.0/16

   ```

-----

This project has an install script that is setup to allow you to re-run it without worrying about previous
installations. If you re-run it, it removes old 'openshift' machines and reinstalls for you. 

-----


Supporting Articles
-------------------
- [Free Online Self-Paced Workshop Updated to OpenShift Container Platform 3.7](http://www.schabell.org/2017/12/free-online-self-paced-workshop-updated-openshift-37.html)

- [Cloud Happiness - How to instal new OpenShift Container Platform 3.7 in minutes](http://www.schabell.org/2017/12/cloud-happiness-how-to-install-new-openshift-v37-in-minutes.html) 

- [Windows Hyper-V OpenShift Container Platform Install in Minutes](http://www.schabell.org/2017/11/windows-hyper-v-openshift-container-platform-install-minutes.html)

- [10 Steps to Cloud Happiness: Step 2 - Use a Container Catalog](http://www.schabell.org/2017/10/10-steps-to-cloud-happiness-step-2.html)

- [10 Steps to Cloud Happiness: Step 1 - Get a Cloud](http://www.schabell.org/2017/10/10-steps-to-cloud-happiness-step-1.html)

- [Cloud Happiness - How to install new OpenShift Container Platform 3.6 in just minutes](http://www.schabell.org/2017/08/cloud-happiness-how-to-install-new-openshift-v36-in-minutes.html)

- [Anyone show you how to install OpenShift Container Platform in minutes? (video)](http://www.schabell.org/2017/06/howto-install-openshift-container-platform-in-minutes-video.html)

- [Cloud Happiness - How To Get OpenShift Container Platform v3.5 Installed in Minutes](http://www.schabell.org/2017/05/cloud-happiness-how-to-get-openshift.html)

- [Red Hat Summit - How to setup a container platform for modern application delivery in minutes](http://www.schabell.org/2017/05/redhat-summit-how-to-setup-container-platform-slides.html)

- [Red Hat Summit DevZone - Anyone show you how to install OpenShift Container Platform in minutes?](http://www.schabell.org/2017/05/devzone-how-to-install-openshift-slides.html)

- [Get hands-on with AppDev Cloud free online workshop.](http://appdevcloudworkshop.github.io)

- [Cloud Happiness - OpenShift Container Platform Install on Windows, why wait?](http://www.schabell.org/2017/03/cloud-happiness-openshift-container-platform-windows-install.html)

- [Cloud Happiness - OpenShift Container Platform v3.4 install demo update](http://www.schabell.org/2017/02/cloud-happiness-openshift-container-platform-install-updated.html)

- [Holiday Homework - Red Hat Cloud demo updates](http://www.schabell.org/2016/12/holiday-homework-redhat-cloud-demo-updates.html)

- [3 Steps to Cloud Happiness with OpenShift Container Platform](http://www.schabell.org/2016/11/3-steps-to-cloud-happiness-with-ocp.html)


Released versions
-----------------
See the tagged releases for the following versions of the product:

- v2.5 - OpenShift Container Platform v3.9 based on OpenShift command line tools v3.9.14, updated image streams and templates to v3.10 feeds.

- v2.4 - OpenShift Container Platform v3.9 based on OpenShift command line tools v3.9.14.

- v2.3 - OpenShift Container Platform v3.7 based on OpenShift command line tools v3.7.9 and added process server templates.

- v2.2 - OpenShift Container Platform v3.7 based on OpenShift command line tools v3.7.9 with Docker dependency removed.

- v2.1 - OpenShift Container Platform v3.7 based on OpenShift command line tools v3.7.9.

- v2.0 - OpenShift Container Platform v3.6 based on OpenShift command line tools v3.6.173 with Hyper-V Windows installation.

- v1.9 - OpenShift Container Platform v3.6 based on OpenShift command line tools v3.6.173 with tech preview service catalog enabled.

- v1.8 - OpenShift Container Platform v3.6 based on OpenShift command line tools v3.6.173 with persistence enabled for restarts.

- v1.7 - OpenShift Container Platform v3.5 based on OpenShift command line tools v3.5.5.5 with persistence enabled for restarts.

- v1.6 - OpenShift Container Platform v3.5 based on OpenShift command line tools v3.5.5.5.

- v1.5 - OpenShift Container Platform v3.4 based on OpenShift command line tools v3.4.1.2-fixed.

- v1.4 - OpenShift Container Platform v3.4 based on OpenShift command line tools v3.4.1.2, added more JBoss product templates.

- v1.3 - OpenShift Container Platform v3.4 based on OpenShift command line tools v3.4.1.2, added Windows installer option.

- v1.2 - OpenShift Container Platform v3.4 based on OpenShift command line tools v3.4.1.2, improved docker validation for Linux.

- v1.1 - OpenShift Container Platform v3.4 based on OpenShift command line tools v3.4.1.2.

- v1.0 - OpenShift Container Platform v3.3 based on OpenShift command line tools v3.3.1.3.

[![OCP Video](https://github.com/redhatdemocentral/ocp-install-demo/blob/master/docs/demo-images/ocp-install-video.png?raw=true)](https://youtu.be/Rj0We91ec9Y)

![OCP Login](https://github.com/redhatdemocentral/ocp-install-demo/blob/master/docs/demo-images/ocp-login.png?raw=true)

![OCP Catalog](https://github.com/redhatdemocentral/ocp-install-demo/blob/master/docs/demo-images/ocp-service-catalog.png?raw=true)

![Cloud Suite](https://github.com/redhatdemocentral/ocp-install-demo/blob/master/docs/demo-images/rhcs-arch.png?raw=true)

