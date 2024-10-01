import glob
import os
import shutil
from datetime import datetime
from AcdhArcheAssets.uri_norm_rules import get_normalized_uri
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import normalize_string, make_entity_label, nsmap, get_xmlid
from rdflib import Graph, Namespace, URIRef, RDF, Literal, XSD
from tqdm import tqdm

g = Graph().parse("arche/arche_constants.ttl")
ACDH = Namespace("https://vocabs.acdh.oeaw.ac.at/schema#")
G_REPO_OBJECTS = Graph().parse("arche/repo_objects_constants.ttl")
ID = Namespace("https://id.acdh.oeaw.ac.at/wmp1")
TO_INGEST = "to_ingest"

shutil.rmtree(TO_INGEST, ignore_errors=True)
os.makedirs(TO_INGEST, exist_ok=True)
shutil.copy("html/images/wstla__mkp.jpg", "to_ingest/title-img.jpg")

print("processing data/indices")
files = glob.glob("data/indices/*.xml")
for x in tqdm(files, total=len(files)):
    if "siglen" in x:
        continue
    else:
        fname = os.path.split(x)[-1]
        shutil.copyfile(x, os.path.join(TO_INGEST, fname))
        doc = TeiReader(x)
        uri = URIRef(f"{ID}/{fname}")
        g.add((uri, RDF.type, ACDH["Resource"]))
        g.add((uri, ACDH["isPartOf"], URIRef(f"{ID}/indices")))
        g.add((uri, ACDH["hasIdentifier"], URIRef(f"{ID}/{fname}")))
        g.add(
            (
                uri,
                ACDH["hasCategory"],
                URIRef("https://vocabs.acdh.oeaw.ac.at/archecategory/text/tei"),
            )
        )
        try:
            has_title = normalize_string(
                doc.any_xpath(".//tei:titleStmt[1]/tei:title[@type='main']/text()")[0]
            )
        except IndexError:
            has_title = normalize_string(
                doc.any_xpath(".//tei:titleStmt[1]/tei:title[1]/text()")[0]
            )
        g.add((uri, ACDH["hasTitle"], Literal(has_title, lang="de")))


print("processing data/editions")
files = glob.glob("data/editions/*.xml")
files = files[:20]
for x in tqdm(files, total=len(files)):
    fname = os.path.split(x)[-1]
    shutil.copyfile(x, os.path.join(TO_INGEST, fname))
    doc = TeiReader(x)
    uri = URIRef(f"{ID}/{fname}")
    try:
        pid = doc.any_xpath(".//tei:idno[@type='handle']/text()")[0]
    except IndexError:
        pid = "XXXX"
    if pid.startswith("http"):
        g.add((uri, ACDH["hasPid"], Literal(pid)))
    g.add((uri, RDF.type, ACDH["Resource"]))
    url = f"https://wmp1.acdh.oeaw.ac.at/{fname.replace('.xml', '.html')}"
    g.add((uri, ACDH["hasUrl"], Literal(url, datatype=XSD.anyURI)))
    g.add((uri, ACDH["isPartOf"], URIRef(f"{ID}/editions")))
    g.add(
        (
            uri,
            ACDH["hasCategory"],
            URIRef("https://vocabs.acdh.oeaw.ac.at/archecategory/text/tei"),
        )
    )
    try:
        has_title = normalize_string(
            doc.any_xpath(".//tei:titleStmt[1]/tei:title[@type='main']/text()")[0]
        )
    except IndexError:
        has_title = normalize_string(
            doc.any_xpath(".//tei:titleStmt[1]/tei:title[1]/text()")[0]
        )
    g.add((uri, ACDH["hasTitle"], Literal(has_title, lang="de")))

print("adding repo objects constants now")
COLS = [ACDH["TopCollection"], ACDH["Collection"], ACDH["Resource"]]
COL_URIS = set()
for x in COLS:
    for s in g.subjects(None, x):
        COL_URIS.add(s)
for x in COL_URIS:
    for p, o in G_REPO_OBJECTS.predicate_objects():
        g.add((x, p, o))

g.parse("arche/title_image.ttl")
g.serialize(os.path.join(TO_INGEST, "arche.ttl"))
