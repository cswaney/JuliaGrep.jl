module JuliaGrep

function (@main)(ARGS)
	if length(ARGS) < 1
		println("Missing required arguments: fname, pattern.")
        return
    elseif length(ARGS) < 2
		println("Missing required arguments: pattern.")
        return
	end
	
	fname = ARGS[1]
	pattern = Regex(ARGS[2])

    if !isfile(fname)
        println("File does not exist.")
        return
    end

	open(fname, "r") do f
		for (n, line) in enumerate(eachline(f))
			m = match(pattern, line)
			if !isnothing(m)
                print("Line $n: ")
				printstyled(line[1:m.offset - 1]);
				printstyled(line[m.offset:m.offset + length(m.match) - 1], color = :magenta);
				printstyled(line[m.offset + length(m.match):end] * "\n");
			end
		end
	end
end

end # module JuliaGrep
