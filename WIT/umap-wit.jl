# run as:
# julia -t64 -L umap-wit.jl -i

using Pkg

using SimilaritySearch, JLD2, UMAP


println("""# Creating a UMAP visualization of WIT

This notebook uses the Uniform Manifold Approximation and Projection (UMAP) dimension reduction algorithm to create a 2d visualization.

UMAP uses a graph of nearest neighbors of a dataset as input and produces a low-dimensional embedding.


This demonstration uses the `wit-index.jld2` index.
""")

index = load("wit-index.jld2", "index")
U = UMAP_(index, 2; init=:random)  # spectral layout is too slow for the input-data's size
U3 = UMAP_(U, 3; init=:random)  # reuses input data
jldsave("vis-embeddings.jld2", e2=U.embedding, e3=U3.embedding)
