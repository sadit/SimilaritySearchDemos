# This file was generated, do not modify it. # hide
minrecall = callbacks3.hyperparameters
optimize!(G1, minrecall, queries=equeries)
optimize!(G2, minrecall, queries=equeries)
optimize!(G3, minrecall, queries=equeries)

@time I1, D1 = searchbatch(G1, queries, k)
@time I2, D2 = searchbatch(G2, queries, k)
@time I3, D3 = searchbatch(G3, queries, k)
nothing # hide

@show macrorecall(goldI, I1)
@show macrorecall(goldI, I2)
@show macrorecall(goldI, I3)