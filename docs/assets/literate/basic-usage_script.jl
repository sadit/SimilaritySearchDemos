# This file was generated, do not modify it.

##using Markdown # hide

ENV["GKSwstype"] = "nul" # hide

using SimilaritySearch
Threads.nthreads()

db = MatrixDatabase(randn(2, 10^5))
dist = L2Distance() # squared L2

G = SearchGraph(; dist, db, verbose=false)
index!(G)

Q = MatrixDatabase(randn(2, 100))
k = 30
I, D = searchbatch(G, Q, k)
@show typeof(I) => size(I)
@show typeof(D) => size(D)

using Plots
@views scatter(db.matrix[1, :], db.matrix[2, :], fmt=:png, size=(600, 600), color=:cyan, ma=0.3, a=0.3, ms=1, msw=0, label="")
for c in eachcol(I)
    R = db.matrix[:, c]
    @views scatter!(R[1, :], R[2, :], m=:diamond, ma=0.3, a=0.3, color=:auto, ms=2, msw=0, label="")
end

@views scatter!(Q.matrix[1, :], Q.matrix[2, :], color=:black, m=:star, ma=0.5, a=0.5, ms=4, msw=0, label="")

savefig(joinpath(@OUTPUT, "fig-2d-t1.png")) # hide

using Pkg # hide
Pkg.status(["SimilaritySearch", "Plots"]) # hide

