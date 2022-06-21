SimilaritySearch.SearchGraph{SimilaritySearch.L2Distance, SimilaritySearch.MatrixDatabase{Matrix{Float64}}, SimilaritySearch.BeamSearch}
  dist: SimilaritySearch.L2Distance SimilaritySearch.L2Distance()
  db: SimilaritySearch.MatrixDatabase{Matrix{Float64}}
  links: Array{Vector{Int32}}((100000,))
  locks: Array{Base.Threads.SpinLock}((100000,))
  hints: Array{Int32}((115,)) Int32[763, 1066, 1174, 1758, 2438, 2449, 2555, 2712, 2775, 2845  …  6772, 6774, 6855, 6883, 6887, 7013, 7060, 7106, 7111, 83576]
  search_algo: SimilaritySearch.BeamSearch
  verbose: Bool false
