#!/bin/bash

while(k get pod -n fio-test | egrep -q fio)
do
  if (k get pod -n fio-test | egrep -q BackOff)
  then
    for i in `k get pod -n fio-test | grep -i backoff | awk '{print $1}'`
    do
      k logs -n fio-test $i >> ~/logs/portworx/file/$i.txt
      echo "================================================"
    done
  else
    if (k get pod -n fio-test | egrep -q 1h)
    then
      break
    fi
  fi
done
