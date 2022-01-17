# run as:
# julia -t64 --project=.. create-index-and-umap.jl

using SimilaritySearch, JLD2, DataFrames, Strs, UMAP

import Downloads: download

url_ = "http://geo.ingeotec.mx/~sadit/similarity-search-demos"
dbfile = "enwiktionary.jld2"

function download_dataset(filename)
    if !isfile(filename)
        println("downloading $filename")
        download("$url_/$filename", filename)
    else
        println("using cached $filename")
    end
end

function create_or_load_index(indexfile)
    if isfile(indexfile)
		load(indexfile, "index")
	else
        db = load(dbfile, "enwiktionary")
        G = SearchGraph(db=VectorDatabase(db.word), dist=LevenshteinDistance())
        push!(G.callbacks, OptimizeParameters(kind=ParetoRecall()))
        G.neighborhood.reduce = DistalSatNeighborhood()
        index!(G; parallel_block=1024)
        optimize!(G, OptimizeParameters(kind=MinRecall(), minrecall=0.90))
        jldsave(indexfile, index=G)
        G
	end
end

function main()
    println(stderr, "The construction of this index and umap is a bit more costly than vector datasets")
    println(stderr, "You can download the index and UMAP's projection uncommenting them in the download list")
    umapfile = "enwiktionary-umap-embeddings.jld2"
    indexfile = "enwiktionary-index.jld2"
    for filename in [
        dbfile,
        #umapfile,
        #indexfile
        ]
        download_dataset(filename)
    end
    index = create_or_load_index(indexfile)
    if !isfile(umapfile)
        U2 = UMAP_(index, 2; init=:random)  # spectral layout is too slow for the input-data's size
        U3 = UMAP_(U2, 3; init=:random)  # reuses input data
        jldsave(umapfile, e2=U2.embedding, e3=U3.embedding)
    end
end

if !isinteractive()
    main()
end
