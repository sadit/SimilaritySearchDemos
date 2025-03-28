# This file was generated, do not modify it.

using Markdown # hide

ENV["GKSwstype"] = "nul" # hide

using SimilaritySearch

const dim = 16

db = MatrixDatabase(randn(Float32, dim, 10^5))
Q = MatrixDatabase(randn(Float32, dim, 30))
dist = SqL2Distance()
G = SearchGraph(; dist, db, verbose=true)

index!(G; parallel_block=512)
nothing # hide

I, D = searchbatch(G, Q, 10)


Threads.@threads for i in eachindex(Q)
    p = search(G, Q[i], KnnResult(10))
    res = p.res

    print("=== $i -- nearest neighbor:")
    println(res[1])
    print("=== $i -- result set:")
    println(collect(res))
    print("=== $i -- identifiers:")
    println(collect(IdView(res))) # do something with `res`
    print("=== $i -- distances:")
    println(collect(DistView(res))) # do something with `res`
end

using Pkg # hide
Pkg.status(["SimilaritySearch"]) # hide

