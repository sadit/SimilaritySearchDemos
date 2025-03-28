# This file was generated, do not modify it.

using Markdown # hide

ENV["GKSwstype"] = "nul" # hide

using SimilaritySearch

const dim = 16
k = 15
verbose = false
db = MatrixDatabase(randn(Float32, dim, 10^5))
dist = SqL2Distance()
G = SearchGraph(; dist, db, verbose)
itime = @elapsed (index!(G); optimize!(G, MinRecall(0.9)))
nothing # hide

allknntime = @elapsed knns, dists = allknn(G, k)
nothing # hide

searchtime = @elapsed sknns, sdists = searchbatch(G, db, k)
nothing # hide

etime = @elapsed eknns, edists = allknn(ExhaustiveSearch(; db, dist), k)
nothing # hide

itime, allknntime, searchtime

itime + allknntime

itime + searchtime

etime

macrorecall(eknns, knns)

macrorecall(eknns, sknns)

using Pkg # hide
Pkg.status(["SimilaritySearch"]) # hide

