using Pkg
using TOML

"""
    depgraph(pkgname, fmt = :png, output_dir = ".")

Build a graph of the dependencies of the given package, which must be installed in the
currently active project. Render this graph in the Graphviz DOT format, and output it as an
image in `output_dir`, using the `dot` program. If this program is not found, copies the DOT
string to the clipboard so that it can be rendered using an online Graphviz service (like
https://dreampuf.github.io/GraphvizOnline/).

`fmt` is an output file formatted supported by `dot`, like `svg` or `png`.
"""
function depgraph(pkgname, fmt = :png, output_dir = ".")
    pkgname = string(pkgname)
    curproj = Pkg.project()
    manif = replace(curproj.path, "Project.toml" => "Manifest.toml")
    root = TOML.parsefile(manif)
    d = root["deps"]
    if pkgname ∉ keys(d)
        @error """
            The given package ($pkgname) must be installed in the active project
            (which is currently `$(curproj.path)`)"""
        return
    end
    deps = get_deps(pkgname, d)
    dot_str = graphviz_DOT_str(deps)
    if is_dot_available()
        in = tempname()
        write(in, dot_str)
        out = joinpath(abspath(output_dir), "$pkgname-deps.$fmt")
        run(`dot -T$fmt -o$out $in`)
        relpath
        println("Created ", relpath(out))
    else
        println("`dot` program not found.")
        println("Copying to clipboard: \n")
        println(dot_str)
        clipboard(dot_str)
    end
end
function get_deps(pkgname, d, deps = Set())
    ddeps = get_direct_deps(pkgname, d)
    if !isnothing(ddeps)
        for ddep in ddeps
            push!(deps, pkgname => ddep)
            get_deps(ddep, d, deps)
        end
    end
    return deps
end
get_direct_deps(pkgname, d) = get(only(d[pkgname]), "deps", nothing)

function graphviz_DOT_str(edges)
    lines = ["digraph {"]  # DIrected graph
    for (m, n) in edges
        push!(lines, "   $m -> $n")
    end
    push!(lines, "}")
    return join(lines, "\n")
end
function is_dot_available()
    try
        run(pipeline(`dot -\?`, devnull))
        return true
    catch
        return false
    end
end
