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
    rd = root["deps"]
    if pkgname ∉ keys(rd)
        @error """
        The given package ($pkgname) must be installed in the active project
        (which is currently `$(curproj.path)`)"""
        return
    end
    direct_deps(pkgname) = get(only(rd[pkgname]), "deps", nothing)
    deps = collect_all_deps(pkgname, direct_deps)
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
function collect_all_deps(pkgname, direct_deps, deps = Set())
    ddeps = direct_deps(pkgname)
    if !isnothing(ddeps)
        for ddep in ddeps
            push!(deps, pkgname => ddep)
            collect_all_deps(ddep, direct_deps, deps)
        end
    end
    return deps
end

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
