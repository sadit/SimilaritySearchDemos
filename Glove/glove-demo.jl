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

# ╔═╡ c5af5d4a-455b-11eb-0b57-4d8d63615b85
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
		PackageSpec(name="Embeddings", version="0.4"),
		PackageSpec(name="SimilaritySearch", version="0.8.10"),
		PackageSpec(url="https://github.com/sadit/UMAP.jl",
			rev="0eb586724de41b39dd46f7a3748970c464f57fe3")
	])
	
	using PlutoUI, SimilaritySearch, JLD2, DataFrames, HypertextLiteral, LinearAlgebra, Plots, UMAP, Embeddings
end

# ╔═╡ 5cd87a9e-5506-11eb-2744-6f02144677ff
md"""
# Using SimilaritySearch.jl to visualize and search Glove (d=100, 6B tokens, voc=400K)
"""

# ╔═╡ aae87f0c-ec75-431b-bf52-71886ba43d85
begin
	indexfile = "glove-index.jld2"
	umapfile = "glove-umap-embeddings.jld2"
	
	function load_dataset()
		emb = load_embeddings(GloVe{:en}, 2)  # you can change with any of the available embeddings in `Embeddings`
	    for c in eachcol(emb.embeddings)
	        normalize!(c)
	    end
		
	    emb
	end
	
	function create_or_load_index(indexfile)		
	    if isfile(indexfile)
			load(indexfile, "index", "vocab")
		else
			emb = load_dataset()
			db = MatrixDatabase(emb.embeddings)
			dist = NormalizedCosineDistance()
			index = SearchGraph(; dist, db)
			index!(index)
			optimize!(index, OptimizeParameters(kind=MinRecall(0.9)))
			jldsave(indexfile, index=index, vocab=emb.vocab)
			index, emb.vocab
		end
	end

	function load_or_create_umap_embeddings(index; force=false, n_neighbors=15, n_epochs=50, neg_sample_rate=3, layout=KnnGraphComponentsLayout())
		if !force && isfile(umapfile)
			e2, e3 = load(umapfile, "e2", "e3")
			(e2=e2, e3=e3)
		else
			#layout = RandomLayout()
			# increase both `n_epochs` and `neg_sample_rate` to improve projection
			#layout = SpectralLayout() ## the results are much better with Spectral layout
			U2 = UMAP_(index, 2; n_neighbors, neg_sample_rate, layout, n_epochs)  # spectral layout is too slow for the input-data's size
			L = vcat(U2.embedding, rand(-10f0:eps(Float32):10f0, 1, size(U2.embedding, 2)))
			layout = PrecomputedLayout(L)
		    U3 = UMAP_(U2, 3; neg_sample_rate, layout, n_epochs)  # reuses U2
		    jldsave(umapfile, e2=U2.embedding, e3=U3.embedding)
			(e2=U2.embedding, e3=U3.embedding)
		end
	end

end

# ╔═╡ d8d27dbc-5507-11eb-20e9-0f16ddba080b
md"""
##### Note: This notebook needs the `glove-index.jld2` file, see README.md for more details
"""

# ╔═╡ 1ce583f6-54fb-11eb-10ad-b5dc9328ca3b
begin
	index, vocab = create_or_load_index(indexfile)
	vocab2id = Dict(w => i for (i, w) in enumerate(vocab))
	n = length(index)
	res = KnnResult(10)
	wordinput = @bind wordid Slider(1:n, default=rand(1:n))
	md"""
	select word ID: $(wordinput), $n
	"""
end

# ╔═╡ 82b8a76e-dc38-499e-8242-975d75c2e2c8
function result_row(i, word, id, d)
	@htl """
<tr><td>$i</td><td>$(word)</td><td>$id</td><td>$(round(d, digits=3)) </td><td><button onclick='var elem = document.querySelector("bond >input"); elem.value = $id; elem.dispatchEvent(new CustomEvent("input")); '>similar</button></td></tr>
	"""
end

# ╔═╡ def63abc-45e7-11eb-231d-11d94709acd3
function displayresults(query, k=10)
	reuse!(res, k)
	@time search(index, query, res)
	L = []
	for (i, (id, d)) in enumerate(res)
		push!(L, result_row(i, vocab[id], id, d))
	end
	
	@htl """

<h2>Result list for <em>$(vocab[wordid])</em></h2>
id=$(wordid), n=$(length(index))
<table>
<tr><td>knn</td><td>word</td><td>id</td><td>dist</td><td></td></tr>
$L
</table>

	"""
end

# ╔═╡ 899b5620-5e7e-4728-9054-43b4c81b83bf
displayresults(index[wordid])

# ╔═╡ da00cb34-33b1-4320-a748-9677c523601e
md"""# Solving analogies
Change words directly on the cell
"""

# ╔═╡ 358b3640-dff0-4cd5-a373-6452a929562f
begin
	v = index[vocab2id["father"]] - index[vocab2id["man"]] + index[vocab2id["woman"]]
	normalize!(v)
	displayresults(v)
end

# ╔═╡ 3436c10a-6aa3-4653-96b0-5eb02759aa04
md"Note: clicking on _similar_ button updates the first list of results"

# ╔═╡ 0eea90db-9f11-4e0c-86e6-7dd4d37d1185
begin
	first_time = Ref(true)
	mdbutton = @bind umap_button Button("UMAP projection")

	md"""
# Visualizing the dataset

Click the button if you want to compute a 2d projection of the dataset (along with a 3d projection for coloring). This can take a long time if you don't run the notebook with several threads.

$mdbutton
	"""
end

# ╔═╡ 75633b17-b6e9-4bdc-ab41-05436a87bd78
begin
	umap_button
	
    #MNIST.download()
    
	function normcolors(V)
	    min_, max_ = extrema(V)
	    V .= (V .- min_) ./ (max_ - min_)
	    V .= clamp.(V, 0, 1)
	end

	function plot_umap()
		e2, e3 = load_or_create_umap_embeddings(index; force=false, n_neighbors=5, n_epochs=50, neg_sample_rate=3, layout=KnnGraphComponentsLayout())
		#e2, e3 = load_or_create_umap_embeddings(index; force=true, n_neighbors=5, n_epochs=50, neg_sample_rate=3, layout=RandomLayout())

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

# ╔═╡ Cell order:
# ╟─5cd87a9e-5506-11eb-2744-6f02144677ff
# ╟─c5af5d4a-455b-11eb-0b57-4d8d63615b85
# ╟─aae87f0c-ec75-431b-bf52-71886ba43d85
# ╟─d8d27dbc-5507-11eb-20e9-0f16ddba080b
# ╟─1ce583f6-54fb-11eb-10ad-b5dc9328ca3b
# ╠═899b5620-5e7e-4728-9054-43b4c81b83bf
# ╟─82b8a76e-dc38-499e-8242-975d75c2e2c8
# ╟─def63abc-45e7-11eb-231d-11d94709acd3
# ╟─da00cb34-33b1-4320-a748-9677c523601e
# ╠═358b3640-dff0-4cd5-a373-6452a929562f
# ╟─3436c10a-6aa3-4653-96b0-5eb02759aa04
# ╟─0eea90db-9f11-4e0c-86e6-7dd4d37d1185
# ╟─75633b17-b6e9-4bdc-ab41-05436a87bd78
