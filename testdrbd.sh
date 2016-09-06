#!/bin/bash

#Configure machines list first
MACHINES=(192.168.122.57 192.168.122.29 192.168.122.35 192.168.122.216)
RANDOM_FILES=30
################

RES_NAME=$1
RUN_TIMES=$2

function pickOneRandomNumber()
{
  a=$(echo "$RANDOM%${#MACHINES[@]}" | bc)
  echo $a
}

function verifyIt()
{
  echo -n "=== Verify(${1}):"
  ssh root@${1} "echo \" on \$HOSTNAME\""
  ssh root@${1} "drbdadm primary ${2}"
  minor=$(ssh root@${1} "drbdsetup status ${2} --verbose |grep minor|sed 's/.* minor:\([0-9]*\).*/\1/'")
  ssh root@${1} "mount /dev/drbd${minor} /mnt; cd /mnt; 
                 md5sum -c md5file"
  ssh root@${1} "umount /mnt; sleep 2; drbdadm secondary ${2}"
}

function testIt()
{
  echo -n "=== Make it primary(${1}):" 
  ssh root@${1} "echo \" on \$HOSTNAME\""
  ssh root@${1} "drbdadm primary ${2}"
  echo "=== Generate random files:"
  minor=$(ssh root@${1} "drbdsetup status ${2} --verbose |grep minor|sed 's/.* minor:\([0-9]*\).*/\1/'")
  ssh root@${1} "mount /dev/drbd${minor} /mnt; cd /mnt; 
                 for i in \$(seq ${RANDOM_FILES}); do dd if=/dev/random of=./myrandom.file\${i} bs=512 count=20000 >/dev/null 2>&1; sleep 1; done;
                 rm -rf md5file; for i in \$(ls myrandom.file*); do md5sum \${i} >> md5file; done; cat md5file"
  sleep 5;
  ssh root@${1} "cd /; umount /mnt; sleep 2; drbdadm secondary ${2}"
}

rm -rf drbd-result
for i in `seq ${RUN_TIMES}`
do
  randomNo=$(pickOneRandomNumber)
  ip=${MACHINES[${randomNo}]}
  testIt $ip $RES_NAME

  randomNo=$(pickOneRandomNumber)
  ip=${MACHINES[${randomNo}]}
  verifyIt $ip $RES_NAME | tee -a drbd-result
done
