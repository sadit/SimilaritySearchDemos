##using Markdown # hide

# ## Using the `SimilaritySearch` package
# By Eric S. Téllez
#
# This is a small tutorial showing a minimum example for working with `SimilaritySearch`
# it accepts several options that are let to defaults. While this should be enough for many
# purposes, you are invited to see the rest of the tutorials to take advantage of other
# features.
ENV["GKSwstype"] = "nul" # hide

using SimilaritySearch
Threads.nthreads()
# MatrixDatabase is a required wrapper that tells `SimilaritySearch` how to access underlying objects
# since it can support different kinds of objects. In this setup, each column is an object
# and will be accessed through views using the MatrixDatabase. Since the backend doesn't support
# appends or pushes, the index can be seen as an static index.

db = MatrixDatabase(randn(2, 10^5))
dist = L2Distance() # squared L2

# it can use any distance function described in `SimilaritySearch` and `Distances.jl`,
# and in fact any `SemiMetric` as described in the later package.
# The index construction is made as follows
G = SearchGraph(; dist, db, verbose=false)
index!(G)
#- callbacks = SearchGraphCallbacks(hyperparameters=OptimizeParameters(MinRecall(0.9)))
#- optimize!(G; callbacks)

# this will display a lot of information in the console, since as construction advances
# the hyperparameters of the index are adjusted. The default optimization takes into account
# both quality and speed, and tries to adjust to take the best of both.
# See `ParetoRecall` in docs.
#
# Once the index is created, the index can solve nearest neighbor queries

Q = MatrixDatabase(randn(2, 100))
k = 30
I, D = searchbatch(G, Q, k)
@show typeof(I) => size(I)
@show typeof(D) => size(D)
# `I` is a matrix of identifiers in `db`. Each column stores the $k$ nearest neighbors (approx.)
# for the $i$-th colum (object) in `Q`. The matrix `D` stores the the corresponding distances for
# each identifier in `I`.
# 
# ## Visualizing what we just did

using Plots
@views scatter(db.matrix[1, :], db.matrix[2, :], fmt=:png, size=(600, 600), color=:cyan, ma=0.3, a=0.3, ms=1, msw=0, label="")
for c in eachcol(I)
    R = db.matrix[:, c]
    @views scatter!(R[1, :], R[2, :], m=:diamond, ma=0.3, a=0.3, color=:auto, ms=2, msw=0, label="")
end

@views scatter!(Q.matrix[1, :], Q.matrix[2, :], color=:black, m=:star, ma=0.5, a=0.5, ms=4, msw=0, label="")

savefig(joinpath(@OUTPUT, "fig-2d-t1.png")) # hide

# \fig{fig-2d-t1.png}
#
# Cyan points identify the dataset while starts are query points. The nearest neighbor points
# are colored automatically and can repeat, but they come quite close to query points,
# in dense areas they are even hidding them.

#- Using BeutifulMakie style
# ## Dependencies
using Pkg # hide
Pkg.status(["SimilaritySearch", "Plots"]) # hide
