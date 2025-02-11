import glob

from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import check_for_hash


files = sorted(glob.glob("./data/editions/*xml"))


refs = set()
for x in files:
    doc = TeiReader(x)
    for item in doc.any_xpath(".//tei:rs[@ref]"):
        refs.add(check_for_hash(item.attrib["ref"]))

files = sorted(glob.glob("./data/indices/*xml"))

ids = set()

for x in files:
    doc = TeiReader(x)
    for item in doc.any_xpath(".//tei:body//@xml:id"):
        ids.add(item)

no_match = set()
for x in refs:
    if x not in ids:
        no_match.add(x)

print(f"found following {len(no_match)} IDs without index-entries")
print(no_match)
