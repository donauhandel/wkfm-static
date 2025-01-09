import os
from slugify import slugify
from tqdm import tqdm
from acdh_cidoc_pyutils import (
    make_e42_identifiers,
    make_appellations,
    make_birth_death_entities,
    make_affiliations,
    make_entity_label,
    make_occupations,
)
from acdh_xml_pyutils.xml import NSMAP
from acdh_cidoc_pyutils.namespaces import CIDOC
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import get_xmlid, check_for_hash
from rdflib import Graph, Namespace, URIRef, Literal
from rdflib.namespace import RDF, RDFS

SARI = Namespace("http://w3id.org/sari#")

g = Graph()
g.bind("sari", SARI)
g.bind("crm", CIDOC)
domain = "https://wmp1.acdh.oeaw.ac.at/"
PU = Namespace(domain)

if os.environ.get("NO_LIMIT"):
    LIMIT = False
    print("no limit")
else:
    LIMIT = 1000

rdf_dir = "./datasets"
os.makedirs(rdf_dir, exist_ok=True)

index_file = os.path.join("data", "indices", "listperson.xml")
entity_type = "person"


doc = TeiReader(index_file)
items = doc.any_xpath(f".//tei:{entity_type}[@xml:id]")
if LIMIT:
    items = items[:LIMIT]

for x in tqdm(items, total=len(items)):
    xml_id = get_xmlid(x)
    item_label = make_entity_label(x.xpath(".//tei:persName[1]", namespaces=NSMAP)[0])[
        0
    ]
    item_id = f"{PU}{xml_id}"
    subj = URIRef(item_id)
    g.add((subj, RDF.type, CIDOC["E21_Person"]))
    affilliations = make_affiliations(
        subj,
        x,
        f"{PU}org__",
        item_label,
        org_id_xpath="./tei:orgName/@key",
        org_label_xpath="./tei:orgName/text()",
    )
    g += affilliations

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

    # birth
    event_graph, birth_uri, birth_timestamp = make_birth_death_entities(
        subj,
        x,
        f"{PU}place__",
        event_type="birth",
        default_prefix="Geburt von",
        date_node_xpath="/tei:date[1]",
    )
    g += event_graph

    # death
    event_graph, birth_uri, birth_timestamp = make_birth_death_entities(
        subj,
        x,
        f"{PU}place__",
        event_type="death",
        default_prefix="Tod von",
        date_node_xpath="/tei:date[1]",
    )
    g += event_graph

    # occupations
    g += make_occupations(subj, x)[0]

    for y in x.xpath(".//tei:residence[@type='Geburtsort']/tei:placeName", namespaces=NSMAP):
        place_id = check_for_hash(y.attrib["key"])
        place_uri = URIRef(f"{domain}{place_id}")
        g.add((URIRef(f"{subj}/birth"), CIDOC["P7_took_place_at"], place_uri))

    for y in x.xpath(".//tei:residence[@type='Sterbeort']/tei:placeName", namespaces=NSMAP):
        place_id = check_for_hash(y.attrib["key"])
        place_uri = URIRef(f"{domain}{place_id}")
        g.add((URIRef(f"{subj}/death"), CIDOC["P7_took_place_at"], place_uri))


for x in doc.any_xpath(".//tei:relation"):
    rel_type = slugify(x.attrib["name"])
    source = check_for_hash(x.attrib["active"])
    target = check_for_hash(x.attrib["passiv"])
    label = x.attrib["name"]
    relation_class = URIRef(f"{domain}srpc3/{source}/{rel_type}/{target}")
    relation_type = URIRef(f"{domain}srpc3/{rel_type}")
    g.add(
        (relation_type, RDF.type, CIDOC["E55_Type"])
    )
    source_uri = URIRef(f"{domain}{source}")
    target_uri = URIRef(f"{domain}{target}")
    g.add(
        (relation_class, RDF.type, SARI["SRPC3_in_social_relation"])
    )
    g.add(
        (relation_class, RDFS.label, Literal(label, lang="de"))
    )
    g.add(
        (relation_class, SARI["SRP3_relation_type"], relation_type)
    )
    g.add(
        (relation_class, CIDOC["P01_has_domain"], source_uri)
    )
    g.add(
        (relation_class, CIDOC["P02_has_range"], target_uri)
    )
    if rel_type in ["vater-von", "mutter-von"]:
        g.add(
            (target_uri, CIDOC["P152_has_parent"], source_uri)
        )
    if rel_type in ["kind-von"]:
        g.add(
            (source_uri, CIDOC["P152_has_parent"], target_uri)
        )

save_path = os.path.join(rdf_dir, f"wmp1_{entity_type}.ttl")
print(f"saving graph as {save_path}")
g.serialize(save_path)
