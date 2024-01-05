#!/bin/bash

while(k get pod -n fio-test | egrep -q fio)
do
  if (k get pod -n fio-test | egrep -q Completed)
  then
    for i in `k get pod -n fio-test | grep Completed | awk '{print $1}'`
    do
      k logs -n fio-test $i > ~/logs/longhorn/$i.txt
      echo "================================================" >> ~/logs/longhorn/$i.txt
    done
  else
    if (k get pod -n fio-test | egrep -q 1h)
    then
      break
    fi
  fi
done
