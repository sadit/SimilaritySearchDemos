# This file was generated, do not modify it. # hide
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