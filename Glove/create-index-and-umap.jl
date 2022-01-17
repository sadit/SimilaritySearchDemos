# run as:
# julia -t64 create-glove-index-and-umap.jl

using SimilaritySearch, Embeddings, UMAP, LinearAlgebra, JLD2


function create_or_load_index(indexfile)
    emb = load_embeddings(GloVe{:en}, 2)
    for c in eachcol(emb.embeddings)
        normalize!(c)
    end
    X = MatrixDatabase(emb.embeddings)
    dist = NormalizedCosineDistance()
	
    if isfile(indexfile)
		load(indexfile, "index")
	else
		index = SearchGraph(; dist, db=X)
		index.neighborhood.reduce = SatNeighborhood()
		push!(index.callbacks, OptimizeParameters(; kind=ParetoRecall()))
		index!(index)
		optimize!(index, OptimizeParameters(; kind=MinRecall(), minrecall=0.9))
		jldsave(indexfile, index=index, vocab=emb.vocab)
		index
	end
end

function main()
    #MNIST.download()
    index = create_or_load_index("glove-index.jld2")
    U2 = UMAP_(index, 2; init=:random)  # spectral layout is too slow for the input-data's size
    U3 = UMAP_(U2, 3; init=:random)  # reuses input data
    jldsave("glove-umap-embeddings.jld2", e2=U2.embedding, e3=U3.embedding)
end

if !isinteractive()
    main()
end
