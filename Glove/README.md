# Visualizing and navigating Glove word embeddings

Global vectors (Glove) is a kind of word embedding (a method that captures distributional semantics of words using a very large corpus as input).
In brief, it takes the vocabulary of a large collection of documents and computes a high-dimensional vector for each word in the vocabular such that two words having similar semantic in the corpus will imply being close in the vector space.
It is described in detail in the original manuscript:

> Pennington, J., Socher, R., & Manning, C. D. (2014, October). Glove: Global vectors for word representation. In Proceedings of the 2014 conference on empirical methods in natural language processing (EMNLP) (pp. 1532-1543).

## Demonstration
This directory contains the Pluto notebook `glove-demo.jl`.


Run using Pluto, use as many threads/cores you have to speed up computations.

### Usage:
Install the [Julia](https://julialang.org/downloads/) language (recommended v1.6 or later). Also install the Pluto notebook (lastest version)



```
julia> ] add Pluto

julia> using Pluto
```


Run the notebook with all available cores in your computer (perhaps 2x if your system supports hyperthreading)
```
julia> Pluto.run(notebook="glove-demo.jl", threads=64)  
```

The demostration retrieves the word embedding, a large matrix (n=400K, d=100) using the `Embeddings.jl` package. Please be calm while these files are retrieved.

Use the notebook, test and change the code as you wish. Happy searches!

