# This file was generated, do not modify it.

using Markdown # hide

ENV["GKSwstype"] = "nul" # hide

using SimilaritySearch

const dim = 16

X = rand(Float32, dim, 10^5)
Q = rand(Float32, dim, 10^3)
k = 10
nothing # hide

dist = SqL2Distance()
db = MatrixDatabase(X)
queries = MatrixDatabase(Q)
nothing # hide

verbose = false
goldI, goldD = searchbatch(ExhaustiveSearch(; db, dist), queries, k)  # `ExhaustiveSearch` solves with brute force
nothing # hide

G1 = SearchGraph(; dist, db=MatrixDatabase(X), verbose)
callbacks1 = SearchGraphCallbacks(ParetoRecall())  # ParetoRecall is the default, and it will be used unless you change it
@elapsed index!(G1; callbacks=callbacks1)

G2 = SearchGraph(; dist, db=MatrixDatabase(X), verbose)
callbacks2 = SearchGraphCallbacks(ParetoRadius())  # it uses distances instead of recall, it will be faster but lower quality
@elapsed index!(G2; callbacks=callbacks2)

G3 = SearchGraph(; dist, db=MatrixDatabase(X), verbose)
callbacks3 = SearchGraphCallbacks(MinRecall(0.95))
@elapsed index!(G3; callbacks=callbacks3)

@time I1, D1 = searchbatch(G1, queries, k)
@time I2, D2 = searchbatch(G2, queries, k)
@time I3, D3 = searchbatch(G3, queries, k)
nothing #hide

@show macrorecall(goldI, I1)
@show macrorecall(goldI, I2)
@show macrorecall(goldI, I3)
nothing #hide

optimize!(G1, ParetoRecall())
optimize!(G3, ParetoRadius())
optimize!(G3, MinRecall(0.95))

@time I1, D1 = searchbatch(G1, queries, k)
@time I2, D2 = searchbatch(G2, queries, k)
@time I3, D3 = searchbatch(G3, queries, k)
nothing #hide

@show macrorecall(goldI, I1)
@show macrorecall(goldI, I2)
@show macrorecall(goldI, I3)

equeries = MatrixDatabase(rand(dim, 64))
optimize!(G1, ParetoRecall(), queries=equeries)
optimize!(G2, ParetoRadius(), queries=equeries)
optimize!(G3, MinRecall(0.95), queries=equeries)

@time I1, D1 = searchbatch(G1, queries, k)
@time I2, D2 = searchbatch(G2, queries, k)
@time I3, D3 = searchbatch(G3, queries, k)
nothing #hide

@show macrorecall(goldI, I1)
@show macrorecall(goldI, I2)
@show macrorecall(goldI, I3)

optimize!(G1, MinRecall(0.95), queries=equeries)
optimize!(G2, MinRecall(0.95), queries=equeries)
optimize!(G3, MinRecall(0.95), queries=equeries)

@time I1, D1 = searchbatch(G1, queries, k)
@time I2, D2 = searchbatch(G2, queries, k)
@time I3, D3 = searchbatch(G3, queries, k)
nothing #hide

@show macrorecall(goldI, I1)
@show macrorecall(goldI, I2)
@show macrorecall(goldI, I3)

using Pkg # hide
Pkg.status(["SimilaritySearch"]) # hide

