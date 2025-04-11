# JuliaGrep.jl

This is a toy example to demonstrate the proposed `app` feature for `Pkg`.

## Links
- [App support in Pkg | Carlsson | JuliaCon 2024](https://www.youtube.com/watch?v=7n27lF_SrxY)
- [Pkg Documentation](https://pkgdocs.julialang.org/dev/apps/)

## Overview
- There are a number of Julia "applications" on the market right, e.g., Pluto.jl
- The way you run these is to start a Julia REPL, then type something like `MyPkg.run()`
- For packages that are intended to be used as an applications, "app support" will allow users to run without Julia REPL, e.g., `pluto run ...`
- This is desirable for apps because they should always have their own process and address space
- App packages should include `[apps]` section in `Project.jl`
- App dependencies are stored to an app-specific location, e.g., `$HOME/.julia/environment/apps/myapp/*.toml`
- App "shim" is stored to separate location, e.g., `$HOME/.julia/bin/myapp`
- `Pkg` will provide new app-specific commands: `apps add`, `apps rm`, `apps add`, etc.

## Issues
- Can a package ship multiple apps?
- Can a packge be a library and an app?
- Which Julia version to use?
- App support is still experimental

## Example
1. Clone `Pkg`
2. Obtain `nightly` Julia: `juliaup add nightly`
3. Start Julia in the `Pkg` environment: `cd Pkg && julia +nightly --project`
4. Add this repo:
```julia
import Pkg
(Pkg) pkg> app add https://github.com/cswaney/JuliaGrep.jl.git
```
4. Add the shim directory to your `PATH`: export PATH="$HOME/.julia/bin:$PATH"
5. Test it: `jgrep test.txt '[0-9]'`
