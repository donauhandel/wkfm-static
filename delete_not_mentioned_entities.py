from acdh_tei_pyutils.tei import TeiReader

listperson = "./data/indices/listperson.xml"

doc = TeiReader(listperson)

for bad in doc.any_xpath(".//tei:person[not(./tei:noteGrp)]"):
    bad.getparent().remove(bad)

doc.tree_to_file(listperson)


listorg = "./data/indices/listorg.xml"

doc = TeiReader(listorg)

for bad in doc.any_xpath(".//tei:org[not(./tei:noteGrp)]"):
    bad.getparent().remove(bad)

doc.tree_to_file(listorg)
