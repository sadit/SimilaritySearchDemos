<!--This file was generated, do not modify it.-->
````julia:ex1
using Markdown # hide
````

## Solving single queries and `KnnResult`
By Eric S. Téllez

````julia:ex2
ENV["GKSwstype"] = "nul" # hide

using SimilaritySearch
````

This example shows how to perform single queries instead of solving a batch of them.
This is particularly useful for some applications, and we also show how they are solved,
which could be used to avoid some memory allocations.

````julia:ex3
const dim = 8

db = MatrixDatabase(randn(Float32, dim, 10^4))
dist = SqL2Distance()
G = SearchGraph(; dist, db, verbose=false)
index!(G)
nothing # hide
````

Suppose you want to compute some $k$ nearest neighbors, for this we use the structure
`KnnResult` which is a priority queue of maximum size `k`.

````julia:ex4
res = KnnResult(3) # allocates memory for 10 nearest neighbors
for v in rand(db, 10)
    global res = reuse!(res)  # reuses the res object
    @time search(G, v, res)
    @show minimum(res), maximum(res), argmin(res), argmax(res)
    @show res
end
````

## `KnnResult`
This structure is the container for the result and it is also used to specify the number
of elements to retrieve. As mentioned before, it is a priority queue

````julia:ex5
res = reuse!(res)
push_item!(res, 1, 10)
push_item!(res, 2, 9)
push_item!(res, 3, 8)
push_item!(res, 4, 7)
push_item!(res, 6, 5)
@show res
````

it also supports removals

````julia:ex6
@show :popfirst! => popfirst!(res)
push_item!(res, 7, 0.1)
@show :push_item! => res
@show :pop! => pop!(res)
res
````

It can be iterated

````julia:ex7
@show collect(res)
````

## Dependencies

````julia:ex8
using Pkg # hide
Pkg.status(["SimilaritySearch"]) # hide
````

