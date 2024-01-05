#!/bin/bash

echo "Deploy Block TEST"

kubectl apply -f configmap/block-config.yaml
kubectl apply -f lh_fio_statefulset.yaml

mkdir -p ~/logs/longhorn
sh report_block_lh.sh &

echo "Wait 1 hour for block test"

sleep 3600

echo "Clean all in namespace fio-test"

if k get pod -n fio-test | egrep -q fio
then
  k delete -f lh_fio_statefulset.yaml
  for i in `k get pvc -n fio-test | grep -v NAME | awk '{print $1}'`
  do
    k delete pvc -n fio-test $i
  done
fi

