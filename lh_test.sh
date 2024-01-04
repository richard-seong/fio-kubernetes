#!/bin/bash

echo "Deploy Block TEST"

kubectl apply -f configmap/block-config.yaml
kubectl apply -f lh_fio_statefulset.yaml

#mkdir -p ~/logs/longhorn
#for i in `k get pod -n fio-test | grep -v NAME | awk '{print $1}'`
#do
# k logs -n fio-test $i -f > ~/logs/longhorn/$i.txt
#done

if k get pod -n fio-test | egrep -q fio
then
  k delete -f lh_fio_statefulset.yaml
  for i in `k get pvc -n fio-test | grep -v NAME | awk '{print $1}'`
  do
    k delete pvc -n fio-test $i
  done
fi

