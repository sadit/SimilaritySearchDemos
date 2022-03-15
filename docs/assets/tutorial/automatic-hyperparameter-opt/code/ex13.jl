# This file was generated, do not modify it. # hide
equeries = MatrixDatabase(rand(dim, 64))
optimize!(G1, callbacks1.hyperparameters, queries=equeries)
optimize!(G2, callbacks2.hyperparameters, queries=equeries)
optimize!(G3, callbacks3.hyperparameters, queries=equeries)

@time I1, D1 = searchbatch(G1, queries, k)
@time I2, D2 = searchbatch(G2, queries, k)
@time I3, D3 = searchbatch(G3, queries, k)
nothing # hide

@show macrorecall(goldI, I1)
@show macrorecall(goldI, I2)
@show macrorecall(goldI, I3)