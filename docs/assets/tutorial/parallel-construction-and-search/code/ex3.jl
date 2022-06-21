# This file was generated, do not modify it. # hide
const dim = 16

db = MatrixDatabase(randn(Float32, dim, 10^5))
Q = MatrixDatabase(randn(Float32, dim, 30))
dist = SqL2Distance()
G = SearchGraph(; dist, db, verbose=true)