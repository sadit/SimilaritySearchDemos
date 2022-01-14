# Using Glove


This directory contains the Pluto Glove (voc-size=400K, english, input tokens=6B, dim=100) searching demo `navigation.jl` and a UMAP construction demo `visualize-umap.jl`.


Before using both demos you must create the index and the UMAP embeddings running the following script.

```
julia -t64 --project=. create-index-and-umap.jl
```

The embeddings will be downloaded using the Embeddings.jl package. This downloads large datasets, so be patient.
