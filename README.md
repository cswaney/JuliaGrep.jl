# JuliaGrep.jl

This is a toy example to demonstrate ahead-of-time (AOT) compiled Julia.

## Links
[Julia as a Statically Compiled Language](https://www.youtube.com/watch?v=hUxnLunOU4w)
[New Ways to Compile Julia | JuliaCon 2024](https://www.youtube.com/watch?v=MKdobiCKSu0)

## Compilation with `juliac.jl` and `--trim`
- Julia has historically targeted Matlab and Python programmers (e.g., "Walk like Python, run like C")
- In many cases, it has instead attracted C++ programmers!
- For C++ developers, the attraction is *productivity*
- But some C++ folks need or want ahead-of-time compilation (e.g., backend for R library)
- Fully-compiled has been available for a long time (c.f., `PackageCompiler.jl`)
- `juliac.jl` has also been around for awhile, but less widely known
- Both basically work by recursively serializing **everything** and storing native code (due to historical/typical use of Julia via the REPL)
- This process results in large images and high latency
- Last year, Bezanson and Baraldi announced improvements to `juliac.jl` including the `--trim` option
- `--trim` prunes everything that is not reachable from specified entrypoints while still linkning to Julia shared libraries
- This results in executables that are ~2 orders of magnitude smaller (excluding `libjulia`) and reduced load times

### Issues
- "Reflection" (https://docs.julialang.org/en/v1/base/reflection/) might break
- Compile-time errors and warnings ("too many" targets, e.g., `push!(x::Any)`)
- Dynamic `stdout` (e.g., logging) is not allowed
- `__init__` methods are not allowed (these make up most of the remaining space—600 Kb—and startup time in executables)
- Type unstable code is problematic (but this is already a problem!)

### How-To
1. Clone this repo.
2. Obtain `nightly` Julia: `juliaup add nightly`
3. Build the executable: `julia +nightly --project ./build/juliac.jl --trim --output-exe ./build/jgrep ./src/JuliaGrep.jl --experimental`
4. Test it: `jgrep test.txt '[0-9]'`

### Thoughts
- This is great, but there is almost no documentation still, and it does require some adjustments to development practices

### Notes
- You can also compile shared libraries using `--output-lib` option, e.g., `julia +nightly juliac.jl --trim --output-lib libhello.dylib libhello.jl`
- Use `--compile-callable` to mark all `@ccallable` methods as entrypoints
- Semgrep for Julia: https://github.com/JuliaComputing/semgrep-rules-julia (add it to your CI!). JuliaHub uses this for static analysis.

### Future
- Continued optimization!
- Full static linking (currently dynamic linking to `libjulia`)
- Finish `juliac` app
- Deployment version of Julia?
