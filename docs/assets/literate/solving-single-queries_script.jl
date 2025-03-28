# This file was generated, do not modify it.

using Markdown # hide

ENV["GKSwstype"] = "nul" # hide

using SimilaritySearch

const dim = 8

db = MatrixDatabase(randn(Float32, dim, 10^4))
dist = SqL2Distance()
G = SearchGraph(; dist, db, verbose=false)
index!(G)
nothing # hide

res = KnnResult(3) # allocates memory for 10 nearest neighbors
for v in rand(db, 10)
    global res = reuse!(res)  # reuses the res object
    @time search(G, v, res)
    @show minimum(res), maximum(res), argmin(res), argmax(res)
    @show res
end

res = reuse!(res)
push_item!(res, 1, 10)
push_item!(res, 2, 9)
push_item!(res, 3, 8)
push_item!(res, 4, 7)
push_item!(res, 6, 5)
@show res

@show :popfirst! => popfirst!(res)
push_item!(res, 7, 0.1)
@show :push_item! => res
@show :pop! => pop!(res)
res

@show collect(res)

using Pkg # hide
Pkg.status(["SimilaritySearch"]) # hide

