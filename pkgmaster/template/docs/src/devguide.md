
# Developer Guide


## How to release a new version

1. Roll-over the [changelog](Changelog.md): rename the existing 'Unreleased'
   section to the new version. Add a new, empty Unreleased section.
   <!-- Could be automated prolly; add a step in Register.yml -->
2. Click the _Run workflow_ button [here][regCI], and bump the relevant version
   component. This will 1) create a commit that updates the version in `Project.toml`,
   and 2) create a comment on that commit that opens a PR in the General registry.

[regCI]: https://github.com/tfiers/{{{PKG}}}.jl/actions/workflows/Register.yml
