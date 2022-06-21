using Markdown # hide

# ## All-KNN
# By Eric S. Téllez
#

ENV["GKSwstype"] = "nul" # hide

using SimilaritySearch
# Computing the $k$ nearest neighbors of a dataset (all vs all) is a useful task to take knowledge 
# of a given dataset. This is a core task for some clustering algorithms and non-linear dimensional reduction
# algorithms.
# 
# Given a metric database $(X, dist)$  and a relatively small $k$ value, the goal is
# to compute $\{ knn(x) \mid x \in X \}$ taking into account that each $x_i \in X$, and therefore, $x_i$ should be
# removed from the $i$-th $knn$ result set.
# 
# Solving `allknn` fast and accuratelly is the goal of this example.

const dim = 16
k = 15
verbose = false
db = MatrixDatabase(randn(Float32, dim, 10^5))
dist = SqL2Distance()
G = SearchGraph(; dist, db, verbose)
itime = @elapsed (index!(G); optimize!(G, MinRecall(0.9)))
nothing # hide
# Now we can solve all $k$nn

allknntime = @elapsed knns, dists = allknn(G, k)
nothing # hide
# ## Differences between `allknn(G, k)` and `searchbatch(G, X, k)`
#
# We can solve similarly with `searchbatch` but self-references should be removed later, and more important,
# `allknn` use special pivoting/boosting strategies that yields to faster searches.

searchtime = @elapsed sknns, sdists = searchbatch(G, db, k)
nothing # hide

# ## About the cost of construction + `allknn` instead of a brute force computation.
# `allknn` for `ExhaustiveSearch` doesn't perform any optimization but removes self references.
etime = @elapsed eknns, edists = allknn(ExhaustiveSearch(; db, dist), k)
nothing # hide

# ## Comparing solution times
#
# indexing, allknn, and searchbatch times
itime, allknntime, searchtime

# full cost `allknn`
itime + allknntime
# full cost `searchbatch`
itime + searchtime
# exhaustive `allknn`
etime

# ## Quality
# macro recall of `allknn`
macrorecall(eknns, knns)
# macro recall of `searchbatch`
macrorecall(eknns, sknns)

# ## Final notes:
# Exhaustive search will fetch the exact solution but it has a higher cost and this could be more
# notorious as dataset's size increases.
#
# Also note that even `SimilaritySearch` has multithreading operations, it runs in a single thread due to the html generation pipeline.
#

#- Using BeutifulMakie style
# ## Dependencies
using Pkg # hide
Pkg.status(["SimilaritySearch"]) # hide
