
using MutableNamedTuples

# in mnt src:
# Base.getproperty(mnt::MutableNamedTuple, s::Symbol) =
#   getproperty(NamedTuple(mnt), s)
#
# Which seems to expand to sth like
getp(mnt::MutableNamedTuple{names}, s::Symbol) where names = begin
    vals = getindex.(values(getfield(mnt, :nt)))
    nt = NamedTuple{names}(vals)
    getproperty(nt, s)
end

# `getindex(x) = x[]`  :)

# So why construct the whole nt, and not this:
getp1(mnt::MutableNamedTuple, s::Symbol) = begin
    nt = getfield(mnt, :nt)
    getproperty(nt, s)[]
end

mnt = MutableNamedTuple(a = 3, b = "")
@assert mnt.a == getp(mnt, :a) == getp1(mnt, :a)

using BenchmarkTools
                              # [mean and stddev, in ns]
# @benchmark mnt.a            # 69.1  ± 42.7
# @benchmark getp(mnt, :a)    # 71.9  ± 42.5
# @benchmark getp1(mnt, :a)   # 71.9  ± 40.9

# @benchmark $mnt.a           #  3.34 ±  1.01
# @benchmark getp($mnt, :a)   #  4.64 ±  2.57
# @benchmark getp1($mnt, :a)  #  3.49 ±  4.38


# include("random_data_of_random_type.jl")
# @benchmark mnt.a setup=(mnt=randmnt())
