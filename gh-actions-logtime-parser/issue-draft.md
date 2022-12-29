Just for reference for myself:
current doc build times on GitHub Actions are very slow

[Example Run].
Total workflow time (only `docs/make.jl`, no `test/`): about **24 minutes**.

From log [[lines]]:
```
Thu, 29 Dec 2022 11:21:11 GMT <makedocs> (Including Documenter.HTML(…) construction call)
Thu, 29 Dec 2022 11:21:15 GMT SetupBuildDirectory: setting up build directory.
Thu, 29 Dec 2022 11:29:17 GMT Doctest: running doctests.
Thu, 29 Dec 2022 11:33:41 GMT ExpandTemplates: expanding markdown templates.
Thu, 29 Dec 2022 11:43:10 GMT CrossReferences: building cross-references.
Thu, 29 Dec 2022 11:43:34 GMT CheckDocument: running document checks.
Thu, 29 Dec 2022 11:43:35 GMT Populate: populating indices.
Thu, 29 Dec 2022 11:43:37 GMT RenderDocument: rendering document.
Thu, 29 Dec 2022 11:43:39 GMT HTMLWriter: rendering HTML pages.
Thu, 29 Dec 2022 11:45:19 GMT </makedocs>
```
i.e.
```

```


[Example Run]: https://github.com/tfiers/PkgGraphs.jl/actions/runs/3800181014/jobs/6463409156
[lines]: https://github.com/tfiers/PkgGraphs.jl/actions/runs/3796526953/jobs/6463409156#step:6:134

<!-- older run, 19 minutes: 

https://github.com/tfiers/PkgGraphs.jl/actions/runs/3796526953/jobs/6456700294#step:6:134
-->
