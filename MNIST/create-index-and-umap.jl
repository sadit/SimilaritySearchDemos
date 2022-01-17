# run as:
# julia -t64 create-mnist-index.jl


using SimilaritySearch, MLDatasets, UMAP, JLD2

function create_or_load_index(indexfile)
    T, y = MNIST.traindata()
    n = size(T, 3)
    X = MatrixDatabase(Matrix{Float32}(reshape(T, (28*28, n))))
    dist = SqL2Distance()
	
    if isfile(indexfile)
		load(indexfile, "index")
	else
		index = SearchGraph(; dist, db=X)
		index.neighborhood.reduce = SatNeighborhood()
		push!(index.callbacks, OptimizeParameters(; kind=ParetoRecall()))
		index!(index)
		optimize!(index, OptimizeParameters(; kind=MinRecall(), minrecall=0.9))
		jldsave(indexfile, index=index)
		index
	end
end

function main()
    #MNIST.download()
    index = create_or_load_index("mnist-index.jld2")
    U2 = UMAP_(index, 2; init=:random)  # spectral layout is too slow for the input-data's size
    U3 = UMAP_(U2, 3; init=:random)  # reuses input data
    jldsave("mnist-umap-embeddings.jld2", e2=U2.embedding, e3=U3.embedding)
end

if !isinteractive()
    main()
end
