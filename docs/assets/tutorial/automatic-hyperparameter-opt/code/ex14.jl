# This file was generated, do not modify it. # hide
optimize!(G1, MinRecall(0.95), queries=equeries)
optimize!(G2, MinRecall(0.95), queries=equeries)
optimize!(G3, MinRecall(0.95), queries=equeries)

@time I1, D1 = searchbatch(G1, queries, k)
@time I2, D2 = searchbatch(G2, queries, k)
@time I3, D3 = searchbatch(G3, queries, k)
nothing # hide

@show macrorecall(goldI, I1)
@show macrorecall(goldI, I2)
@show macrorecall(goldI, I3)