import os
from tqdm import tqdm
from acdh_cidoc_pyutils import (
    make_e42_identifiers,
    make_appellations,
)
from acdh_cidoc_pyutils.namespaces import CIDOC
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import get_xmlid
from acdh_xml_pyutils.xml import NSMAP
from rdflib import Graph, URIRef
from rdflib.namespace import RDF

from config import OUT_FILE, SARI, PU

print("serializing ORGS")
rdf_dir = "./datasets"
os.makedirs(rdf_dir, exist_ok=True)


g = Graph()
g.bind("sari", SARI)
g.bind("crm", CIDOC)


if os.environ.get("NO_LIMIT"):
    LIMIT = False
    print("no limit")
else:
    LIMIT = 100000

index_file = os.path.join("data", "indices", "listorg.xml")
entity_type = "org"


doc = TeiReader(index_file)
items = doc.any_xpath(f".//tei:{entity_type}[@xml:id]")
if LIMIT:
    items = items[:LIMIT]

for x in tqdm(items, total=len(items)):
    xml_id = get_xmlid(x)
    item_id = f"{PU}{xml_id}"
    subj = URIRef(item_id)
    g.add((subj, RDF.type, CIDOC["E74_Group"]))

    # ids
    g += make_e42_identifiers(
        subj,
        x,
        type_domain="http://hansi/4/ever",
        default_lang="de",
    )

    # names
    g += make_appellations(
        subj, x, type_domain="http://hansi/4/ever", default_lang="de"
    )

    # located
    for y in x.xpath(
        ".//tei:location[@type='located_in_place']/tei:placeName/@key", namespaces=NSMAP
    ):
        g.add((subj, CIDOC["P74_has_current_or_former_residence"], URIRef(f"{PU}{y}")))


print(f"saving {entity_type}-graph as {OUT_FILE}")
g.serialize(OUT_FILE)
