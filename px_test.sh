#!/bin/bash

echo "Clean all in namespace fio-test"

if k get pod -n fio-test | egrep -q fio 
then
  k delete -f fio_deployment_pvc.yaml
  for i in `k get pvc -n fio-test | grep -v NAME | awk '{print $1}'`
  do
    k delete pvc -n fio-test $i
  done
fi

echo "Deploy File TEST"

kubectl apply -f configmap/file-config.yaml
kubectl apply -f fio_deployment_pvc.yaml

mkdir -p ~/logs/portworx/file/
sh report_file.sh &

echo "Wait 1 hour for file test"

sleep 3600

echo "Clean all in namespace fio-test"

if k get pod -n fio-test | egrep -q fio 
then
  k delete -f fio_deployment_pvc.yaml
  for i in `k get pvc -n fio-test | grep -v NAME | awk '{print $1}'`
  do
    k delete pvc -n fio-test $i
  done
fi

echo "Deploy Block TEST"

kubectl apply -f configmap/block-config.yaml
kubectl apply -f fio_statefulset.yaml

mkdir -p ~/logs/portworx/block/
sh report_block.sh &

echo "Wait 1 hour for block test"

sleep 3600

echo "Clean all in namespace fio-test"

if k get pod -n fio-test | egrep -q fio
then
  k delete -f fio_statefulset.yaml
  for i in `k get pvc -n fio-test | grep -v NAME | awk '{print $1}'`
  do
    k delete pvc -n fio-test $i
  done
fi

