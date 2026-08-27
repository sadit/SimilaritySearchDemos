#!/usr/bin/env julia
# generate_wiki_embeddings.jl
#
# Genera LSI word embeddings desde los perfiles de Wikipedia ES/EN ya entrenados.
# Toma los primeros 3 párrafos por artículo, re-entrena un LSI 256d sobre ese subconjunto,
# extrae word vectors y los guarda en:
#   - formato GloVe texto (.txt): "word f1 f2 ... fd\n"
#   - query expansion network en JSON
#
# Uso (desde el directorio SimilaritySearchDemos/):
#   julia -t auto --project=. generate_wiki_embeddings.jl
#
# Requiere que el Project.toml del demo incluya TextSearch y SimilaritySearch.

using TextSearch
using TextSearch.LSI: LatentSemanticIndexing, wordvectors, query_expansion
using SimilaritySearch
using JSON3
using ProgressMeter
using LinearAlgebra

# ─── configuración ────────────────────────────────────────────────────────────

const CORPUS_DIR = joinpath(@__DIR__, "..", "TextSearch.jl", "corpus-profiles", "work", "wikipedia")
const PROFILE_DIR = joinpath(@__DIR__, "..", "TextSearch.jl", "corpus-profiles", "profiles")
const OUT_DIR = joinpath(@__DIR__, "demos", "data")

const MAX_PARAGRAPHS_PER_ARTICLE = 3   # primeros N párrafos por artículo
const LSI_DIM = 256                    # dimensión del embedding
const QUERY_EXPANSION_K = 8            # vecinos en la red de sinónimos

mkpath(OUT_DIR)

# ─── helpers ──────────────────────────────────────────────────────────────────

"""
Lee el corpus JSONL y devuelve sólo los primeros `n` párrafos por artículo.
Cada línea tiene: {"id", "paragraph", "title", "text", "url"}
"""
function load_corpus_first_n_paragraphs(jsonl_path::String, n::Int)
    texts  = String[]
    ids    = String[]
    titles = String[]
    counts = Dict{String,Int}()
    total  = 0

    open(jsonl_path) do f
        for line in eachline(f)
            isempty(strip(line)) && continue
            obj = JSON3.read(line)
            article_id = String(obj.id)

            cnt = get(counts, article_id, 0)
            cnt >= n && continue
            counts[article_id] = cnt + 1

            push!(texts,  String(obj.text))
            push!(ids,    article_id)
            push!(titles, String(obj.title))
            total += 1
            iszero(total % 100_000) && @info "  read $total paragraphs, $(length(counts)) articles..."
        end
    end
    @info "Loaded $(length(texts)) paragraphs from $(length(counts)) articles"
    texts, ids, titles
end

"""
Guarda word vectors en formato texto GloVe:
  "word f1 f2 ... fd"
Una línea por token, skipea tokens con espacios.
"""
function save_glove_format(path::String, wv::Matrix{Float32}, vocab::Vocabulary)
    m = vocsize(vocab)
    @assert size(wv, 2) == m "vocsize mismatch: wv has $(size(wv,2)) cols, vocab has $m tokens"
    dim = size(wv, 1)
    @info "Saving $m word vectors (dim=$dim) to $path"
    skipped = 0
    open(path, "w") do f
        prog = Progress(m; dt=5, desc="Writing GloVe file...")
        for t in 1:m
            tok = gettoken(vocab, t)
            # GloVe format uses space as separator — skip multi-word tokens
            if occursin(' ', tok) || isempty(tok)
                skipped += 1
                continue
            end
            print(f, tok)
            col = view(wv, :, t)
            for v in col
                print(f, ' ')
                print(f, v)
            end
            println(f)
            next!(prog)
        end
    end
    @info "Done: $path  (skipped $skipped tokens with spaces)"
end

# ─── pipeline por idioma ──────────────────────────────────────────────────────

function generate_embeddings(lang::String)
    @info "═══ Processing language: $lang ═══"

    corpus_path = joinpath(CORPUS_DIR, "wiki20231101-$(lang)-paragraphs.jsonl")
    profile_zip = joinpath(PROFILE_DIR, "wiki20231101-$(lang)-paragraphs.zip")
    out_txt     = joinpath(OUT_DIR, "wiki-$(lang)-lsi.txt")
    out_qexp    = joinpath(OUT_DIR, "wiki-$(lang)-qexp.json")

    isfile(corpus_path) || error("Corpus not found: $corpus_path")
    isfile(profile_zip) || error("Profile not found: $profile_zip")

    # 1. Cargar el perfil merged (vocab + weights entrenados sobre todo el corpus)
    @info "Loading merged profile from $profile_zip"
    profile = load_profile(profile_zip)
    voc   = profile.model.voc
    model = profile.model
    @info "  Vocab size: $(vocsize(voc)), train size: $(voc.trainsize)"

    # 2. Leer primeros MAX_PARAGRAPHS_PER_ARTICLE párrafos por artículo
    texts, _, _ = load_corpus_first_n_paragraphs(corpus_path, MAX_PARAGRAPHS_PER_ARTICLE)
    @info "  Corpus subset: $(length(texts)) paragraphs"

    # 3. Entrenar LSI sobre este subconjunto
    # Usamos el modelo del perfil (vocab + pesos IDF del corpus completo) pero
    # el SVD se calcula sobre los primeros 3 párrafos por artículo — dando
    # mayor peso al contenido introductorio de cada artículo.
    @info "  Training LSI (dim=$LSI_DIM) on corpus subset..."
    lsi = @time LatentSemanticIndexing(model, texts;
        maxoutdim    = LSI_DIM,
        scaling      = :none,
        verbose      = true,
        factorization = :auto,
    )
    @info "  LSI trained: k=$(lsi.k)"

    # 4. Extraer word vectors (dim × vocsize), normalizados por columna
    @info "  Extracting word vectors..."
    wv_db = wordvectors(lsi; normalize=true)
    wv    = wv_db.matrix   # Matrix{Float32}(dim, vocsize)

    # 5. Guardar en formato GloVe texto
    save_glove_format(out_txt, wv, voc)

    # 6. Generar red de query expansion (sinónimos semánticos)
    @info "  Building query expansion network (k=$QUERY_EXPANSION_K)..."
    net = @time query_expansion(lsi, QUERY_EXPANSION_K;
        verbose             = true,
        approx              = :auto,
        construction_recall = 0.97,
        search_recall       = 0.9,
        head_df             = 0.05,
        max_target_ratio    = 50.0,
    )
    open(out_qexp, "w") do f
        JSON3.write(f, Dict(
            "query_expansion" => net.query_expansion,
            "distances"       => net.distances,
        ))
    end
    @info "  Query expansion saved: $out_qexp  ($(length(net.query_expansion)) tokens)"

    @info "═══ Done: $lang ═══\n"
    (; lsi, net, voc, wv)
end

# ─── main ─────────────────────────────────────────────────────────────────────

println("Julia threads: $(Threads.nthreads())")
println("Output directory: $OUT_DIR")

for lang in ("es", "en")
    generate_embeddings(lang)
end

@info "All embeddings generated:"
for f in sort(readdir(OUT_DIR, join=true))
    sz = round(filesize(f)/1e6, digits=1)
    @info "  $(basename(f))  $sz MB"
end
