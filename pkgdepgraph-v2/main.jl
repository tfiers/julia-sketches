
using Pkg

reg = Pkg.Registry.reachable_registries()[1]  # (first, and only, for me. the General)
pkgentry = values(reg.pkgs)[1]
p = Pkg.Registry.init_package_info!(pkgentry)

p.repo  # → https github url, to make svg dot nodes clickable :)
# in tooltip of svg dot nodes could go version or sth, mayb
p.deps  # weird format: map of versionrange (of what?) => set of deps (organized as name=>UUID map)
p.version_info  # useful ye. `first(keys(_))` is latest version i suppose


# And, add some styling:

# node [fontname = "sans-serif"]
# edge [arrowsize = 0.88]
# CompilerSupportLibraries_jll [fontsize = 10]
# libblastrampoline_jll [fontsize = 12]
# ConstructionBase [fontsize = 13]

# It works, the multi font sizes.
# Maybe an actual interpolation? From 14 (default fontsize) to 9 or sth, w/ len as input. Or
# would it be too unsettling, all the sizes (and so, rather we'd have only say three sizes).
