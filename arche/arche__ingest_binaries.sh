#/bin/bash

echo "ingest binaries for ${TOPCOLID} into ${ARCHE}"
wget -O to_ingest/wmp1.nt https://cloud.oeaw.ac.at/index.php/s/wnJsHWoa49wcHxY/download/wmp1.nt
docker run --rm \
  -v ${PWD}/to_ingest:/data \
  --network="host" \
  --entrypoint arche-import-binary \
  acdhch/arche-ingest \
  /data ${TOPCOLID}/ ${ARCHE} ${ARCHE_USER} ${ARCHE_PASSWORD} --concurrency 10 --skip not_exist binary_exist
