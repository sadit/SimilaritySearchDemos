# Navigating the WIT dataset

The dataset is composed of more than 300K embeddings for the (URL)[WIT dataset] that capture visual and language semantics of several wikipedia articles.

## Demonstrations
`search.jl`

We use the Spanish sample of WIT to demostrate a search on it using the Pluto notebook. 

`visualize-umap.jl`

Pluto notebook to visualize the output of UMAP (UMAP's input is an all-knn graph created with SimilaritySearch.jl)

Both scripts need to run first the script `create-index-and-umap.jl` that creates the index and also projects the dataset into 2d and 3d using UMAP.

An static version is [here](https://raw.githubusercontent.com/sadit/SimilaritySearchDemos/main/WIT/search.jl-WIT.html)
(Note: running at binder will not work since it needs the precomputed models)



```bash

julia -t64 --project=.. create-index-and-umap.jl
```

## Usage:
Install the [Julia](https://julialang.org/downloads/) language (recommended v1.6 or later) and also install the Pluto notebook (lastest version)



```
julia> ] add Pluto

...

julia> using Pluto
...
julia> Pluto.run()
```

If you use Julia v1.7 then the first instruction is not necessary. The demostration need to retrieve the dataset and the embeddings, so please start and be calm while these files are retrieved.

Use the notebook, test and change the code as you wish. Happy searches!


