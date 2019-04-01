#!/bin/sh
cd docs/private_tangle

echo "starting IRI"
./02_run_iri.sh &
until [ `docker ps | grep iri | cut -f1 -d\ ` ]; do
sleep 1;
done
sleep 20

echo "starting Signing server"
./11_run_signature_source_server.sh &
sleep 30

echo "starting Compass bootstrap"
./11_run_coordinator.sh -bootstrap -broadcast &
sleep 30

echo "restarting Compass"
docker kill $(docker ps | grep compass | cut -f1 -d\ )
while [ `docker ps | grep compass | cut -f1 -d\ ` ]; do
sleep 1;
done
sleep 20
./11_run_coordinator.sh -broadcast &
sleep 30

echo "cleaning up"
docker kill $(docker ps | grep compass | cut -f1 -d\ )
docker kill $(docker ps | grep signature_source_server | cut -f1 -d\ )
docker kill $(docker ps | grep iri | cut -f1 -d\ )