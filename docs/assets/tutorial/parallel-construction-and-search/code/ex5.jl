# This file was generated, do not modify it. # hide
I, D = searchbatch(G, Q, 10; parallel=true)


Threads.@threads for i in eachindex(Q)
    res, cost = search(G, Q[i], KnnResult(10))
    println(res.id) # do something with `res`
end