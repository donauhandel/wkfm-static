import os
from rdflib import Namespace

OUT_FILE = os.path.join("datasets", "wmp1.ttl")
SARI = Namespace("http://w3id.org/sari#")
domain = "https://wmp1.acdh.oeaw.ac.at/"
PU = Namespace(domain)
