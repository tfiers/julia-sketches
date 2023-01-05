
# {{{PKG}}}.jl &nbsp;[![][docbadge]][docs] [![][chlog-img]][chlog] [![][devimg]](#development)
<!-- prepend `[![][latestimg]][latest]` when first release is tagged  -->

[latestimg]: https://img.shields.io/github/v/release/tfiers/{{{PKG}}}.jl?label=Latest%20release
[latest]:    https://github.com/tfiers/{{{PKG}}}.jl/releases/latest

[docbadge]: https://img.shields.io/badge/📕_Documentation-blue
[docs]: https://tfiers.github.io/{{{PKG}}}.jl/

[chlog-img]: https://img.shields.io/badge/🕑_Changelog-gray
[chlog]: Changelog.md

[devimg]: https://img.shields.io/badge/⚒️_Development-gray

…


<br>

## Installation

<!-- 1 -->
{{{PKG}}} is not registered, but can be installed by directly specifying a URL.
See [Development](#development) below.


<!-- 2 --
The PR to add {{{PKG}}} to the Julia general registry ([link](prrrr))
is not merged yet at the time of writing. When that is done, you'll be able to
```
pkg> add {{{PKG}}}
```
In the meantime, you can install by specifying a URL directly.
See [Development](#development) below.
--------->


<!-- 3 --
{{{PKG}}} is available in the Julia general registry and can be installed [as usual] with
```
pkg> add {{{PKG}}}
```
[as usual]: https://pkgdocs.julialang.org/v1/getting-started
--------->


<br>

## Development

### Unreleased Changes &nbsp;<sub>[![][commitsimg]][latest] [![][devdocs-img]][devdocs]</sub>

For the latest commit on `main` (aka _dev_ and _unstable_):

| CI status | <sub>[![][testsimg]][tests]</sub> | <sub>[![][docbuildimg]][docbuild]</sub> |
|-----------|-----------------------------------|-----------------------------------------|

You can install `{{{PKG}}}` at this latest commit using
```
pkg> add https://github.com/tfiers/{{{PKG}}}.jl
```
It might be a good idea to install at a fixed revision instead.
Preferably at a [commit that passed tests][testhist].
For example:
```
pkg> add https://github.com/tfiers/{{{PKG}}}.jl#{commit-hash}
```

[testhist]: https://github.com/tfiers/{{{PKG}}}.jl/actions/workflows/Tests.yml

[commitsimg]:  https://img.shields.io/github/commits-since/tfiers/{{{PKG}}}.jl/latest
<!-- The link, 'latest', is defined above. -->

[devdocs-img]: https://img.shields.io/badge/📕_Documentation-dev-blue.svg
[devdocs]:     https://tfiers.github.io/{{{PKG}}}.jl/dev

[docbuildimg]: https://github.com/tfiers/{{{PKG}}}.jl/actions/workflows/DocBuild.yml/badge.svg
[docbuild]:    https://github.com/tfiers/{{{PKG}}}.jl/actions/workflows/DocBuild.yml

[testsimg]:    https://github.com/tfiers/{{{PKG}}}.jl/actions/workflows/Tests.yml/badge.svg
[tests]:       https://github.com/tfiers/{{{PKG}}}.jl/actions/workflows/Tests.yml


### Roadmap

No progress guaranteed, _"Software provided 'as is'"_, etc.\
Ideas for improvement are currently managed with GitHub Issues.

<!-- For next release: <sub>[![][mile-img]][milestone]</sub>

[mile-img]: https://img.shields.io/github/milestones/progress/tfiers/{{{PKG}}}.jl/1?label=Milestone%20issues%20closed
[milestone]: https://github.com/tfiers/{{{PKG}}}.jl/milestone/1 -->


### Contributions

Well-considered PRs, Issues, and Discussions are welcome.

Everyone is expected to adhere to the standards for constructive communication
described in [this Code of Conduct][CoC].

[CoC]: https://github.com/comob-project/snn-sound-localization/blob/17279f6/Code-of-Conduct.md


### How to

Check out the code for development using
```
pkg> dev {{{PKG}}}
```
See the readmes [in `test/`](test/ReadMe.md) and [in `docs/`](docs/ReadMe.md)
for how to locally run the tests and build the documentation.

See the [Developer Guide][1] in the documentation for more.

[1]: https://tfiers.github.io/{{{PKG}}}.jl/dev/devguide
