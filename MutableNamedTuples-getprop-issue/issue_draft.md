Not an actual issue, I was just wondering about this implementation:
https://github.com/MasonProtter/MutableNamedTuples.jl/blob/6ff8156/src/MutableNamedTuples.jl#L27

why create a NamedTuple of _all_ values (instead of getting just the one) ?

(the implementation seems to expand to something like
```julia
function Base.getproperty(mnt::MutableNamedTuple{names}, s::Symbol) where names
	values = getindex.(values(getfield(mnt, :nt)))
	nt = NamedTuple{names}(values)
	getproperty(nt, s)
end
````
)

Super interesting repo btw
I'm working on something similar, namely a `NamedVector` (basically like a `ComponentArray`, but simpler).
