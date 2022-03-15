# This file was generated, do not modify it. # hide
Q = MatrixDatabase(randn(2, 100))
k = 30
I, D = searchbatch(G, Q, k)
@show typeof(I) => size(I)
@show typeof(D) => size(D)