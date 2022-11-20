using REPL.TerminalMenus

options = []
menu = RadioMenu(options)
choice = request(menu)


"""
    @sketch "wack-idea"

Create a new 'sketch', or open an existing one. A sketch is a julia script plus project: for
when you want more than just the repl but less than a package.
"""
macro sketch(name)
    print("Working on it … ")
    @assert typeof(name) ∈ [String, Symbol]
    :( _sketch($(string(name))) )
end

function _sketch(sketch_name::String)
    sketches_dir = joinpath(homedir(), ".julia", "sketches")
    mkpath(sketches_dir)
    cd(sketches_dir)
    edit(".")  # Open vs code in sketches root: git repo is there.
    mkpath(sketch_name)
    cd(sketch_name)
    println("ok")
    printstyled("  Changing", color = :green)
    println(" current directory to, and")
    Pkg.activate(".")  # "  Activating new project at …"
    script = "main.jl"
    touch(script)
    edit(script)
    include_str = "include(\"$script\")"
    clipboard(include_str)  # To paste in repl
    print("  `")
    printstyled(include_str, color = :green)
    println("` written to clipboard")
end
