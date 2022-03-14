using Markdown # hide

# ## Solving single queries and `KnnResult`
# By Eric S. Téllez
#

ENV["GKSwstype"] = "nul" # hide

using SimilaritySearch
#
# This example shows how to perform single queries instead of solving a batch of them.
# This is particularly useful for some applications, and they are also how they are solved,
# and therefore, it could be used to avoid some memory allocations.
const dim = 8

db = MatrixDatabase(randn(Float32, dim, 10^4))
dist = SqL2Distance()
G = SearchGraph(; dist, db)
index!(G)
nothing # hide

# Suppose you want to compute some $k$ nearest neighbors, for this we use the structure
# `KnnResult` which is a priority queue of maximum size `k`.
res = KnnResult(3) # allocates memory for 10 nearest neighbors
for v in rand(db, 10)
    reuse!(res)  # reuses the res object
    @time search(G, v, res)
    @show minimum(res), maximum(res), argmin(res), argmax(res)
    @show res.id, res.dist
end

# ## `KnnResult`
# This structure is the container for the result and it is also used to specify the number
# of elements to retrieve. As mentioned before, it is a priority queue

reuse!(res)
push!(res, 1, 10)
push!(res, 2, 9)
push!(res, 3, 8)
push!(res, 4, 7)
push!(res, 6, 5)
@show res

# it also supports removals
@show popfirst!(res)
@show res
push!(res, 7, 0.1)
@show res
pop!(res)
@show res
# It can be iterated

for (id, d) in res
    @show id => d
end

#- Using BeutifulMakie style
# ## Dependencies
using Pkg # hide
Pkg.status(["SimilaritySearch"]) # hide