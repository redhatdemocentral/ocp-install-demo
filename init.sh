#!/bin/bash 

# wipe screen.
clear 

echo
echo "##############################################################"
echo "##                                                          ##"   
echo "##  Setting up your very own                                ##"
echo "##                                                          ##"   
echo "##    ###  ####  ##### #   #  #### #   # ##### ##### #####  ##"
echo "##   #   # #   # #     ##  # #     #   #   #   #       #    ##"
echo "##   #   # ####  ###   # # #  ###  #####   #   ####    #    ##"
echo "##   #   # #     #     #  ##     # #   #   #   #       #    ##"
echo "##    ###  #     ##### #   # ####  #   # ##### #       #    ##"
echo "##                                                          ##"   
echo "##    ####  ###  #   # #####  ###  ##### #   # ##### #####  ##"
echo "##   #     #   # ##  #   #   #   #   #   ##  # #     #   #  ##"
echo "##   #     #   # # # #   #   #####   #   # # # ###   #####  ##"
echo "##   #     #   # #  ##   #   #   #   #   #  ## #     #  #   ##"
echo "##    ####  ###  #   #   #   #   # ##### #   # ##### #   #  ##"
echo "##                                                          ##"   
echo "##      ####  #      ###  ##### #####  ###  ##### #   #     ##"   
echo "##      #   # #     #   #   #   #     #   # #   # ## ##     ##"   
echo "##      ####  #     #####   #   ####  #   # ##### # # #     ##"   
echo "##      #     #     #   #   #   #     #   # #  #  #   #     ##"   
echo "##      #     ##### #   #   #   #      ###  #   # #   #     ##"   
echo "##                                                          ##"   
echo "##  Brought to you by Eric D. Schabell                      ##"
echo "##                                                          ##"   
echo "##############################################################"
echo

# Ensure VirtualBox available.
#
if [[ `uname` == 'Darwin' ]]; then
		command -v VirtualBox -h >/dev/null 2>&1 || { echo >&2 "VirtualBox is required but not installed yet... downlaod here: https://www.virtualbox.org/wiki/Downloads"; exit 1; }
		echo "VirtualBox is installed..."
		echo
fi

if [[ `uname` == 'Darwin' ]]; then
	command -v oc help >/dev/null 2>&1 || { echo >&2 "OpenShift CLI tooling is required but not installed yet... downlaod here: https://s3.amazonaws.com/oso-preview-docker-registry/client-tools/3.3/oc-3.3.1.3-1-macosx.tar.gz"; exit 1; }
	echo "OpenShift command line tools installed..."
	echo
else
		# Linux machine.
		#
		command -v oc help >/dev/null 2>&1 || { echo >&2 "OpenShift CLI tooling is required but not installed yet... downlaod here: https://s3.amazonaws.com/oso-preview-docker-registry/client-tools/3.3/oc-3.3.1.3-1-linux.tar.gz"; exit 1; } 
		echo "OpenShift command line tools installed..."
		echo
fi


echo "Installing OSE with cluster up..."
echo
oc cluster up --image=registry.access.redhat.com/openshift3/ose --version=v3.3.1.3 --create-machine


if [ $? -ne 0 ]; then
		echo
		echo Error occurred during 'oc cluster up' command!
		echo
		echo Cleaning out existing 'openshift' docker machine.
		echo
		rm -r ~/.docker/machine/machines/openshift

		echo
		echo "Trying again to install OSE with cluster up..."
		echo
		oc cluster up --image=registry.access.redhat.com/openshift3/ose --version=v3.3.1.3 --create-machine

		if [ $? -ne 0 ]; then
			echo
			echo "Ensuring any previous OCP has been taken down..."
			echo
			oc cluster down --docker-machine=openshift
			VBoxManage controlvm openshift poweroff
			VBoxManage unregistervm openshift --delete
			
			if [ $? -ne 0 ]; then
				echo
				echo "Problems removing openshift VirtualBox entires, please clean out using the GUI if you can?"
				echo
				VBoxManage list vms
				exit
			fi

			echo
			echo "Trying again to install OSE with cluster up..."
			echo
			oc cluster up --image=registry.access.redhat.com/openshift3/ose --version=v3.3.1.3 --create-machine

		  if [ $? -ne 0 ]; then
				echo
				echo "Problems with cleaning out VirtualBox entires, check the GUI?"
				echo
				VBoxManage list vms
				exit
			fi
		fi
fi

echo
echo "Logging in as admin user..."
echo
oc login -u system:admin

LINE=( `oc status | grep https` )
OCP_IP=${LINE[7]}

echo 
echo "Set OCP IP to $OCP_IP..."
echo

echo
echo "Updating JBoss image streams..."
echo
oc delete -n openshift -f 'https://raw.githubusercontent.com/jboss-openshift/application-templates/master/jboss-image-streams.json'
echo
oc create -n openshift -f 'https://raw.githubusercontent.com/jboss-openshift/application-templates/master/jboss-image-streams.json'

echo
echo "Updating RHEL 7 image streams..."
echo
oc delete -n openshift -f 'https://raw.githubusercontent.com/openshift/openshift-ansible/master/roles/openshift_examples/files/examples/v1.3/image-streams/image-streams-rhel7.json'
echo
oc create -n openshift -f 'https://raw.githubusercontent.com/openshift/openshift-ansible/master/roles/openshift_examples/files/examples/v1.3/image-streams/image-streams-rhel7.json'

echo
echo "===================================================="
echo "=                                                  ="
echo "= Install complete, get ready to rock your Cloud.  ="
echo "= Look for information at end of OSE install.      ="
echo "=                                                  ="
echo "=  The server is accessible via web console at:    ="
echo "=                                                  ="
echo "=	    $OCP_IP            ="
echo "=                                                  ="
echo "=	 Log in as user: openshift-dev             ="
echo "=    password: devel                               ="
echo "=                                                  ="
echo "=  Admin log in as: admin                          ="
echo "=     password: admin                              ="
echo "=                                                  ="
echo "=  Now get your Red Hat Demo Central example       ="
echo "=  projects here:                                  ="
echo "=                                                  ="
echo "=     https://github.com/redhatdemocentral         ="
echo "=                                                  ="
echo "===================================================="
