#!/bin/sh 

SRC_URL=https://github.com/openshift/origin.git
SRC_REF=docker_version_warning
#OS_TYPE=darwin/amd64 
#OS_TYPE=linux/amd64 
OS_TYPE=windows/amd64 

# wipe screen.
clear 

echo
echo "##############################################################"
echo "##                                                          ##"   
echo "##  Building a new version of oc, for one of the following  ##"
echo "##  platforms with fix for boot2docker using v17.03:        ##"
echo "##                                                          ##"   
echo "##   linux/amd64 or darwin/amd64 or windows/amd64           ##"   
echo "##                                                          ##"   
echo "##############################################################"
echo

oc new-project my-project

oc new-app -f https://raw.githubusercontent.com/eschabell/build-origin/master/origin-builder.yaml -p SOURCE_URL=$SRC_URL -p SOURCE_REF=$SRC_REF -p PLATFORM=$OS_TYPE
