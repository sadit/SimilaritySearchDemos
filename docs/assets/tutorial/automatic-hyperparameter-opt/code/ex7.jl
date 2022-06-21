# This file was generated, do not modify it. # hide
G2 = SearchGraph(; dist, db=MatrixDatabase(X), verbose)
callbacks2 = SearchGraphCallbacks(ParetoRadius())  # it uses distances instead of recall, it will be faster but lower quality
@elapsed index!(G2; callbacks=callbacks2)