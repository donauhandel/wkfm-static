import glob
import os

from acdh_cfts_pyutils import CFTS_COLLECTION
from acdh_cfts_pyutils import TYPESENSE_CLIENT as client
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import extract_fulltext
from tqdm import tqdm
from typesense.api_call import ObjectNotFound

files = glob.glob("./data/editions/*.xml")
tag_blacklist = ["{http://www.tei-c.org/ns/1.0}abbr"]


try:
    client.collections["wkfm"].delete()
except ObjectNotFound:
    pass

current_schema = {
    "name": "wkfm",
    "fields": [
        {"name": "id", "type": "string"},
        {"name": "rec_id", "type": "string"},
        {"name": "title", "type": "string"},
        {"name": "full_text", "type": "string"},
        {"name": "persons", "type": "string[]", "facet": True, "optional": True},
    ],
}

client.collections.create(current_schema)

records = []
cfts_records = []
for x in tqdm(files, total=len(files)):
    cfts_record = {
        "project": "wkfm",
    }
    record = {}

    doc = TeiReader(x)
    try:
        body = doc.any_xpath(".//tei:body")[0]
    except IndexError:
        continue
    record["id"] = os.path.split(x)[-1].replace(".xml", "")
    record["keywords"] = doc.any_xpath(
        './/tei:abstract/tei:ab[@type="abstract-terms"]/tei:term/text()'
    )
    cfts_record["id"] = record["id"]
    cfts_record["resolver"] = f"https://wkfm.acdh-dev.oeaw.ac.at/{record['id']}.html"
    record["rec_id"] = os.path.split(x)[-1]
    cfts_record["rec_id"] = record["rec_id"]
    record["title"] = " ".join(
        " ".join(
            doc.any_xpath('.//tei:titleStmt/tei:title[@type="main"]/text()')
        ).split()
    )
    cfts_record["title"] = record["title"]
    record["persons"] = [
        " ".join(" ".join(x.xpath(".//text()")).split())
        for x in doc.any_xpath(".//tei:back//tei:persName[1]")
    ]
    record["full_text"] = extract_fulltext(body, tag_blacklist=tag_blacklist)
    cfts_record["full_text"] = record["full_text"]
    records.append(record)
    cfts_records.append(cfts_record)

make_index = client.collections["wkfm"].documents.import_(records)
print(make_index)
print("done with indexing wkfm")

make_index = CFTS_COLLECTION.documents.import_(cfts_records, {"action": "upsert"})
print(make_index)
print("done with cfts-index wkfm")
