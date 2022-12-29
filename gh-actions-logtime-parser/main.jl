using Dates
using Printf

raw = """
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
"""

lines = split(strip(raw), "\n")

deleteat!(lines, 1)

splits = split.(lines, " GMT ")
datetime_strs = first.(splits)
messages = last.(splits)

datetimes = DateTime.(datetime_strs, dateformat"e, d u y H:M:S")

diffs = diff(datetimes)

for (msg, dt) in zip(messages, diffs)
    # messages is one longer than diffs. That's ✔
    type, descr = split(msg, " ", limit=2)
    dt = Second(dt)
    print(
        lpad(type, 20), " | ",
        lpad(dt, 12), " | ",
    )
    if dt > Minute(1)
        print("(", round(dt, Minute), ")")
    end
    println()
end
