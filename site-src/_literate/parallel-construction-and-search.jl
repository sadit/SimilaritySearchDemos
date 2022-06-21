using Markdown # hide

# ## Parallel construction and parallel search
# By Eric S. Téllez
#

ENV["GKSwstype"] = "nul" # hide

using SimilaritySearch
# Similarity search on very large datasets and high-dimensional datasets require high computational
# resources. In this example we show how to parallelize both the construction and search to be able to
# handle this kind of databases.

const dim = 16

db = MatrixDatabase(randn(Float32, dim, 10^5))
Q = MatrixDatabase(randn(Float32, dim, 30))
dist = SqL2Distance()
G = SearchGraph(; dist, db, verbose=true)

# The `SearchGraph` construction algorithm is incremental:
# - If the index is empty, an element is inserted just inserting it into the index
# - If the index is not empty, the element is inserted and connected to its nearest neighbors (looking into the current index)
# 
# the parallel construction is made with `index!` or `append!`, for this matter these functions accept
# a `parallel_block` argument, that controls how many elements are inserted at once, i.e., looking for its nearest neighbors
# in parallel and connected also in parallel.
# 
# As in the sequential version, a minimum number of elements must exists to work, and therefore, the `parallel_minimum_first_block`
# argument can also be specified. By default, it is equal to `parallel_block`.
# The `parallel_block` argument should be set to at least the number of available threads, and perhaps multiplying it by
# a small constant is also a good approach.
#
# This example didn't run in parallel due to the document generation pipeline but all demonstrations actually do it.
# Nonetheless, they ran with the parallel API in single thread mode.
index!(G; parallel_block=512)
nothing # hide

# Note that you can't call `push!`, `append!`, or `index!` from several threads. The default algorithm will takes
# advantage of the multiple threads-
#
# ## Searching
# Once the index is constructed, you can solve batches in parallel and also single queries.
# In contrast with append, these functions can be called in multithreading algorithms.
# However, you must pause the searching requests while perform insertions (parallel or sequential).

I, D = searchbatch(G, Q, 10)


Threads.@threads for i in eachindex(Q)
    res, cost = search(G, Q[i], KnnResult(10))
    println(res.id) # do something with `res`
end

# ## About searching pools
# Searching and also insertion methods (since they also perform searches) make use of several objects that are cached
# and reused to reduce memory allocations. These caches are named pools and are of type `SearchGraphPools`, their
# default values should be enough for multithreading applications, but special usage will require to review them.
# Among the special usages that require an explicit handling of pools we can think on objects indexing objects
# that are also indexes, or distance functions that can perform context switches as tasks (?).
# 
#- Using BeutifulMakie style
# ## Dependencies
using Pkg # hide
Pkg.status(["SimilaritySearch"]) # hide
