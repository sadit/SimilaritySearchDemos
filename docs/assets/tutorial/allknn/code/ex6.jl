# This file was generated, do not modify it. # hide
etime = @elapsed eknns, edists = allknn(ExhaustiveSearch(; db, dist), k; parallel=true)

display(md"""

Solution times:

- indexing time: $itime sec.
- allknn ($allknntime sec.) vs searchbatch ($searchtime sec.)
- allknn full cost (indexing + allknn): $(itime + allknntime)
- allknn full cost (indexing + searchbatch): $(itime + searchtime)
- exhaustive allknn: $etime

# Quality
- macro recall of `allknn`: $(macrorecall(eknns, knns))
- macro recall of `searchbatch`: $(macrorecall(eknns, sknns))

""")