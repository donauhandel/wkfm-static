import glob
import os
import shutil

from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import normalize_string
from rdflib import RDF
from rdflib import XSD
from rdflib import Graph
from rdflib import Literal
from rdflib import Namespace
from rdflib import URIRef
from tqdm import tqdm


g = Graph().parse("arche/arche_constants.ttl")
ACDH = Namespace("https://vocabs.acdh.oeaw.ac.at/schema#")
G_REPO_OBJECTS = Graph().parse("arche/repo_objects_constants.ttl")
ID = Namespace("https://id.acdh.oeaw.ac.at/wmp1")
TO_INGEST = "to_ingest"
OUTFILE = os.path.join(TO_INGEST, "arche.ttl")

shutil.rmtree(TO_INGEST, ignore_errors=True)
os.makedirs(TO_INGEST, exist_ok=True)
shutil.copy("html/images/wstla__mkp.jpg", "to_ingest/title-img.jpg")

print("processing data/indices")
files = glob.glob("data/indices/*.xml")
for x in tqdm(files, total=len(files)):
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
files = sorted(glob.glob("data/editions/*.xml"))
files = files
for i, x in enumerate(tqdm(files, total=len(files)), start=1):
    fname = os.path.split(x)[-1]
    shutil.copyfile(x, os.path.join(TO_INGEST, fname))
    doc = TeiReader(x)
    uri = URIRef(f"{ID}/{fname}")
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

g.parse("arche/other_things.ttl")

print("processing images")
files = sorted(glob.glob("data/editions/*.xml"))
for i, x in enumerate(tqdm(files, total=len(files)), start=1):
    doc = TeiReader(x)
    img_id = doc.any_xpath(".//tei:graphic/@url")[0]
    doc_id = img_id.replace(".jpg", ".xml").replace("/wkfm/", "/wmp1/")
    uri = URIRef(img_id)
    page_nr = img_id.split("-")[-1]

    g.add((uri, RDF.type, ACDH["Resource"]))
    g.add((uri, ACDH["isSourceOf"], URIRef(doc_id)))
    title = (
        f"WSTLA, Bestand 2.3.2 – Merkantil- und Wechselgericht B6.1, Bild Nr. {page_nr}"
    )
    g.add((uri, ACDH["hasTitle"], Literal(title, lang="de")))
    g.add((uri, ACDH["isPartOf"], URIRef(f"{ID}/facs")))
    g.add(
        (
            uri,
            ACDH["hasCategory"],
            URIRef("https://vocabs.acdh.oeaw.ac.at/archecategory/image"),
        )
    )
    g.add(
        (
            uri,
            ACDH["hasLicense"],
            URIRef("https://vocabs.acdh.oeaw.ac.at/archelicenses/cc-by-nd-4-0"),
        )
    )
    g.add((uri, ACDH["hasLicensor"], URIRef("https://d-nb.info/gnd/2060831-7")))
    g.add((uri, ACDH["hasOwner"], URIRef("https://d-nb.info/gnd/2060831-7")))
    g.add((uri, ACDH["hasRightsHolder"], URIRef("https://d-nb.info/gnd/2060831-7")))
    g.add((uri, ACDH["hasDepositor"], URIRef("https://d-nb.info/gnd/13140007X")))
    g.add((uri, ACDH["hasMetadataCreator"], URIRef("https://d-nb.info/gnd/1043833846")))
    try:
        next = doc.any_xpath("/tei:TEI")[0].attrib["next"]
        g.add(
            (
                uri,
                ACDH["hasNextItem"],
                URIRef(f"{next.replace('.xml', '.jpg').replace("/wkfm/", "/wmp1/")}"),
            )
        )
    except KeyError:
        pass

print(f"saving graph into {OUTFILE}")
g.serialize(OUTFILE)
