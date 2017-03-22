#!/bin/sh 

DOCKER_MAJOR_VER=1
DOCKER_MINOR_VER=10
OC_MAJOR_VER="v3"
OC_MINOR_VER=4
OC_MINI_VER=1
OCP_VERSION="$OC_MAJOR_VER.$OC_MINOR_VER"
OCP_FIX="v1.5.0-alpha"

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
#if [ $dockerverone -eq $DOCKER_MAJOR_VER ] && [ $dockervertwo -ge $DOCKER_MINOR_VER ]; then
if [ $dockerverone -gt $DOCKER_MAJOR_VER  ] || ([ $dockerverone -eq $DOCKER_MAJOR_VER  ] && [ $dockervertwo -ge $DOCKER_MINOR_VER ]) ; then
	echo "Valid version of docker engine found... $dockerverone.$dockervertwo"
	echo
else
	echo "Docker engine version $dockerverone.$dockervertwo found... need 1.10+, please update: https://www.docker.com/products/docker"
	echo
	exit
fi

# Ensure OpenShift command line tools available.
#
command -v oc help >/dev/null 2>&1 || { echo >&2 "OpenShift CLI tooling is required but not installed yet... download here: https://s3.amazonaws.com/oso-preview-docker-registry/client-tools/3.3/oc-3.3.1.3-1-macosx.tar.gz"; exit 1; }
echo "OpenShift command line tools installed... checking for valid version..."
echo

# Check oc version.
verfull=$(oc version | awk '/oc/{print $2}')
verone=$(echo $verfull | awk -F[=.] '{print $1}')
vertwo=$(echo $verfull | awk -F[=.] '{print $2}')
verthree=$(echo $verfull | awk -F[=.] '{print $3}')

echo 
echo "Version is: $verfull and $verone.$vertwo.$verthree"
echo 

# Check version elements, first is a string so using '==', the rest are integers.
if [ "$verone.$vertwo.$verthree" == $OCP_FIX ] || ( [ $verone == $OC_MAJOR_VER ] && [ $vertwo -eq $OC_MINOR_VER ] && [ $verthree -ge $OC_MINI_VER ] ); then
	echo "Version of installed OpenShift command line tools correct... $verone.$vertwo.$verthree"
	echo
else
	echo "Version of installed OpenShift command line tools is $verone.$vertwo.$verthree, must be $OC_MAJOR_VER.$OC_MINOR_VER.$OC_MINI_VER or higher..."
	echo
	if [ `uname` == 'Darwin' ]; then
		echo "Download for Mac here: https://s3.amazonaws.com/oso-preview-docker-registry/client-tools/3.4/oc-3.4.1.2-1-macosx.tar.gz"
		exit
	else
		echo "Download for Linux here: https://s3.amazonaws.com/oso-preview-docker-registry/client-tools/3.4/oc-3.4.1.2-1-linux.tar.gz"
		exit
	fi
fi

echo "Installing OCP with cluster up..."
echo
if [ `uname` == 'Darwin' ]; then
	# osx uses --create-machine.
	echo "Using osX version of cluster up... installing OCP version: $OCP_VERSION"
	echo
	oc cluster up --image=registry.access.redhat.com/openshift3/ose --version=$OCP_VERSION --create-machine
else
	# linux versions don't need --create-machine.
	echo "Using Linux version of cluster up... installing OCP version: $OCP_VERSION"
	echo
	oc cluster up --image=registry.access.redhat.com/openshift3/ose --version=$OCP_VERSION
fi


if [ $? -ne 0 ]; then
		echo
		echo Error occurred during 'oc cluster up' command!
		echo
		echo Cleaning out existing 'openshift' machine.
		echo
		docker-machine rm -f openshift

		echo
		echo "Trying again to install OCP with cluster up..."
		echo
		if [ `uname` == 'Darwin' ]; then
			# osx uses --create-machine.
			echo "Using osX version of cluster up... installing second try OCP version: $OCP_VERSION"
			echo
			oc cluster up --image=registry.access.redhat.com/openshift3/ose --version=$OCP_VERSION --create-machine
		else
			# linux versions don't need --create-machine.
			echo "Using Linux version of cluster up... installing second try OCP version: $OCP_VERSION"
			echo
			oc cluster up --image=registry.access.redhat.com/openshift3/ose --version=$OCP_VERSION
		fi

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

echo
echo "Updating Fuse image streams..."
echo
oc create -n openshift -f 'https://raw.githubusercontent.com/jboss-fuse/application-templates/master/fis-image-streams.json'

echo
echo "Updating EAP templates..."
echo
oc create -n openshift -f 'https://raw.githubusercontent.com/jboss-openshift/application-templates/master/eap/eap70-basic-s2i.json'

echo
echo "Updating Decision Server templates..."
echo
oc create -n openshift -f 'https://raw.githubusercontent.com/jboss-openshift/application-templates/master/decisionserver/decisionserver63-basic-s2i.json'

echo
echo "Updating RHEL 7 image streams..."
echo
oc delete -n openshift -f 'https://raw.githubusercontent.com/openshift/openshift-ansible/master/roles/openshift_examples/files/examples/v1.4/image-streams/image-streams-rhel7.json'
oc create -n openshift -f 'https://raw.githubusercontent.com/openshift/openshift-ansible/master/roles/openshift_examples/files/examples/v1.4/image-streams/image-streams-rhel7.json'

echo
echo "Update .Net image streams..."
echo
oc create -n openshift -f 'https://raw.githubusercontent.com/redhat-developer/s2i-dotnetcore/master/dotnet_imagestreams.json'

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
