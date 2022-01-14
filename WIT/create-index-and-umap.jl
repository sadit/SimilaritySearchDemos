# run as:
# julia -t64 --project=.. create-index-and-umap.jl

using SimilaritySearch, LinearAlgebra, JLD2, UMAP
import Downloads: download

url_ = "http://geo.ingeotec.mx/~sadit/similarity-search-demos"
dbfile = "wit-es.jld2"
embeddingsfile = "wit-embeddings.jld2"

function progress(total, now)
    if (now >> 23) != ((now+1) >> 23)
        println("total: $total, now: $now")
    end
end

function download_dataset()
    if !isfile(dbfile)
        println("downloading $dbfile")
        download("$url_/$dbfile", dbfile; progress)
    else
        println("using cached $dbfile")
    end
    if !isfile(embeddingsfile)
        println("downloading $embeddingsfile")
        download("$url_/$embeddingsfile", embeddingsfile; progress)
    else
        println("using cached $embeddingsfile")
    end
end

function create_or_load_index(indexfile)
    dist = NormalizedAngleDistance()
	
    if isfile(indexfile)
		load(indexfile, "index")
	else
        X = load(embeddingsfile, "embeddings")
        for c in eachcol(X)
            normalize!(c)
        end
		index = SearchGraph(; dist, db=MatrixDatabase(X))
		index.neighborhood.reduce = SatNeighborhood()
		push!(index.callbacks, OptimizeParameters(; kind=:pareto_recall_searchtime))
		index!(index)
		optimize!(index, OptimizeParameters(; kind=:minimum_recall_searchtime, minrecall=0.9))
		jldsave(indexfile, index=index)
		index
	end
end

function main()
    download_dataset()
    index = create_or_load_index("wit-index.jld2")
    U2 = UMAP_(index, 2; init=:random)  # spectral layout is too slow for the input-data's size
    U3 = UMAP_(U2, 3; init=:random)  # reuses input data
    jldsave("wit-umap-embeddings.jld2", e2=U2.embedding, e3=U3.embedding)
end

if !isinteractive()
    main()
end