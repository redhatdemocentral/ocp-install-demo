#!/bin/bash

clear

echo
echo "Restarting openshift docker machine..." 
echo

docker-machine start openshift

echo
echo "Restarting OCP cluster..."
echo
oc cluster up --image=registry.access.redhat.com/openshift3/ose --host-data-dir=/var/lib/boot2docker/ocp-data --docker-machine=openshift --host-config-dir=/var/lib/boot2docker/ocp-config --use-existing-config=true --host-pv-dir=/var/lib/boot2docker/ocp-pv

echo
echo "OCP cluster restarted."
echo
