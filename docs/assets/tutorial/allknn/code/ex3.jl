# This file was generated, do not modify it. # hide
const dim = 16
k = 15
db = MatrixDatabase(randn(Float32, dim, 10^5))
dist = SqL2Distance()
G = SearchGraph(; dist, db)
opt = OptimizeParameters(kind=MinRecall(0.9))
itime = @elapsed (index!(G); optimize!(G, opt))
nothing # hide