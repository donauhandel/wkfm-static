import glob
from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm

files = sorted(glob.glob("./data/editions/*.xml"))
mentioned_ids = set()
for x in tqdm(files):
    doc = TeiReader(x)
    for y in doc.any_xpath(".//tei:rs[@type='person']/@ref"):
        mentioned_ids.add(y[1:])

ids = set()
doc = TeiReader("./data/indices/listperson.xml")
for y in doc.any_xpath(".//tei:person[@xml:id]/@xml:id"):
    ids.add(y)

no_match = set()
match = set()
for x in mentioned_ids:
    if x in ids:
        match.add(x)
    else:
        no_match.add(x)
print(len(match), len(no_match))