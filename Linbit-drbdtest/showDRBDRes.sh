#!/bin/bash

resouce_name=$(drbdsetup status |grep "^\w" |awk '{print $1}')
if [ -z "${resouce_name}" ]
then
  echo "No resource defined."
  exit 0
fi
echo "Get the resource name: ${resouce_name}"

#drbdsetup status
#drbdsetup show ${resouce_name}
drbdsetup status ${resouce_name} --verbose --statistics
