# This file was generated, do not modify it. # hide
res = KnnResult(3) # allocates memory for 10 nearest neighbors
for v in rand(db, 10)
    global res = reuse!(res)  # reuses the res object
    @time search(G, v, res)
    @show minimum(res), maximum(res), argmin(res), argmax(res)
    @show res.id, res.dist
end