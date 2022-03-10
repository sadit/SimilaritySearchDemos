
# Visualizing and navigating the MNIST dataset

The dataset is composed of 60K 28x28 hand-written digits in gray scale. This demonstration will generate UMAP visualizations and will let you search for similarity of digits.

Run using Pluto, use as many threads/cores you have to speed up computations.

## Usage:
Install the [Julia](https://julialang.org/downloads/) language (recommended v1.6 or later). Also install the Pluto notebook (lastest version)


```
julia> ] add Pluto

julia> using Pluto
```


Run the notebook with all available cores in your computer (perhaps 2x if your system supports hyperthreading)
```
julia> Pluto.run(notebook="mnist-demo.jl", threads=64)  
```

The demostration retrieves the MNIST dataset, please be calm while these files are retrieved, you may also be asked to accept MNIST terms and conditions before downloading. 

Use the notebook, test and change the code as you wish. Happy searches!



