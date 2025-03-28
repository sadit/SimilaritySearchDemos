<!--This file was generated, do not modify it.-->
````julia:ex1
using Markdown # hide
````

## Incremental construction with `SearchGraph`
By Eric S. Téllez

````julia:ex2
ENV["GKSwstype"] = "nul" # hide

using SimilaritySearch
````

For incremental construction we need a database backend that supports incremental insertions.
Currently, there are two backends for this: `DynamicMatrixDatabase` and `VectorDatabase`

- `DynamicMatrixDatabase`: produces matrix like databases (all objects having the same number of components)
- `VectorDatabase`: A generic conainer of objects, objects can be of any kind

````julia:ex3
const dim = 8

db = DynamicMatrixDatabase(Float32, dim) # or VectorDatabase(Vector{Float32})
dist = L1Distance()
````

it can use any distance function described in `SimilaritySearch` and `Distances.jl`,
and in fact any `SemiMetric` as described in the later package.
The index construction is made as follows

````julia:ex4
G = SearchGraph(; dist, db, verbose=false)
````

instead of `index!` we can use `push_item!` and `append_items!` functions

````julia:ex5
for _ in 1:10^4
    push_item!(G, rand(Float32, dim))  # push_item! inserts one item at a time
end

append_items!(G, MatrixDatabase(rand(Float32, dim, 10^4))) # append_items! inserts many items at once
````

Note that we used a `MatrixDatabase` to wrap the matrix to be inserted since it will be
copied into the index.

Now we have a populated index

````julia:ex6
@assert length(G) == 20_000
````

this will display a lot of information in the console, since as construction advances
the hyperparameters of the index are adjusted. The default optimization takes into account
both quality and speed, and tries to adjust to take the best of both.
See `ParetoRecall` in docs.

Once the index is created, the index can solve nearest neighbor queries

````julia:ex7
Q = MatrixDatabase(rand(dim, 30))
k = 5
I, D = searchbatch(G, Q, k)
D
````

## Dependencies

````julia:ex8
using Pkg # hide
Pkg.status(["SimilaritySearch", "Plots"]) # hide
````

