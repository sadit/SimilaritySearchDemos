### A Pluto.jl notebook ###
# v0.17.7

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 8d7dbebb-55f7-45e8-84e0-e5e5f9502449
begin
	# UMAP is not yet in the general register
	using Pkg
	Pkg.activate(".")
	Pkg.add([
		PackageSpec(name="PlutoUI", version="0.7"),
		PackageSpec(name="JLD2", version="0.4"),
		PackageSpec(name="DataFrames", version="1.3"),
		PackageSpec(name="HypertextLiteral", version="0.9"),
		PackageSpec(name="Plots", version="1.26"),
		PackageSpec(name="SimilaritySearch", version="0.8.10"),
		PackageSpec(name="MLDatasets", version="0.5"),
		PackageSpec(name="Colors", version="0.12"),
		PackageSpec(url="https://github.com/sadit/UMAP.jl",
			rev="0eb586724de41b39dd46f7a3748970c464f57fe3")
	])
	
	using PlutoUI, SimilaritySearch, JLD2, DataFrames, HypertextLiteral, LinearAlgebra, Plots, UMAP, MLDatasets
end

# ╔═╡ 5cd87a9e-5506-11eb-2744-6f02144677ff
md"""
# Using SimilaritySearch with MNIST


This example shows how to search on the MNIST dataset


## Loading the required packages for the examples
"""

# ╔═╡ b7b1751d-45f5-41ca-876f-d195a6e8abf8


# ╔═╡ c5af5d4a-455b-11eb-0b57-4d8d63615b85
begin
	indexfile = "mnist-index.jld2"
	umapfile = "mnist-umap-embeddings.jld2"
	nothing
end

# ╔═╡ d8d27dbc-5507-11eb-20e9-0f16ddba080b
md"""
##### Note: This notebook needs the `mnist-index.jld2` file, see README.md for more details
"""

# ╔═╡ 1ce583f6-54fb-11eb-10ad-b5dc9328ca3b
function create_or_load_index(indexfile)
    T, y = MNIST.traindata()
    n = size(T, 3)
    X = MatrixDatabase(Matrix{Float32}(reshape(T, (28*28, n))))
    dist = SqL2Distance()
	
    if isfile(indexfile)
		load(indexfile, "index")
	else
		index = SearchGraph(; dist, db=X)
		index!(index)
		optimize!(index, OptimizeParameters(; kind=MinRecall(0.9)))
		jldsave(indexfile, index=index)
		index
	end
end

# ╔═╡ de128463-0f01-4f79-9ba2-6b9d172ea871
function load_or_create_umap_embeddings(index)
	if isfile(umapfile)
		e2, e3 = load(umapfile, "e2", "e3")
		(e2=e2, e3=e3)
	else
		#layout = RandomLayout()
		layout = KnnGraphComponentsLayout()
		n_neighbors = 50
		# increase both `n_epochs` and `neg_sample_rate` to improve projection
		n_epochs = 50
		neg_sample_rate = 3 # increase this number for 
		#layout = SpectralLayout() ## the results are much better with Spectral layout
		U2 = UMAP_(index, 2; n_neighbors, neg_sample_rate, layout, n_epochs)  # spectral layout is too slow for the input-data's size
		L = vcat(U2.embedding, rand(-10f0:eps(Float32):10f0, 1, size(U2.embedding, 2)))
		layout = PrecomputedLayout(L)
	    U3 = UMAP_(U2, 3; neg_sample_rate, layout, n_epochs)  # reuses input data
	    jldsave(umapfile, e2=U2.embedding, e3=U3.embedding)
		(e2=U2.embedding, e3=U3.embedding)
	end
end


# ╔═╡ 040ccbd5-b6c0-4d8d-885e-0849480c0696


# ╔═╡ 64e9d67a-7e16-4421-bc2f-c75d9fa77e31
md"""
# Visualize the dataset

Click the button if you want to compute a 2d projection of the dataset (along with a 3d projection for coloring). This can take a long time if you don't run the notebook with several threads.
"""

# ╔═╡ 86358eba-9d99-4aff-a611-34e523bbd70a
begin
	first_time = Ref(true)
	@bind umap_button Button("UMAP projection")
end

# ╔═╡ 7dfd8c7f-1740-4676-b2aa-a3386cc5526a
begin
	res = KnnResult(10)
	index = create_or_load_index(indexfile)
end

# ╔═╡ 30d206ba-c971-4be1-92aa-653b2f15067f
begin
	umap_button
	
    #MNIST.download()
    
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

	if !first_time[]
		
		plot_umap()
	else
		first_time[] = false
		md"click the button to compute umap"
	end
end

# ╔═╡ 5b743cbc-54fa-11eb-1be4-4b619e1070b2
begin
	n = length(index)
	
	sel = @bind example_symbol html"<input type='range' min='1' max='60000' step='1'>"
	md"""
	select the query object using the bar: $(sel), $n
	"""
end

# ╔═╡ def63abc-45e7-11eb-231d-11d94709acd3
begin
	reuse!(res, 10)
	elapsed = @elapsed search(index, index[example_symbol], res)
	qinverted = 1 .- reshape(index[example_symbol], (28, 28))' # distinguishability
	h = hcat(qinverted,  [reshape(index[id_], (28, 28))' for id_ in idview(res)]...)
	
	md""" $(size(h))

- Query Id: $(example_symbol)
- Search time: $elapsed
- Database size: $(length(index))
	
	
# Result:
$(Gray.(h))


note: the first symbol is the query object and its colors were inverted
	"""
end

# ╔═╡ Cell order:
# ╟─5cd87a9e-5506-11eb-2744-6f02144677ff
# ╟─8d7dbebb-55f7-45e8-84e0-e5e5f9502449
# ╠═b7b1751d-45f5-41ca-876f-d195a6e8abf8
# ╟─c5af5d4a-455b-11eb-0b57-4d8d63615b85
# ╟─d8d27dbc-5507-11eb-20e9-0f16ddba080b
# ╟─1ce583f6-54fb-11eb-10ad-b5dc9328ca3b
# ╟─de128463-0f01-4f79-9ba2-6b9d172ea871
# ╠═040ccbd5-b6c0-4d8d-885e-0849480c0696
# ╟─64e9d67a-7e16-4421-bc2f-c75d9fa77e31
# ╠═86358eba-9d99-4aff-a611-34e523bbd70a
# ╟─30d206ba-c971-4be1-92aa-653b2f15067f
# ╟─7dfd8c7f-1740-4676-b2aa-a3386cc5526a
# ╟─5b743cbc-54fa-11eb-1be4-4b619e1070b2
# ╟─def63abc-45e7-11eb-231d-11d94709acd3
