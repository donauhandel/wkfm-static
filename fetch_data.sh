# bin/bash

echo "fetching transkriptions from wkfm-working-data"
rm -rf data/editions && mkdir data/editions
rm -rf data/indices && mkdir data/indices
curl -LO https://github.com/donauhandel/wkfm-working-data/archive/refs/heads/main.zip
unzip main
mv ./wkfm-working-data-main/data/editions/ ./data
rm main.zip
rm -rf ./wkfm-working-data-main

curl -LO https://github.com/donauhandel/krems-data/archive/refs/heads/main.zip
unzip main
mv ./krems-data-main/data/indices/ ./data
rm main.zip
rm -rf ./krems-data-main

echo "adding xml-ids"
add-attributes -g "data/editions/*.xml" -b "https://id.acdh.oeaw.ac.at/wkfm"
python fix_entity_types.py
denormalize-indices -f "./data/editions/*.xml" -i "./data/indices/*.xml" -m ".//*[@ref]/@ref" -x ".//tei:titleStmt/tei:title[1]/text()"

python oai-pmh/make_files.py

# echo "delete not mentioned entities"
# python delete_not_mentioned_entities.py