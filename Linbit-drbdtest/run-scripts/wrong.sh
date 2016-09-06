#!/bin/bash
PEERS=(drbd-test-sp2-manually-1 drbd-test-sp2-manually-2 drbd-test-sp2-manually-3 drbd-test-sp2-manually-4)
PEER=(drbd-test-sp2-manually-2 drbd-test-sp2-manually-3 drbd-test-sp2-manually-4)
PEER2=(drbd-test-sp2-manually-1 drbd-test-sp2-manually-2)

function clean_up()
{
  echo "Starting Clean up the environment after case: $1"
  for i in ${PEERS[@]}
  do
    {
      #ssh root@${i} "/root/show.sh"
      ssh root@${i} "echo \"Cleaning... \$(hostname)\"; /root/cleanup.sh >/dev/null 2>&1"
      ssh root@${i} "echo \"Cleaning... \$(hostname)\"; /root/show.sh"
    } &
  done
  
  wait
}

#diskless NG:
# resource.skip_initial_sync() can't finished check status since one of them is diskless.
echo "Starting case diskless ============"
./tests/diskless ${PEERS[@]}
echo -e "Done\n"; sleep 5;clean_up diskless

# #resync-never-connected.KNOWN NG: (3 nodes)
# # SHould OK. Line 53 and line 54 should out of range(), check before fio test!
# echo "Starting case resync-never-connected.KNOWN ============"
# ./tests/resync-never-connected.KNOWN drbd-test-sp2-manually-1 drbd-test-sp2-manually-2 drbd-test-sp2-manually-3
# echo -e "Done\n"; sleep 5;clean_up resync-never-connected.KNOWN

#attach-detach.KNOWN NG:
# Attach/detach will hang...
echo "Starting case attach-detach.KNOWN ============"
./tests/attach-detach.KNOWN ${PEERS[@]}
echo -e "Done\n"; sleep 5;clean_up attach-detach.KNOWN

#multi-path NG? - Need the other path: (2 nodes)
echo "Starting case multi-path ============"
./tests/multi-path ${PEER2[@]}
#RuntimeError: ('%s has no eth0:1', <python.drbdtest.Node object at 0x7f9acd5b07d0>)
echo -e "Done\n"; sleep 5;clean_up multi-path

#compat-with-84 UNKNOWN (2 nodes)
echo "Starting case compat-with-84 ============"
./tests/compat-with-84 ${PEER2[@]}
#No /data/drbd-8.4/drbd/drbd.ko
echo -e "Done\n"; sleep 5;clean_up compat-with-84

#multiple-devices.KNOWN NG -  would enable an already enabled connection
# Should add disks in the same time, since connection should only once
echo "Starting case multiple-devices.KNOWN ============"
./tests/multiple-devices.KNOWN ${PEER2[@]}
echo -e "Done\n"; sleep 5;clean_up multiple-devices.KNOWN

#tl_restart-stress.KNOWN NG - would enable an already enabled connection
echo "Starting case tl_restart.KNOWN ============"
./tests/tl_restart-stress.KNOWN ${PEER2[@]}
echo -e "Done\n"; sleep 5;clean_up tl_restart-stress.KNOWN
