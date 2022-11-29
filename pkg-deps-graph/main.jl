using Pkg
using TOML
using URIs: escapeuri
using Crayons

const green = Crayon(foreground = :green)


"""
    depsimg(pkgname, fmt = :png, output_dir = ".")

Render the dependency graph of the given package as an image in `output_dir`. Uses the
external program '`dot`' (https://graphviz.org/), which must be available on `PATH`.

`fmt` is an output file format supported by dot, such as svg or png.

The given package must be installed in the currently active project.
"""
function depsimg(pkgname, fmt = :png, output_dir = ".")
    if !is_dot_available()
        error("`dot` program not found on `PATH`. Get it at https://graphviz.org/download/")
    end
    DOT_str = deps_as_DOT(pkgname)
    fname = "$pkgname-deps.$fmt"
    create_DOT_image(DOT_str, fmt, output_dir, fname)
end


online_renderer::String = "https://dreampuf.github.io/GraphvizOnline/#"
"""
    depsurl(pkgname; kw...)

Copy a URL to the clipboard at which the dependency graph of `pkgname` is rendered as an
image, using an online Graphviz rendering sevice. The given package must be installed in the
currently active project.

## How it works

The dependency graph is rendered as a Graphviz DOT string. This string is URL-encoded, and
appended to a partly-complete URL that is specified by the `renderer` keyword argument.
Some options:
- https://dreampuf.github.io/GraphvizOnline/#  (default)
- https://edotor.net/?engine=dot#
- http://magjac.com/graphviz-visual-editor/?dot=

The default can be changed by setting the mutable global '`online_renderer`'.
"""
function depsurl(pkgname; renderer = online_renderer)
    DOT_str = deps_as_DOT(pkgname)
    url = renderer * escapeuri(DOT_str)
    clipboard(url)
    println(green("Copied to clipboard: "), trunc(url, 60))
    println(green("This link contains the following Graphviz DOT string:"))
    print(DOT_str)
    println(green("Paste it in the browser to visualize the dependency graph."))
    return url
end
trunc(str, n; ellipsis = "…(truncated)") =
    if (length(str) > n + length(ellipsis))  str[1:n] * green(ellipsis)
    else                                     str
    end

"""
    deps_as_DOT(pkgname)

Render the dependency graph of `pkgname` as a Graphviz DOT string.

Example output (truncated), for `"Unitful"`:
```
digraph {
    Unitful -> ConstructionBase
    ConstructionBase -> LinearAlgebra
    LinearAlgebra -> Libdl
    ⋮
    Unitful -> Random
    Random -> SHA
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
    rootpkg = string(pkgname)
    curproj = Pkg.project()
    mpath = replace(curproj.path, "Project.toml" => "Manifest.toml")
    manif = TOML.parsefile(mpath)
    packages = manif["deps"]
    if rootpkg ∉ keys(packages)
        error("""
        The given package ($pkgname) must be installed in the active project
        (which is currently `$(curproj.path)`)""")
    end
    deps = []
    function add_deps_of(name)
        pkg_info = only(packages[name])  # Two packages with same name not supported.
        direct_deps = get(pkg_info, "deps", [])
        for dep in direct_deps
            push!(deps, name => dep)
            add_deps_of(dep)
        end
    end
    add_deps_of(rootpkg)
    return unique!(deps)  # Could use a SortedSet instead; but this spares a pkg load.
end


"""
    to_DOT_str(edges)

Build a string that represents the given directed graph in the Graphviz DOT format
(https://graphviz.org/doc/info/lang.html).

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
