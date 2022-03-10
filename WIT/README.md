# Visualizing and navigating the WIT dataset

The dataset is composed of more than 300K Clip embeddings that capture visual and language semantics.

Run using Pluto, use as many threads/cores you have to speed up computations.

## Usage:
Install the [Julia](https://julialang.org/downloads/) language (recommended v1.6 or later). Also install the Pluto notebook (lastest version)



```
julia> ] add Pluto

julia> using Pluto
```


Run the notebook with all available cores in your computer (perhaps 2x if your system supports hyperthreading)
```
julia> Pluto.run(notebook="wit-demo.jl", threads=64)  
```

The demostration retrieves a sample dataset and the Clip embeddings, please be calm while these files are retrieved.

Use the notebook, test and change the code as you wish. Happy searches!


