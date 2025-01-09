from acdh_tei_pyutils.tei import TeiReader
from collections import Counter

doc = TeiReader("./data/indices/listperson.xml")

rel_types = list()
distinct_values = set()

for x in doc.any_xpath(".//tei:relation/@name"):
    rel_types.append(x)
    distinct_values.add(x)


rel_type_counts = Counter(rel_types)
print(dict(rel_type_counts))
print(distinct_values)
