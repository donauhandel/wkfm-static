import glob

from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm

print("fixing entity types for mentioned tei:org")
files = sorted(glob.glob("./data/editions/*.xml"))
doc = TeiReader("./data/indices/listorg.xml")
orgs = set()
for x in doc.any_xpath(".//tei:org/@xml:id"):
    orgs.add(f"#{x}")
for x in tqdm(files, total=len(files)):
    doc = TeiReader(x)
    for y in doc.any_xpath(".//tei:rs[@ref]"):
        ref = y.attrib["ref"]
        if ref in orgs:
            y.attrib["type"] = "org"
    doc.tree_to_file(x)
