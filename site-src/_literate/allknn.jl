using Markdown # hide

# ## All-KNN
# By Eric S. Téllez
#

ENV["GKSwstype"] = "nul" # hide

using SimilaritySearch
# Computing the $k$ nearest neighbors of a dataset (all vs all) is a useful task to take knowledge of
# of a given dataset. This is a core task for some clustering algorithms and non-linear dimensional reduction
# algorithms.
# 
# Given a metric database $(X, dist)$  and a relatively small $k$ value, the goal is
# to compute $\{ knn(x) \mid x \in X \}$ taking into account that each $x_i \in X$, and therefore, it $x_i$ should be
# removed from the $i$-th $knn$ result set.
# 
# Solving `allknn` fast and accuratelly is the goal of this example.

const dim = 8
k = 15
db = MatrixDatabase(randn(Float32, dim, 10^5))
dist = SqL2Distance()
G = SearchGraph(; dist, db)
opt = OptimizeParameters(kind=MinRecall(0.9))
itime = @elapsed (index!(G); optimize!(G, opt))

# Now we can solve all $k$nn

allknntime = @elapsed knns, dists = allknn(G, k; parallel=true)
# ## Differences between `allknn(G, k)` and `searchbatch(G, X, k)`
#
# We can solve similarly with `searchbatch` but self-references should be removed later, and more important,
# `allknn` use special pivoting/boosting strategies that yields to faster searches.

searchtime = @elapsed sknns, sdists = searchbatch(G, db, k; parallel=true)

# ## About the cost of construction + `allknn` instead of a brute force computation.
# `allknn` for `ExhaustiveSearch` doesn't perform any optimization but removes self references.
etime = @elapsed eknns, edists = allknn(ExhaustiveSearch(; db, dist), k; parallel=true)

# ## Comparing solution times
#
#indexing time:

print("""indexingtime: $itime, allknn ($(allknntime) sec.) vs searchbatch ($(searchtime) sec.)""")
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
# Also note that even when we pass `parallel=true` it runs in a single thread due to the html generation pipeline.
#

#- Using BeutifulMakie style
# ## Dependencies
using Pkg # hide
Pkg.status(["SimilaritySearch"]) # hide