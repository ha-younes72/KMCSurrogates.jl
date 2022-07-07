using KMCSurrogates
using Documenter

DocMeta.setdocmeta!(KMCSurrogates, :DocTestSetup, :(using KMCSurrogates); recursive=true)

makedocs(;
    modules=[KMCSurrogates],
    authors="Younes Hassani Abdollahi",
    repo="https://github.com/ha-younes72/KMCSurrogates.jl/blob/{commit}{path}#{line}",
    sitename="KMCSurrogates.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://ha-younes72.github.io/KMCSurrogates.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/ha-younes72/KMCSurrogates.jl",
    devbranch="main",
)
