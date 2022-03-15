# This file was generated, do not modify it. # hide
const dim = 8

db = MatrixDatabase(randn(Float32, dim, 10^4))
dist = SqL2Distance()
G = SearchGraph(; dist, db)
index!(G)
nothing # hide