#!/bin/bash

clear

echo
echo "Shutting down OCP cluster..." && $(oc cluster down --docker-machine=openshift)
echo

docker-machine stop openshift

echo
echo "OCP cluster stopped..."
echo
echo "To restart, use ocp-restart.sh in support directory."
echo
