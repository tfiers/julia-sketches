using REPL.TerminalMenus
using Base: prompt
using Crayons

# To continue:
# - make proper newpkg
# - open editor:
#   - separate func
#   - open dir and two files in one code.cmd call [see roam ((C8qOXEev4))]


const jldir = joinpath(homedir(), ".julia")
# ↪ More 'proper' way for same thing: `first(Base.DEPOT_PATH)`
#   https://docs.julialang.org/en/v1/base/constants/#Base.DEPOT_PATH
#   "The first entry is the user depot".

const sketches_dir = joinpath(jldir, "sketches")

const green = Crayon(foreground = :green)


"""
Create a new 'sketch', or open an existing one. A sketch is a julia script plus project: for
when you want more than just the repl but less than a package.
"""
function sketch(is_first_call = false)
    if is_first_call
        println("done")  # = completion of line printed in `@sk` in startup.jl.
    end
    name = select_sketch()
    if isnothing(name)
        return
    else
        open_sketch(name)
    end
end

function select_sketch()
    mkpath(sketches_dir)
    cd(sketches_dir)
	names = readdir()
    sketchdirs = [name for name in names
        if isdir(name)
            && first(name) !== '.'  # filter .git/ and .vscode/
    ]
    new = "[new sketch]"
    options = [new; sketchdirs]
    menu = RadioMenu(options)
    choice = request("Select sketch to open:\n", menu)
    println()
    if choice == -1  # User quit (`q` or ctrl-c)
        return nothing
    end
    selection = options[choice]
    if selection == new
        sketchname = prompt("Name of new sketch")
    else
        sketchname = selection
    end
    return sketchname
end

function open_sketch(name)
    println("Opening `", (name), "`\n")
    mkpath(sketches_dir)
    cd(sketches_dir)
    mkpath(name)
    cd(name)
    println("  ", ("Changing"), " current directory to and")
    Pkg.activate(".")  # "  Activating new project at …"
    println()
    script = "main.jl"
    if !isfile(script)
        contents = """
        # To run, yank the following to the repl
        include(\"$script\")
        """
        write(script, contents)
    end
    choice = prompt("Open editor? [y]/n")
    if choice != "n"
        edit(sketches_dir)  # Open vs code in sketches root: git repo is there.
        edit(script)
        # Open repl history, so you can copy paste from it.
        replhist = joinpath(jldir, "logs", "repl_history.jl")
        # ↪ More proper way: REPL.find_hist_file()
        #   (https://docs.julialang.org/en/v1/manual/environment-variables/#JULIA_HISTORY)
        lastline = countlines(replhist)
        edit(replhist, lastline)
    end
end
