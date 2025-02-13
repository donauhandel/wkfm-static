import glob
import os
import pandas as pd

from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import check_for_hash, normalize_string


files = sorted(glob.glob("./data/indices/*xml"))

ids = set()

for x in files:
    doc = TeiReader(x)
    for item in doc.any_xpath(".//tei:body//@xml:id"):
        ids.add(item)

files = sorted(glob.glob("./data/editions/*xml"))


refs = set()
data = []
for x in files:
    f_name = os.path.split(x)[-1].replace(".xml", ".html")
    url = f"https://wmp1.acdh.oeaw.ac.at/{f_name}"
    doc = TeiReader(x)
    for item in doc.any_xpath(".//tei:rs[@ref]"):
        no_hash = check_for_hash(item.attrib["ref"])
        if no_hash not in ids:
            try:
                text = normalize_string(item.text)
            except AttributeError:
                text = "no text in rs"
            data.append([
                no_hash, text, url
            ])
            refs.add(no_hash)

df = pd.DataFrame(data, columns=["id", "mention", "url"])
df.to_csv("no_match.csv", index=False)
