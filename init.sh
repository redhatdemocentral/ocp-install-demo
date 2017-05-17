#!/bin/sh 

DOCKER_MAJOR_VER=1
DOCKER_MINOR_VER=13
OC_MAJOR_VER="v3"
OC_MINOR_VER=5
OC_MINI_VER=5
OCP_VERSION="$OC_MAJOR_VER.$OC_MINOR_VER"

# sets RAM usage limit for OCP.
VBOX_MEMORY=12288

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
echo "##  https://github.com/redhatdemocentral/ocp-install-demo   ##"
echo "##                                                          ##"   
echo "##############################################################"
echo

# Ensure VirtualBox available.
#
if [ `uname` == 'Darwin' ]; then
		command -v VirtualBox -h >/dev/null 2>&1 || { echo >&2 "VirtualBox is required but not installed yet... download here: https://www.virtualbox.org/wiki/Downloads"; exit 1; }
		echo "VirtualBox is installed..."
		echo
fi

# Ensure docker engine available.
#
command -v docker -h  >/dev/null 2>&1 || { echo >&2 "Docker is required but not installed yet... download here: https://www.docker.com/products/docker"; exit 1; }
echo "Docker is installed... checking for valid version..."
echo

# Check that docker deamon is setup correctly.
if [ `uname` == 'Darwin' ]; then
	# for osX.
	docker ps >/dev/null 2>&1

	if [ $? -ne 0 ]; then
		echo "Docker deamon is not running... please start Docker for osX..."
		echo
		exit
	fi
else
	# for Linux versions.
	docker ps >/dev/null 2>&1

	if [ $? -ne 0 ]; then
		echo "Docker deamon is not running... or is running insecurely..."
		echo
		echo "Check for instructions to run the docker deamon securely at:"
		echo 
		echo "    https://docs.docker.com/linux"
		echo
		exit
	fi
fi

echo "Verified the Docker deamon is running..."
echo

# Check docker enging version.
dockerverone=$(docker version -f='{{ .Client.Version }}' | awk -F[=.] '{print $1}')
dockervertwo=$(docker version -f='{{ .Client.Version }}' | awk -F[=.] '{print $2}')
if [ $dockerverone -eq $DOCKER_MAJOR_VER ] && [ $dockervertwo -ge $DOCKER_MINOR_VER ]; then
	echo "Valid version of docker engine found... $dockerverone.$dockervertwo"
	echo
else
	echo "Docker engine version $dockerverone.$dockervertwo found... need 1.13, please install: https://drive.google.com/open?id=0B9WSViV5BZ4aVXV5U3F4LVVmWVk"
	echo
	exit
fi

# Ensure OpenShift command line tools available.
#
command -v oc help >/dev/null 2>&1 || { echo >&2 "OpenShift CLI tooling is required but not installed yet... download here: https://drive.google.com/open?id=0B9WSViV5BZ4aVXV5U3F4LVVmWVk"; exit 1; }
echo "OpenShift command line tools installed... checking for valid version..."
echo

# Check oc version.
verfull=$(oc version | awk '/oc/{print $2}')
verone=$(echo $verfull | awk -F[=.] '{print $1}')
vertwo=$(echo $verfull | awk -F[=.] '{print $2}')
verthree=$(echo $verfull | awk -F[=.] '{print $3}')

# Check version elements, first is a string so using '==', the rest are integers.
if [ $verone == $OC_MAJOR_VER ] && [ $vertwo -eq $OC_MINOR_VER ] && [ $verthree -ge $OC_MINI_VER ]; then
	echo "Version of installed OpenShift command line tools correct... $verone.$vertwo.$verthree"
	echo
else
	echo "Version of installed OpenShift command line tools is $verone.$vertwo.$verthree, must be $OC_MAJOR_VER.$OC_MINOR_VER.$OC_MINI_VER..."
	echo
	if [ `uname` == 'Darwin' ]; then
		echo "Download for Mac here: https://drive.google.com/open?id=0B9WSViV5BZ4aVXV5U3F4LVVmWVk"
		exit
	else
		echo "Download for Linux here: https://drive.google.com/open?id=0B9WSViV5BZ4aVXV5U3F4LVVmWVk"
		exit
	fi
fi

echo "Setting up OpenShift docker machine..."
echo
docker-machine create --driver virtualbox --virtualbox-cpu-count "2" --virtualbox-memory "$VBOX_MEMORY" --engine-insecure-registry 172.30.0.0/16 --virtualbox-boot2docker-url https://github.com/boot2docker/boot2docker/releases/download/v1.13.1/boot2docker.iso openshift 

if [ $? -ne 0 ]; then
		echo
		echo "Error occurred during openshift docker machine creation..."
		echo
		echo "Cleaning out existing 'openshift' machine..."
		echo
		docker-machine rm -f openshift

		echo "Setting up new OpenShift docker machine..."
    echo
    docker-machine create --driver virtualbox --virtualbox-cpu-count "2" --virtualbox-memory "$VBOX_MEMORY" --engine-insecure-registry 172.30.0.0/16 --virtualbox-boot2docker-url https://github.com/boot2docker/boot2docker/releases/download/v1.13.1/boot2docker.iso openshift 

		if [ $? -ne 0 ]; then
				echo
				echo "Problem with docker machine creation that I can't resolve, please raise an issue and add error output:"
				echo
				echo "   https://github.com/redhatdemocentral/ocp-install-demo/issues/new"
				echo
				exit
		fi
fi

echo "Installing OCP with cluster up..."
echo
oc cluster up --docker-machine=openshift --image=registry.access.redhat.com/openshift3/ose --version=$OCP_VERSION

if [ $? -ne 0 ]; then
		echo
		echo "Error occurred during 'oc cluster up' command..."
		echo
		echo "Cleaning out existing 'openshift' machine..."
		echo
		docker-machine rm -f openshift

    echo "Setting up new OpenShift docker machine..."
    echo
    docker-machine create --driver virtualbox --virtualbox-cpu-count "2" --virtualbox-memory "$VBOX_MEMORY" --engine-insecure-registry 172.30.0.0/16 --virtualbox-boot2docker-url https://github.com/boot2docker/boot2docker/releases/download/v1.13.1/boot2docker.iso openshift 

		echo
		echo "Trying again to install OCP with cluster up..."
		echo
		echo "Using osX version of cluster up... installing second try OCP version: $OCP_VERSION"
		echo
		oc cluster up --docker-machine=openshift --image=registry.access.redhat.com/openshift3/ose --version=$OCP_VERSION

		if [ $? -ne 0 ]; then
				echo
				echo "Problem with installation that I can't resolve, please raise an issue and add error output:"
				echo
				echo "   https://github.com/redhatdemocentral/ocp-install-demo/issues/new"
				echo
				exit
		fi
fi


echo
echo "Logging in as admin user..."
echo
oc login -u system:admin

# capturing OCP IP address from status command.
OCP_IP=$(oc status | awk '/My Project/{print $8}')

echo 
echo "Set OCP IP to $OCP_IP..."
echo

# set console environment to openshift container.
eval "$(docker-machine env openshift)"

echo "Updating JBoss image streams..."
echo
oc create -n openshift -f 'https://raw.githubusercontent.com/jboss-openshift/application-templates/master/jboss-image-streams.json'

if [ $? -ne 0 ]; then
	echo
	echo "Problem with accessing JBoss product streams for OCP..."
	echo
  echo "Trying again..."
	echo
	sleep 10
  oc create -n openshift -f 'https://raw.githubusercontent.com/jboss-openshift/application-templates/master/jboss-image-streams.json'
	
	if [ $? -ne 0 ]; then
		echo "Failed again, exiting, check output messages and network connectivity before running install again..."
		echo
		docker-machine rm -f openshift
		exit
	fi
fi

echo
echo "Updating Fuse image streams..."
echo
oc create -n openshift -f 'https://raw.githubusercontent.com/jboss-fuse/application-templates/master/fis-image-streams.json'

if [ $? -ne 0 ]; then
	echo
	echo "Problem with accessing Fuse Integration product streams for OCP..."
	echo
  echo "Trying again..."
	echo
	sleep 10
  oc create -n openshift -f 'https://raw.githubusercontent.com/jboss-fuse/application-templates/master/fis-image-streams.json'
	
	if [ $? -ne 0 ]; then
		echo "Failed again, exiting, check output messages and network connectivity before running install again..."
		echo
		docker-machine rm -f openshift
		exit
	fi
fi

echo
echo "Updating EAP templates..."
echo
oc create -n openshift -f 'https://raw.githubusercontent.com/jboss-openshift/application-templates/master/eap/eap70-basic-s2i.json'

if [ $? -ne 0 ]; then
	echo
	echo "Problem with accessing JBoss EAP product streams for OCP..."
	echo
  echo "Trying again..."
	echo
	sleep 10
  oc create -n openshift -f 'https://raw.githubusercontent.com/jboss-openshift/application-templates/master/eap/eap70-basic-s2i.json'
	
	if [ $? -ne 0 ]; then
		echo "Failed again, exiting, check output messages and network connectivity before running install again..."
		echo
		docker-machine rm -f openshift
		exit
	fi
fi

echo
echo "Updating Decision Server templates..."
echo
oc create -n openshift -f 'https://raw.githubusercontent.com/jboss-openshift/application-templates/master/decisionserver/decisionserver63-basic-s2i.json'

if [ $? -ne 0 ]; then
	echo
	echo "Problem with accessing JBoss BRMS product streams for OCP..."
	echo
  echo "Trying again..."
	echo
	sleep 10
  oc create -n openshift -f 'https://raw.githubusercontent.com/jboss-openshift/application-templates/master/decisionserver/decisionserver63-basic-s2i.json'
	
	if [ $? -ne 0 ]; then
		echo "Failed again, exiting, check output messages and network connectivity before running install again..."
		echo
		docker-machine rm -f openshift
		exit
	fi
fi

echo
echo "Updating RHEL 7 image streams..."
echo
oc delete -n openshift -f 'https://raw.githubusercontent.com/openshift/openshift-ansible/master/roles/openshift_examples/files/examples/v1.4/image-streams/image-streams-rhel7.json'
oc create -n openshift -f 'https://raw.githubusercontent.com/openshift/openshift-ansible/master/roles/openshift_examples/files/examples/v1.4/image-streams/image-streams-rhel7.json'

if [ $? -ne 0 ]; then
	echo
	echo "Problem with accessing RHEL product streams for OCP..."
	echo
  echo "Trying again..."
	echo
	sleep 10
  oc delete -n openshift -f 'https://raw.githubusercontent.com/openshift/openshift-ansible/master/roles/openshift_examples/files/examples/v1.4/image-streams/image-streams-rhel7.json'
  oc create -n openshift -f 'https://raw.githubusercontent.com/openshift/openshift-ansible/master/roles/openshift_examples/files/examples/v1.4/image-streams/image-streams-rhel7.json'
	
	if [ $? -ne 0 ]; then
		echo "Failed again, exiting, check output messages and network connectivity before running install again..."
		echo
		docker-machine rm -f openshift
		exit
	fi
fi

echo
echo "Update .Net image streams..."
echo
oc create -n openshift -f 'https://raw.githubusercontent.com/redhat-developer/s2i-dotnetcore/master/dotnet_imagestreams.json'

if [ $? -ne 0 ]; then
	echo
	echo "Problem with accessing .Net image streams for OCP..."
	echo
  echo "Trying again..."
	echo
	sleep 10
  oc create -n openshift -f 'https://raw.githubusercontent.com/redhat-developer/s2i-dotnetcore/master/dotnet_imagestreams.json'
	
	if [ $? -ne 0 ]; then
		echo "Failed again, exiting, check output messages and network connectivity before running install again..."
		echo
		docker-machine rm -f openshift
		exit
	fi
fi

echo
echo "===================================================="
echo "=                                                  ="
echo "= Install complete, get ready to rock your Cloud.  ="
echo "= Look for information at end of OCP install.      ="
echo "=                                                  ="
echo "=  The server is accessible via web console at:    ="
echo "=                                                  ="
echo "=	  $OCP_IP              ="
echo "=                                                  ="
echo "=  Log in as user: openshift-dev                   ="
echo "=        password: devel                           ="
echo "=                                                  ="
echo "=  Admin log in as: admin                          ="
echo "=         password: admin                          ="
echo "=                                                  ="
echo "=  Now get your Red Hat Demo Central example       ="
echo "=  projects here:                                  ="
echo "=                                                  ="
echo "=     https://github.com/redhatdemocentral         ="
echo "=                                                  ="
echo "=  When finished, clean up your demo with:         ="
echo "=                                                  ="
echo "=     $ docker-machine rm -f openshift             ="
echo "=                                                  ="
echo "===================================================="
