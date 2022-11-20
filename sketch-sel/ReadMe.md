
## Setup

In your `startup.jl`, add the following macro:
```julia
macro sk()  # or `sketch()`
    quote
        using Sketches
        sketch()
    end
end
```
With this macro, we only load the package when needed, and thus incur minimal startup time cost.


# Usage

In the Julia REPL, run:
```
julia> @sk
```
..and follow the wizard.

Example:

[..]
