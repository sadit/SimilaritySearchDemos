# This file was generated, do not modify it. # hide
const dim = 16
k = 15
verbose = false
db = MatrixDatabase(randn(Float32, dim, 10^5))
dist = SqL2Distance()
G = SearchGraph(; dist, db, verbose)
itime = @elapsed (index!(G); optimize!(G, MinRecall(0.9)))
nothing # hide