import os
from rdflib import Graph, URIRef, RDF
from tqdm import tqdm
from slugify import slugify
from acdh_cidoc_pyutils import (
    make_e42_identifiers,
    make_appellations,
    make_birth_death_entities,
    make_affiliations,
    make_entity_label,
    make_occupations,
    tei_relation_to_SRPC3_in_social_relation,
)
from acdh_xml_pyutils.xml import NSMAP
from acdh_cidoc_pyutils.namespaces import CIDOC
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import get_xmlid, check_for_hash

from config import OUT_FILE, SARI, PU, domain

print("serializing PERSONS")

g = Graph()
g.bind("sari", SARI)
g.bind("crm", CIDOC)
g.parse(OUT_FILE)


if os.environ.get("NO_LIMIT"):
    LIMIT = False
    print("no limit")
else:
    LIMIT = 1000

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

    # birth/death places
    for y in x.xpath(
        ".//tei:residence[@type='Geburtsort']/tei:placeName", namespaces=NSMAP
    ):
        place_id = check_for_hash(y.attrib["key"])
        place_uri = URIRef(f"{domain}{place_id}")
        g.add((URIRef(f"{subj}/birth"), CIDOC["P7_took_place_at"], place_uri))

    for y in x.xpath(
        ".//tei:residence[@type='Sterbeort']/tei:placeName", namespaces=NSMAP
    ):
        place_id = check_for_hash(y.attrib["key"])
        place_uri = URIRef(f"{domain}{place_id}")
        g.add((URIRef(f"{subj}/death"), CIDOC["P7_took_place_at"], place_uri))

    # residences

    for y in x.xpath(".//tei:residence/tei:placeName[@key]", namespaces=NSMAP):
        place_id = check_for_hash(y.attrib["key"])
        place_uri = URIRef(f"{domain}{place_id}")
        g.add((subj, CIDOC["P74_has_current_or_former_residence"], place_uri))


lookup_dict = {
    "kind-von": "Is-child-of",
    "mutter-von": "Is-parent-of",
    "cousin-von": "Is-cousin-of",
    "schwiegersohn-von": "Is-child-in-law-of",
    "stiefsohn-von": "Is-stepchild-of",
    "schwiegervater-von": "Is-parent-in-law-of",
    "neffe-von": "Is-nephew-niece-of",
    "schwager-von": "Is-related-by-marriage-to",
    "bruder-von": "Is-sibling-of",
    "enkel-von": "Is-grandchild-of",
    "vater-von": "Is-parent-of",
    "onkel-von": "Is-uncle-aunt-of",
    "schwagerin-von": "Is-related-by-marriage-to",
    "schwester-von": "Is-sibling-of",
    "schwiegermutter-von": "Is-parent-in-law-of",
    "grossmutter-von": "Is-grandparent-of",
    "grossvater-von": "Is-grandparent-of",
    "stiefvater-von": "Is-stepparent-of",
    "schwiegertochter-von": "Is-child-in-law-of",
}

for x in doc.any_xpath(".//tei:relation"):
    g += tei_relation_to_SRPC3_in_social_relation(x, domain=domain, lookup_dict=lookup_dict)


print(f"saving {entity_type}-graph as {OUT_FILE}")
g.serialize(OUT_FILE)
