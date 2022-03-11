### A Pluto.jl notebook ###
# v0.17.7

using Markdown
using InteractiveUtils

# ╔═╡ 516d87d2-a0a5-11ec-08e6-11f0ecb5892b
begin
	using Pkg
	Pkg.activate(".")
	Pkg.add([
		PackageSpec(name="PlutoUI", version="0.7"),
		PackageSpec(name="HypertextLiteral", version="0.9"),
		PackageSpec(name="Plots", version="1.26"),
		PackageSpec(name="SimilaritySearch", version="0.8.10"),
		PackageSpec(name="Primes", version="0.5"),
		PackageSpec(url="https://github.com/sadit/UMAP.jl",
			rev="0eb586724de41b39dd46f7a3748970c464f57fe3")
	])
	
	using PlutoUI, SimilaritySearch, HypertextLiteral, LinearAlgebra, Plots, UMAP, Primes
end

# ╔═╡ c70e35ab-d85b-472f-b4f6-85d8836aa1a5
md"""
# Visualizing prime gaps

The difference between contiguous prime numbers is called a [Prime gap](https://en.wikipedia.org/wiki/Prime_gap). We use this series of values as a time series example due to its interesting behavior and since it can be computed without downloading more than the necessary packages.

This example shows how to generate the dataset and index it, and therefore using it for generating a UMAP visualization.

## Generation of the dataset

The time series is represented with windows of size `w`, we also take `log` of gaps to reduce variance in gap values. Regarding the dataset, we used vectors represented as views to avoid multiplying memory usage.
"""

# ╔═╡ 5af761ea-573f-4c86-8ffa-73e686d57e0e


# ╔═╡ d8dc36b4-87c3-4bb6-9bea-a1e4b541043d

function create_database_primes_diff(n, w)
	T = log2.(diff(primes(n)))
	S = [view(T, i:(i+w)) for i in 1:(length(T)-w)]
	VectorDatabase(S)
end

# ╔═╡ 2960e610-d0b3-426a-aedb-24f33cf92d59
md"""
## Parameters to generate the dataset

Please feel free to move all parameters and look what happens with the visualization
"""

# ╔═╡ 170e159a-b121-40f1-8a96-c4a527d1c4e1
begin # index and dataset parameters
	n = 10^6
	w = 6
	dist = L2Distance() # L2Distance, CosineDistance
end

# ╔═╡ 78edb060-4bae-469d-a458-af79db75d410
begin
	db = create_database_primes_diff(n, w)
	index = SearchGraph(; dist, db)
	index!(index)
	optimize!(index, OptimizeParameters(; kind=MinRecall(0.9)))
end

# ╔═╡ 7c838cff-a64f-40a1-9448-1a7700c605a4
md"""
## Parameters for the UMAP projection
"""

# ╔═╡ 0c1b03d1-7bcc-41f2-a99d-e9309abb665a
begin # UMAP params
	layout = KnnGraphComponentsLayout()  # RandomLayout()
	n_neighbors = 50
	n_epochs = 100
	neg_sample_rate = 3
end

# ╔═╡ 1f3764a3-fd92-4ef1-abe4-d7f316d1750c
length(db)

# ╔═╡ bc204b57-5b85-4989-abfc-af98295f22e3
begin
    function load_or_create_umap_embeddings(index, 
				layout = layout,
				n_neighbors = n_neighbors,
				n_epochs = n_epochs,
				neg_sample_rate = neg_sample_rate
		)
		#layout = RandomLayout()
		# increase both `n_epochs` and `neg_sample_rate` to improve projection
		
		 # increase this number for 
		#layout = SpectralLayout() ## the results are much better with Spectral layout
		U2 = UMAP_(index, 2; n_neighbors, neg_sample_rate, layout, n_epochs)  # spectral layout is too slow for the input-data's size
		L = vcat(U2.embedding, rand(-10f0:eps(Float32):10f0, 1, size(U2.embedding, 2)))
		layout = PrecomputedLayout(L)
		U3 = UMAP_(U2, 3; neg_sample_rate, layout, n_epochs)  # reuses input data
		(e2=U2.embedding, e3=U3.embedding)
	end
		
	function normcolors(V)
	    min_, max_ = extrema(V)
	    V .= (V .- min_) ./ (max_ - min_)
	    V .= clamp.(V, 0, 1)
	end

	function plot_umap()
		e2, e3 = load_or_create_umap_embeddings(index)
	
	    normcolors(@view e3[1, :])
	    normcolors(@view e3[2, :])
	    normcolors(@view e3[3, :])
	
	    C = [RGB(c...) for c in eachcol(e3)]
		X = @view e2[1, :]
	    Y = @view e2[2, :]
		scatter(X, Y, c=C, fmt=:png, size=(600, 600), ma=0.3, a=0.3, ms=1, msw=0, label="", yticks=nothing, xticks=nothing, xaxis=false, yaxis=false)
	end

	
	plot_umap()
end

# ╔═╡ 4fc37731-4d8c-45b8-acb3-d260868294b0


# ╔═╡ cb053906-6664-4b4e-8cbd-b8bee8a309e9


# ╔═╡ 1cf1e12c-9a41-4ce8-8519-a8a399898eeb


# ╔═╡ Cell order:
# ╠═516d87d2-a0a5-11ec-08e6-11f0ecb5892b
# ╟─c70e35ab-d85b-472f-b4f6-85d8836aa1a5
# ╠═5af761ea-573f-4c86-8ffa-73e686d57e0e
# ╠═d8dc36b4-87c3-4bb6-9bea-a1e4b541043d
# ╟─2960e610-d0b3-426a-aedb-24f33cf92d59
# ╠═170e159a-b121-40f1-8a96-c4a527d1c4e1
# ╠═78edb060-4bae-469d-a458-af79db75d410
# ╟─7c838cff-a64f-40a1-9448-1a7700c605a4
# ╠═0c1b03d1-7bcc-41f2-a99d-e9309abb665a
# ╠═1f3764a3-fd92-4ef1-abe4-d7f316d1750c
# ╠═bc204b57-5b85-4989-abfc-af98295f22e3
# ╠═4fc37731-4d8c-45b8-acb3-d260868294b0
# ╠═cb053906-6664-4b4e-8cbd-b8bee8a309e9
# ╠═1cf1e12c-9a41-4ce8-8519-a8a399898eeb
