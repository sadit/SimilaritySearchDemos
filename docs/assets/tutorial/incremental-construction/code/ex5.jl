# This file was generated, do not modify it. # hide
for _ in 1:10^4
    push_item!(G, rand(Float32, dim))  # push_item! inserts one item at a time
end

append_items!(G, MatrixDatabase(rand(Float32, dim, 10^4))) # append_items! inserts many items at once