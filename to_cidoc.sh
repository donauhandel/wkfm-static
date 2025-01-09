#!/bin/bash
echo "##############"
export NO_LIMIT=1
start_time=$(date +%s)

python cidoc/orgs2cidoc.py
python cidoc/places2cidoc.py
python cidoc/persons2cidoc.py

end_time=$(date +%s)
execution_time=$((end_time - start_time))

# Convert execution time to human-readable format
human_readable_time=$(date -u -d @${execution_time} +"%T")

echo "Execution time: $human_readable_time (HH:MM:SS)"

# Print the file size of datasets/wmp1.ttl
file_size=$(du -h "datasets/wmp1.ttl" | cut -f1)
echo "File size of datasets/wmp1.ttl: $file_size"
echo "######################"