
using Pkg

reg = Pkg.Registry.reachable_registries()[1]  # (first, and only, for me. the General)
pkgentry = values(reg.pkgs)[1]
p = Pkg.Registry.init_package_info!(pkgentry)

p.repo  # → https github url, to make svg dot nodes clickable :)
# in tooltip of svg dot nodes could go version or sth, mayb
p.deps  # weird format: map of versionrange (of what?) => set of deps (organized as name=>UUID map)
p.version_info  # useful ye. `first(keys(_))` is latest version i suppose
