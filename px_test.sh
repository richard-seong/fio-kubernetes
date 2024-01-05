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

#mkdir -p ~/logs/portworx/file/
#for i in `k get pod -n fio-test | grep -v NAME | awk '{print $1}'`
#do
# k logs -n fio-test $i -f > ~/logs/portworx/file/$i.txt
#done

#for i in `seq 3`
#do
# kubectl scale --replicas=$i deployment.apps/fio -n fio-test
# sleep 1200
#done

echo "Wait 1 hour for block test"

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

#mkdir -p ~/logs/portworx/block/
#for i in `k get pod -n fio-test | grep -v NAME | awk '{print $1}'`
#do
# k logs -n fio-test $i -f > ~/logs/portworx/block/$i.txt
#done

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

