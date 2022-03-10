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

# ╔═╡ 2dfd9512-72d1-11ec-02b6-1f9c02939a5c
begin
	# UMAP is not registred yet in the general register
	using Pkg
	Pkg.activate(".")
	Pkg.add([
		PackageSpec(name="PlutoUI", version="0.7"),
		PackageSpec(name="JLD2", version="0.4"),
		PackageSpec(name="DataFrames", version="1.3"),
		PackageSpec(name="HypertextLiteral", version="0.9"),
		PackageSpec(name="Plots", version="1.26"),
		PackageSpec(name="SimilaritySearch", version="0.8.10"),
		PackageSpec(url="https://github.com/sadit/UMAP.jl",
			rev="0eb586724de41b39dd46f7a3748970c464f57fe3")
	])
	
	using PlutoUI, SimilaritySearch, JLD2, DataFrames, HypertextLiteral, LinearAlgebra, Plots, UMAP
	using Downloads: download
end

# ╔═╡ 9d4208c2-08b4-4ab6-9ade-9c7f0f8b67e3
md"""
# Searching and visualizing the WIT dataset using Clip embeddings

In this demonstration, we create a SearchGraph index for searching for similarity the WIT dataset using Clip embeddings. Additionally, we produce a visualization of the entire dataset using a custom UMAP package using the index for creating an approximate all-nearest neighbors graph, since it is needed by the UMAP algorithm.

WIT is the Wikipedia-based Image and Text multimodal dataset described in 

> Srinivasan, K., Raman, K., Chen, J., Bendersky, M., & Najork, M. (2021, July). Wit: Wikipedia-based image text dataset for multimodal multilingual machine learning. In Proceedings of the 44th International ACM SIGIR Conference on Research and Development in Information Retrieval (pp. 2443-2449).

Clip embeddings are described in

> Radford, A., Kim, J. W., Hallacy, C., Ramesh, A., Goh, G., Agarwal, S., ... & Sutskever, I. (2021, July). Learning transferable visual models from natural language supervision. In International Conference on Machine Learning (pp. 8748-8763). PMLR.


## Dataset 
- dimension: 512
- size: 300K vectors
- distance: cosine

## Note

All images are linked to Wikipedia URLs. We use a precomputed set of embeddings corresponding to a small subset of the Spanish WIT.
"""

# ╔═╡ aa889e21-74b0-446e-97ee-663b2e0a0ae8
begin
	url_ = "http://geo.ingeotec.mx/~sadit/similarity-search-demos"
	dbfile = "wit-es.jld2"
	embeddingsfile = "wit-embeddings.jld2"
	indexfile = "wit-index.jld2"
	umapfile = "wit-umap-embeddings.jld2"
	nothing
end

# ╔═╡ 8f7e14d9-0e48-43fc-a7d5-2caa24ce8dc4
!isfile(dbfile) && download("$url_/$dbfile", dbfile) && nothing || nothing

# ╔═╡ df4f6c26-2ead-432d-96a9-f6b7b7b73dd4
begin
	db, map_ = load("wit-es.jld2", "context", "map")
	nothing
end

# ╔═╡ 8a550f47-e87a-4298-b9b7-8887eb8e3b51
!isfile(embeddingsfile) && download("$url_/$embeddingsfile", embeddingsfile) && nothing || nothing

# ╔═╡ 694d64e7-a009-4002-a8da-9ead5da41cff
function create_or_load_index()
	if isfile(indexfile)
		println("loading already created index")
		load(indexfile, "index")
	else
		X = load(embeddingsfile, "embeddings")
		for c in eachcol(X)
			normalize!(c)
		end
	
		dist = NormalizedAngleDistance()
		index = SearchGraph(; dist, db=MatrixDatabase(X))
		index!(index)
		optimize!(index, OptimizeParameters(kind=MinRecall(0.9)))
		jldsave(indexfile, index=index)
		index
	end
end

# ╔═╡ 8d40c240-bacc-4093-a05b-52b6298eaa0a
function load_or_create_umap_embeddings(index)
	if isfile(umapfile)
		e2, e3 = load(umapfile, "e2", "e3")
		(e2=e2, e3=e3)
	else
		U2 = UMAP_(index, 2; layout=RandomLayout())  # spectral layout is too slow for the input-data's size
	    U3 = UMAP_(U2, 3; layout=RandomLayout())  # reuses input data
	    jldsave(umapfile, e2=U2.embedding, e3=U3.embedding)
		(e2=U2.embedding, e3=U3.embedding)
	end
end


# ╔═╡ ab5f3920-0568-4821-90b0-c9667ee1bfa3
begin
	first_time = Ref(true)
	UmapButton_ = @bind umap_button Button("UMAP projection")
	
	md"""
# Visualize the dataset

Click the button if you want to compute a 2d projection of the dataset (along with a 3d projection for coloring). This can take a long time if you don't run the notebook with several threads. For instance, both projections took 20 seconds to compute for WIT dataset \$(n=300K, d=512, cos)\$ using `Pluto.run(threads=64)`.

$(UmapButton_)
	"""
end

# ╔═╡ ef51024e-3022-4981-90f2-7f085d0b862d
begin
	index = create_or_load_index()
	n = length(index)
	docID_list = @bind docID Slider(1:n, default=rand(1:n))
	k_list = @bind k Slider(1:30, default=4)
	@htl("""
	<h1> Searching nearest neighbors based on WIT embeddings </h1>
	Select the document ID on the left slide and set the number of nearest neighbors to retrieve
	<div id="my_controls">
	doc: $(docID_list) , k: $(k_list)
	</div>
	
<div style="background-color: rgb(220, 220, 230);">
	<strong>Note:</strong> This demo doesn't compute embeddings and works with a pre-computed dataset.
</div>
	""")
end

# ╔═╡ e987864d-68f9-4974-ac1a-ae12d8f4ec9a
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

# ╔═╡ 3f0b1230-0f49-46c6-a4f4-cfeb3a79e739
begin
	results = []
	R = search(index, index[docID], KnnResult(k))
	
	for (id, dist) in R.res
		i = map_[id]
		image = db.image_url[i]
		title = db.page_title[i]
		url = db.page_url[i]
		context = db.context_page_description[i]
		h = @htl """<div>
		<img alt="$title" src="$image" width="30%" /> - <a href="$url">$title</a> : dist: $(round(dist, digits=4))
		<div>
		</div>
		<h2>$title <button onclick='var elem = document.getElementById("my_controls").querySelector("bond > input"); elem.value = $id; elem.dispatchEvent(new CustomEvent("input")); '>search for similar objects</button></h2>
		<p>
		$context
		</p>
		</div>
		<hr/>
		"""
		push!(results, h)
	end

	@htl """
	
		$(results)
	"""
end

# ╔═╡ Cell order:
# ╟─9d4208c2-08b4-4ab6-9ade-9c7f0f8b67e3
# ╟─2dfd9512-72d1-11ec-02b6-1f9c02939a5c
# ╟─aa889e21-74b0-446e-97ee-663b2e0a0ae8
# ╟─8f7e14d9-0e48-43fc-a7d5-2caa24ce8dc4
# ╟─df4f6c26-2ead-432d-96a9-f6b7b7b73dd4
# ╟─8a550f47-e87a-4298-b9b7-8887eb8e3b51
# ╟─694d64e7-a009-4002-a8da-9ead5da41cff
# ╟─8d40c240-bacc-4093-a05b-52b6298eaa0a
# ╟─ab5f3920-0568-4821-90b0-c9667ee1bfa3
# ╟─e987864d-68f9-4974-ac1a-ae12d8f4ec9a
# ╟─ef51024e-3022-4981-90f2-7f085d0b862d
# ╟─3f0b1230-0f49-46c6-a4f4-cfeb3a79e739
