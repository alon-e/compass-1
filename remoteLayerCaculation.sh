#!/bin/sh
cd docs/private_tangle
mkdir remote && cd remote

echo "starting Signing server"
./11_run_signature_source_server.sh &
sleep 10

echo "starting remote layer calculation"
./21_calculate_layers_remote.sh

echo "compare results"
diff ../data/layers/layer.0.csv data/layers/layer.0.csv
if diff -q ../data/layers/layer.0.csv data/layers/layer.0.csv &>/dev/null; then
  >&2 echo "same"
  exit -1
fi

echo "cleaning up"
docker kill $(docker ps | grep signature_source_server | cut -f1 -d\ )