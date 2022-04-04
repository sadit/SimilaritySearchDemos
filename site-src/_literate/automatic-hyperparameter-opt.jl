using Markdown # hide

# ## Automatic hyperparameter optimization
# By Eric S. Téllez
#

ENV["GKSwstype"] = "nul" # hide

using SimilaritySearch

const dim = 16

# This example optimizes different kinds of optimizations that allow different tradeoffs

X = rand(Float32, dim, 10^5)
Q = rand(Float32, dim, 10^3)
k = 10
nothing # hide

# We will use the squared L2, which preserves the order of L2 but is faster to compute.
dist = SqL2Distance()
db = MatrixDatabase(X)
queries = MatrixDatabase(Q)
nothing # hide
# Computing ground truth

goldI, goldD = searchbatch(ExhaustiveSearch(; db, dist), queries, k)  # `ExhaustiveSearch` solves with brute force
nothing # hide
# ## Different hyperparameter optimization strategies
# the way of specifying the hyperparameter optimization strategy and objective is with
# a `SearchGraphCallbacks` object, as follows:
G1 = SearchGraph(; dist, db=MatrixDatabase(X))
callbacks1 = SearchGraphCallbacks(hyperparameters=OptimizeParameters(kind=ParetoRecall()))  # ParetoRecall is the default 
@elapsed index!(G1; callbacks=callbacks1)

# Using `ParetoRadius`: which should be faster since it doesn't needs a costly computation as the recall score
# but can be easily fool by distances distribution

G2 = SearchGraph(; dist, db=MatrixDatabase(X))
callbacks2 = SearchGraphCallbacks(hyperparameters=OptimizeParameters(kind=ParetoRadius()))  # it uses distances instead of recall, it will be faster but lower quality
@elapsed index!(G2; callbacks=callbacks2)

# Using `MinRecall`: It ensures a minimum quality in a small validation set
G3 = SearchGraph(; dist, db=MatrixDatabase(X))
callbacks3 = SearchGraphCallbacks(hyperparameters=OptimizeParameters(kind=MinRecall(0.95)))
@elapsed index!(G3; callbacks=callbacks3)

#
# `index!`, `append!`, and `push!` accept callbacks.
#
# ## Performances
# searching times
@time I1, D1 = searchbatch(G1, queries, k)
@time I2, D2 = searchbatch(G2, queries, k)
@time I3, D3 = searchbatch(G3, queries, k)
nothing #hide

# the recall (0-1, one is the best)
@show macrorecall(goldI, I1)
@show macrorecall(goldI, I2)
@show macrorecall(goldI, I3)
nothing #hide

#=
 here we can see smaller recalls than expected, but we also can appreciate the differences
 among them.

 ## Optimizing `SearchGraph` without inserting

 The hyperparameter optimization is performed in exponential stages while the `SearchGraph` is created,
 and therefore, the current hyperparameters could need an update. To optimize an already created `SearchGraph` we use `optimize` instead of `index`

=#
optimize!(G1, callbacks1.hyperparameters)
optimize!(G3, callbacks2.hyperparameters)
optimize!(G3, callbacks3.hyperparameters)

@time I1, D1 = searchbatch(G1, queries, k)
@time I2, D2 = searchbatch(G2, queries, k)
@time I3, D3 = searchbatch(G3, queries, k)
nothing #hide

# the recall ($0$ to  $1$, where one is the best)
@show macrorecall(goldI, I1)
@show macrorecall(goldI, I2)
@show macrorecall(goldI, I3)


#=
 The optimization is made using objects of the dataset as queries to compute the objective function.
 If it is possible to get external queries to optimize (not in the database and not in the query set,
 but also following the expected distrbiution), they can be provided as follows:
=#
equeries = MatrixDatabase(rand(dim, 64))
optimize!(G1, callbacks1.hyperparameters, queries=equeries)
optimize!(G2, callbacks2.hyperparameters, queries=equeries)
optimize!(G3, callbacks3.hyperparameters, queries=equeries)

@time I1, D1 = searchbatch(G1, queries, k)
@time I2, D2 = searchbatch(G2, queries, k)
@time I3, D3 = searchbatch(G3, queries, k)
nothing #hide

@show macrorecall(goldI, I1)
@show macrorecall(goldI, I2)
@show macrorecall(goldI, I3)

# Finally, we create our index with any hyperparameter optimization strategy, and optimize
# for quality, as follows:
minrecall = callbacks3.hyperparameters
optimize!(G1, minrecall, queries=equeries)
optimize!(G2, minrecall, queries=equeries)
optimize!(G3, minrecall, queries=equeries)

@time I1, D1 = searchbatch(G1, queries, k)
@time I2, D2 = searchbatch(G2, queries, k)
@time I3, D3 = searchbatch(G3, queries, k)
nothing #hide

@show macrorecall(goldI, I1)
@show macrorecall(goldI, I2)
@show macrorecall(goldI, I3)

#=
Please note that faster searches are expected for indexes created for higher qualities.

## `OptimizeParameters`
The structure is defined as follows

```
@with_kw mutable struct OptimizeParameters <: Callback
    kind::ErrorFunction = ParetoRecall()
    initialpopulation = 16
    params = SearchParams(maxpopulation=16, bsize=4, mutbsize=16, crossbsize=8, tol=-1.0, maxiters=16)
    ksearch::Int32 = 10
    numqueries::Int32 = 64
    space::BeamSearchSpace = BeamSearchSpace()
end
```

It allows to modify several parameters to adjusting parameters for a given objective,
these parameters can be tuned for faster constructions or more accurate ones.
=#


#- Using BeutifulMakie style
# ## Dependencies
using Pkg # hide
Pkg.status(["SimilaritySearch"]) # hide
