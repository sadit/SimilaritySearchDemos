SimilaritySearch.SearchGraph{SimilaritySearch.L2Distance, SimilaritySearch.MatrixDatabase{Matrix{Float64}}, SimilaritySearch.BeamSearch}
  dist: SimilaritySearch.L2Distance SimilaritySearch.L2Distance()
  db: SimilaritySearch.MatrixDatabase{Matrix{Float64}}
  links: Array{Vector{Int32}}((100000,))
  locks: Array{Base.Threads.SpinLock}((100000,))
  hints: Array{Int32}((117,)) Int32[1189, 1498, 1510, 1792, 2266, 2454, 2591, 2786, 2795, 3004  …  6913, 6914, 6997, 7101, 7116, 7123, 7239, 7274, 7296, 7316]
  search_algo: SimilaritySearch.BeamSearch
  neighborhood: SimilaritySearch.Neighborhood
  verbose: Bool true
