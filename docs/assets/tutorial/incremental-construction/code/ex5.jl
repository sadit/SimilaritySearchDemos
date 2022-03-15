# This file was generated, do not modify it. # hide
for _ in 1:10^4
    push!(G, rand(Float32, dim))  # push! inserts one item at a time
end

append!(G, MatrixDatabase(rand(Float32, dim, 10^4))) # append! inserts many items at once