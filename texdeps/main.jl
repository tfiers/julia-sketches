
# Run `latexmk` in Windows Terminal.
# Right click on tab title, "Export Text".
# Save here, as:
termlog = "termlog.txt"

# Will output:
outfile = "formatted.sh"
# We chose .sh so that VS Code syntax highlights the brackets nicely.
# See also `../.vscode/settings.json`, where bracket colours and guides are added for .sh.


# ---------------------------------------------------------------------------------------


# Extract relevant part of stdout
lines = readlines(termlog)
before = findlast(startswith("entering extended mode"), lines)
after  = findlast(startswith("Output written on "), lines)
stream = join(lines[before+1:after-1], "\n")

# Some ad-hoc preprocessing
stream = replace(stream,
    "c:/TinyTeX/texmf-dist/tex/" => "",
    "\r\n" => "\n",
        # Normalize line endings
    "`" => "'",
        # To not break "Shell script" syntax highlighting.
)
brackets = ["()", "[]", "{}", "<>"]
openers = [b[1] for b in brackets]
closers = [b[2] for b in brackets]
specialchars = [openers; closers; '\n']

# We put in function instead of just
# `open(outfile, "w") do f …`
# so that we can use Debugger.jl.
function write_formatted(f::IO)
    level = 0
    enter() = print(f, '\n', "    "^level)
    i = firstindex(stream)
    while i ≤ lastindex(stream)
        # Collect all text until we encounter a special character.
        # (The special character will then be at index `i`).
        start = i
        while stream[i] ∉ specialchars
            i = nextind(stream, i)
            if i > lastindex(stream)
                break
            end
        end
        last = prevind(stream, i)
        print(f, stream[start:last])
        if last == lastindex(stream)
            break
        end

        # We've encountered a special character.
        #   Here, we can use `+= 1` instead of `nextind` etc, as we know the
        #   special characters we're dealing with are one codepoint wide.
        c = stream[i]
        if c == '\n'
            enter()
        elseif c in openers
            if (i > 1) && (stream[i - 1] != '\n')
                enter()
            end
            print(f, c)
            level += 1
        elseif c in closers
            level -= 1
            # Find last non-space character
            prev = findprev(!isequal(' '), stream, i - 1)
            if stream[prev] in closers
                enter()
            end
            print(f, c)
        end
        i += 1
    end
end

open(write_formatted, outfile, "w")
