using Pkg
using TOML
using URIs: escapeuri


"""
    create_depgraph_img(pkgname, fmt = :png, output_dir = ".")

Render the dependency graph of `pkgname` as an image in `output_dir`. Uses  the external
program `dot` (https://graphviz.org/), which must be available on `PATH`.

`fmt` is an output file format supported by `dot`, such as `svg` or `png`.

The `pkgname` package must be installed in the currently active project.
"""
function create_depgraph_img(pkgname, fmt = :png, output_dir = ".")
    if !is_dot_available()
        error("`dot` program not found on `PATH`. Get it at https://graphviz.org/download/")
    end
    DOT_str = deps_as_DOT(pkgname)
    fname = "$pkgname-deps.$fmt"
    create_DOT_image(DOT_str, fmt, output_dir, fname)
end


default_online_renderer::String = "https://dreampuf.github.io/GraphvizOnline/#"
"""
    copy_depgraph_url(pkgname; kw...)

Copy a URL to the clipboard at which the dependency graph of `pkgname` is rendered as an
image, using an online Graphviz rendering sevice. The `pkgname` package must be installed in
the currently active project.

## How it works

The dependency graph is rendered as a Graphviz DOT string. This string is URL-encoded, and
appended to a partly-complete URL that is specified by the `renderer` keyword argument. By
default, this is the global '`default_online_renderer`' (https://dreampuf.github.io/GraphvizOnline/#).
Some other options:
- https://edotor.net/?engine=dot#
- http://magjac.com/graphviz-visual-editor/?dot=
"""
function copy_depgraph_url(pkgname; renderer = default_online_renderer)
    DOT_str = deps_as_DOT(pkgname)
    url = renderer * escapeuri(DOT_str)
    clipboard(url)
    printstyled("Copied to clipboard: ", color=:green)
    println(trunc(url, 60))
    printstyled("This link contains the following Graphviz DOT string: \n", color=:green)
    print(DOT_str)
    printstyled("Paste it in the browser to visualize the dependency graph.", color=:green)
    return url
end
function trunc(x::String, nstart, ntail = 0; ellipsis = "…(truncated)")
    max_len = nstart + length(ellipsis) + ntail
    if length(x) > max_len
        return x[1:nstart] * ellipsis * x[end-ntail+1:end]
    else
        return x
    end
end

"""
    deps_as_DOT(pkgname)

Render the dependency graph of `pkgname` as a Graphviz DOT string.

Example output, for `"Unitful"`:
```
digraph {
    OpenBLAS_jll -> CompilerSupportLibraries_jll
    ConstructionBase -> LinearAlgebra
    LinearAlgebra -> Libdl
    libblastrampoline_jll -> Libdl
    Unitful -> LinearAlgebra
    CompilerSupportLibraries_jll -> Artifacts
    Unitful -> Dates
    Random -> SHA
    OpenBLAS_jll -> Artifacts
    LinearAlgebra -> libblastrampoline_jll
    CompilerSupportLibraries_jll -> Libdl
    Unitful -> ConstructionBase
    Unitful -> Random
    Dates -> Printf
    Printf -> Unicode
    libblastrampoline_jll -> Artifacts
    libblastrampoline_jll -> OpenBLAS_jll
    OpenBLAS_jll -> Libdl
    Random -> Serialization
}
```
"""
deps_as_DOT(pkgname) = depgraph(pkgname) |> to_DOT_str


"""
    deps = depgraph(pkgname)

Build a graph of the dependencies of the given package, which must be installed in the
currently active project.

The returned `deps` object is a flat list of `"PkgA" => "PkgB"` dependency pairs.
"""
function depgraph(pkgname)
    pkgname = string(pkgname)
    curproj = Pkg.project()
    manif = replace(curproj.path, "Project.toml" => "Manifest.toml")
    root = TOML.parsefile(manif)
    rd = root["deps"]
    if pkgname ∉ keys(rd)
        error("""
        The given package ($pkgname) must be installed in the active project
        (which is currently `$(curproj.path)`)""")
    end
    direct_deps(pkgname) = get(only(rd[pkgname]), "deps", nothing)
    deps = _collect_deps(pkgname, direct_deps)
    return deps
end
function _collect_deps(pkgname, get_direct_deps, deps = Set())
    direct_deps = get_direct_deps(pkgname)
    if !isnothing(direct_deps)
        for ddep in direct_deps
            push!(deps, pkgname => ddep)
            _collect_deps(ddep, get_direct_deps, deps)
        end
    end
    return deps
end

"""
    to_DOT_str(edges)

Build a string that represents the given directed graph in the Graphviz DOT format [1].

[1]: https://graphviz.org/doc/info/lang.html

## Example:

```jldoctest
julia> edges = [:A => :B, "yes" => "no"];

julia> to_DOT_str(edges) |> println;
digraph {
    A -> B
    yes -> no
}
```
"""
function to_DOT_str(edges)
    lines = ["digraph {"]  # DIrected graph
    for (m, n) in edges
        push!(lines, "    $m -> $n")
    end
    push!(lines, "}\n")
    return join(lines, "\n")
end

function is_dot_available()
    if Sys.iswindows()
        cmd = `where dot`
    else
        cmd = `which dot`
    end
    proc = run(cmd, wait = false)
    return success(proc)
end

function create_DOT_image(DOT_str, fmt, dir, fname)
    dotfile = tempname()
    write(dotfile, DOT_str)
    imgfile = joinpath(abspath(dir), fname)
    run(`dot -T$fmt -o$imgfile $dotfile`)
    println("Created ", relpath(imgfile))
end
