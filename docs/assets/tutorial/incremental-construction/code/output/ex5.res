SimilaritySearch.SearchGraph{SimilaritySearch.L1Distance, SimilaritySearch.DynamicMatrixDatabase{Float32, 8}, SimilaritySearch.BeamSearch}
  dist: SimilaritySearch.L1Distance SimilaritySearch.L1Distance()
  db: SimilaritySearch.DynamicMatrixDatabase{Float32, 8}
  links: Array{Vector{Int32}}((20000,))
  locks: Array{Base.Threads.SpinLock}((20000,))
  hints: Array{Int32}((96,)) Int32[84, 205, 343, 354, 363, 540, 795, 894, 1003, 1089  …  3366, 3397, 3413, 3423, 3428, 3492, 3500, 3509, 3510, 16363]
  search_algo: SimilaritySearch.BeamSearch
  verbose: Bool false
