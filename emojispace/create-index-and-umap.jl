# run as:
# julia -t64 --project=.. create-index-and-umap.jl

using SimilaritySearch, JLD2, JSON, UMAP, CodecZlib, TextSearch, CategoricalArrays, DataFrames

import Downloads: download

url_ = "https://github.com/sadit/TextClassificationTutorial/blob/main/data/emo50k.json.gz?raw=true"

function download_dataset()
    filename = "emo50k.json.gz"
    if !isfile(filename)
        println("downloading $filename")
        download(url_, filename)
    else
        println("using cached $filename")
    end
end

function create_dataset(dbfile)
    isfile(dbfile) && return
    labels = String[]
    corpus = String[]
    open("emo50k.json.gz") do f
        for line in eachline(GzipDecompressorStream(f))
            r = JSON.parse(line)
            push!(labels, r["klass"])
            push!(corpus, r["text"])    
        end
    end

    tok = Tokenizer(TextConfig(group_usr=true, group_url=true, del_diac=true, lc=true, group_num=true, nlist=[], qlist=[3,5]))
    labels = categorical(labels)
    #model = VectorModel(EntropyWeighting(), BinaryLocalWeighting(), compute_bow_corpus(tok, corpus), labels, mindocs=3)
    #model = VectorModel(IdfWeighting(), TfWeighting(), compute_bow_corpus(tok, corpus), labels)
    model = VectorModel(IdfWeighting(), TfWeighting(), compute_bow_corpus(tok, corpus); mindocs=10)
    V = vectorize_corpus(tok, model, corpus)
    for v in V
        TextSearch.normalize!(v)
    end

    jldsave(dbfile, tok=tok, labels=labels, model=model, vectors=V)
end


function create_or_load_index(dbfile, indexfile)
    if isfile(indexfile)
		load(indexfile, "index")
	else
        db = load(dbfile, "vectors")
        #G = SearchGraph(db=VectorDatabase(db.word), dist=MinHausdorffDistance(NormalizedCosineDistance))
        G = SearchGraph(db=VectorDatabase(db), dist=NormalizedCosineDistance())
        push!(G.callbacks, OptimizeParameters(kind=ParetoRecall()))
        G.neighborhood.reduce = DistalSatNeighborhood()
        index!(G; parallel_block=64)
        optimize!(G, OptimizeParameters(kind=MinRecall(), minrecall=0.90))
        jldsave(indexfile, index=G)
        G
	end
end


function main()
    download_dataset()
    indexfile = "emojis-index.jld2"
    dbfile = "emojis-50k.jld2"
    umapfile = "emojis-umap-embeddings.jld2"
    for filename in [indexfile, dbfile, umapfile]
        Base.unlink(filename)
    end
    create_dataset(dbfile)
    index = create_or_load_index(dbfile, indexfile)

    if !isfile(umapfile)
        U2 = UMAP_(index, 2; init=:random)  # spectral layout is too slow for the input-data's size
        U3 = UMAP_(U2, 3; init=:random)  # reuses input data
        jldsave(umapfile, e2=U2.embedding, e3=U3.embedding)
    end
end

if !isinteractive()
    main()
end
