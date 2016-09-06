#!/bin/bash

function lvm_remove()
{
for lvname in `lvs |grep "scratch" | awk '{print $1}' |sed "s/ //g"`
do
  lvremove -f /dev/scratch/${lvname}
done
}

resouce_name=$(drbdsetup status |grep "^\w" |awk '{print $1}')
if [ -z ${resouce_name} ]
then
  echo "No resource defined."
  echo "Remove lvs of 'scratch'"
  lvm_remove
  exit 0
fi
echo "Get the resource name: ${resouce_name}"

temp_nodes_number=$(drbdsetup show ${resouce_name} |grep -c connection)
nodes_number=$((temp_nodes_number+1))
echo "Have $nodes_number nodes."

echo "=== Before del-peer:"
drbdsetup status

for i in `seq 0 ${temp_nodes_number}`
do
drbdsetup del-peer ${resouce_name} ${i}
done

echo "=== After del-peer:"
drbdsetup status

echo "Down the connection"
drbdsetup down ${resouce_name}

echo "Remove lvs of 'scratch'"
lvm_remove
