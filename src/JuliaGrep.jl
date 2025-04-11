module JuliaGrep

Base.@ccallable function main(argc::Cint, argv::Ptr{Ptr{UInt8}})::Cint
    C_ARGS = Vector{String}(undef, argc - 1)
    for i in 2:argc
        argptr = unsafe_load(argv, i)
        arg = unsafe_string(argptr)
        C_ARGS[i - 1] = arg
    end

	if length(C_ARGS) < 1
		println(Core.stdout, "Missing required arguments: fname, pattern.")
        return 1
    elseif length(C_ARGS) < 2
		println(Core.stdout, "Missing required arguments: pattern.")
        return 1
	end
	
	fname = C_ARGS[1]
	pattern = Regex(C_ARGS[2])

    if !isfile(fname)
        println(Core.stdout, "File does not exist.")
        return 1
    end

	f = open(fname, "r")
    for (n, line) in enumerate(eachline(f))
        m = match(pattern, line)
		if !isnothing(m)
            print(Core.stdout, "Line $n: ")
			print(Core.stdout, line[1:m.offset - 1]);
			print(Core.stdout, "\e[1m\e[38;2;198;120;221m", line[m.offset:m.offset + length(m.match) - 1]);
			print(Core.stdout, "\e[0m", line[m.offset + length(m.match):end] * "\n");
		end
    end
    return 0
end
Base.Experimental.entrypoint(main, (Cint, Ptr{Ptr{UInt8}}))

end # module JuliaGrep
