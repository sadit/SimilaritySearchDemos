# This file was generated, do not modify it.

using Markdown # hide

ENV["GKSwstype"] = "nul" # hide

using SimilaritySearch

const dim = 8

db = DynamicMatrixDatabase(Float32, dim) # or VectorDatabase(Vector{Float32})
dist = L1Distance()

G = SearchGraph(; dist, db, verbose=false)

for _ in 1:10^4
    push_item!(G, rand(Float32, dim))  # push_item! inserts one item at a time
end

append_items!(G, MatrixDatabase(rand(Float32, dim, 10^4))) # append_items! inserts many items at once

@assert length(G) == 20_000

Q = MatrixDatabase(rand(dim, 30))
k = 5
I, D = searchbatch(G, Q, k)
D

using Pkg # hide
Pkg.status(["SimilaritySearch", "Plots"]) # hide

