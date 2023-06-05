
- Update anything you want directly on .md or .jl
- run on the Julia REPL

```julia
using Franklin
optimize()
```

- do git commit and push

Note 1: Franklin stores the rendered web site in the `__site` directory, and github pages wants the web site from repo's `/docs/` directory. So, just link `__site` to `../docs`

Note 2: Time to time is necessary to perform a full run, just run `optimize(clean=true)`, the `__site` link will be removed, and then we need to create the link again.
