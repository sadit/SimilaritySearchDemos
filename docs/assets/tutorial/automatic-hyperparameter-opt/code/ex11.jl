# This file was generated, do not modify it. # hide
optimize!(G1, callbacks1.hyperparameters)
optimize!(G3, callbacks2.hyperparameters)
optimize!(G3, callbacks3.hyperparameters)

@time I1, D1 = searchbatch(G1, queries, k)
@time I2, D2 = searchbatch(G2, queries, k)
@time I3, D3 = searchbatch(G3, queries, k)
nothing # hide