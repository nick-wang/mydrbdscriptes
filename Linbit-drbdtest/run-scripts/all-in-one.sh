#!/bin/bash
#PEERS=(drbd-test-sp2-manually-1 drbd-test-sp2-manually-2 drbd-test-sp2-manually-3 drbd-test-sp2-manually-4)
#PEER=(drbd-test-sp2-manually-2 drbd-test-sp2-manually-3 drbd-test-sp2-manually-4)
#PEER2=(drbd-test-sp2-manually-1 drbd-test-sp2-manually-2)

function clean_up()
{
  echo "Starting Clean up the environment after case: $1"
  for i in ${PEERS[@]}
  do
    {
      #ssh root@${i} "/root/show.sh"
      ssh root@${i} "echo \"Cleaning... \$(hostname)\"; /root/cleanup.sh >/dev/null 2>&1"
    } &
  done
  
  wait
}


#connect OK:
#./tests/connect ${PEERS[@]}
echo "Starting case connect ============"
./tests/connect drbd-test-sp2-manually-1 drbd-test-sp2-manually-2 drbd-test-sp2-manually-3
echo -e "Done\n"; sleep 5;clean_up connect

#initial-resync OK:
echo "Starting case initial-resync ============"
./tests/initial-resync ${PEERS[@]}
echo -e "Done\n"; sleep 5;clean_up initial-resync

#latency OK:   (2 nodes)
echo "Starting case latency ============"
./tests/latency drbd-test-sp2-manually-1 drbd-test-sp2-manually-2
echo -e "Done\n"; sleep 5;clean_up latency

#misaligned-bio OK: (2 nodes)
echo "Starting case misaligned-bio ============"
./tests/misaligned-bio drbd-test-sp2-manually-1 drbd-test-sp2-manually-2
echo -e "Done\n"; sleep 5;clean_up misaligned-bio

#switch-primaries OK: (when using 2 nodes, but not required)
echo "Starting case switch-primaries ============"
./tests/switch-primaries drbd-test-sp2-manually-1 drbd-test-sp2-manually-2
echo -e "Done\n"; sleep 5;clean_up switch-primaries

#ref-count NG?OK? - seems endup without error, should OK:  (2 nodes)
echo "Starting case ref-count ============"
./tests/ref-count drbd-test-sp2-manually-1 drbd-test-sp2-manually-2
echo -e "Done\n"; sleep 5;clean_up ref-count

#add-connect-delete OK - but first lvm can not be deleted: (2 nodes)
echo "Starting case add-connect-delete ============"
./tests/add-connect-delete ${PEER2[@]}
echo -e "Done\n"; sleep 5;clean_up add-connect-delete

#add-path-multiple-times OK - but first lvm can not be deleted: (2 nodes)
echo "Starting case add-path-multiple-times ============"
./tests/add-path-multiple-times ${PEER2[@]}
echo -e "Done\n"; sleep 5;clean_up add-path-multiple-times

#ahead-behind.KNOWN OK - but first lvm can not be deleted: (2 nodes or 3 nodes)
echo "Starting case ahead-behind.KNOWN ============"
./tests/ahead-behind.KNOWN ${PEER2[@]}
echo -e "Done\n"; sleep 5;clean_up ahead-behind.KNOWN

#resize.KNOWN OK:
echo "Starting case resize.KNOWN ============"
./tests/resize.KNOWN ${PEER2[@]}
echo -e "Done\n"; sleep 5;clean_up resize.KNOWN

# # SHould OK. Line 53 and line 54 should out of range(), check before fio test!
#
#resync-never-connected.KNOWN NG: (3 nodes)
echo "Starting case resync-never-connected.KNOWN ============"
./tests/resync-never-connected.KNOWN ${PEERS[@]}
echo -e "Done\n"; sleep 5;clean_up resync-never-connected.KNOWN
