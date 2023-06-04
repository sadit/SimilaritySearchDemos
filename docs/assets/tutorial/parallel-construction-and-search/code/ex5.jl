# This file was generated, do not modify it. # hide
I, D = searchbatch(G, Q, 10)


Threads.@threads for i in eachindex(Q)
    p = search(G, Q[i], KnnResult(10))
    res = p.res
    println(res[1])
    println(collect(res))
    println(collect(IdView(res))) # do something with `res`
    println(collect(DistView(res))) # do something with `res`
end