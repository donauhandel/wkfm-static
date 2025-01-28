#!/bin/bash

DATA_DIR=datasets
RDF_FILE=wmp1.nt
REPORT=${DATA_DIR}/validation_report.txt


SHACL=${DATA_DIR}/myshapes.ttl
rm ${SHACL}
echo "downloading latest SHACL shapes"
curl -o ${SHACL} https://pfp-schema.acdh-ch-dev.oeaw.ac.at/shacl/shacl.ttl

echo "Validating ${RDF_FILE} against SHACL shapes"
docker run --rm -v ${PWD}/${DATA_DIR}:/data ghcr.io/ashleycaselli/shacl:latest validate -datafile /data/${RDF_FILE} -shapesfile /data/myshapes.ttl > ${REPORT}

echo "Validation report written to ${REPORT}"
VIOLATIONS=$(grep -o "sh:Violation" ${REPORT} | wc -l)

if [ ${VIOLATIONS} -eq 0 ]; then
    echo "Whohooo!!! No Violations. Great Job!!!!"
else
    echo "Upsi dupsi, there are ${VIOLATIONS} violations. hush hush, go and fix them!"
fi
