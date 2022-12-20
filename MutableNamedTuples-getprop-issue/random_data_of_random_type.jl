# Is this called "fuzzing"?
# I'm not using it for testing
# rather, for generating data to benchmark with

function randmnt()
    # …
end

types = [UInt, Float32, String]
T = rand(types)

@assert sizeof(Char) == 4 # in bytes

4 * 8 #= bits/bytes =# = 32

reinterpret(Char, rand(UInt32))
# '+���': Unicode U+002B (category Sm: Symbol, math)

reinterpret(Char, rand(UInt32))
# '\x10\xf2\xbd\xf9': Malformed UTF-8 (category Ma: Malformed, bad data)

reinterpret(String, rand())
# ERROR: bitcast: target type not a leaf primitive type


# No reinterpret necessary mayb:
# just do rand(Char).
# and if composite, recurse on fields.
