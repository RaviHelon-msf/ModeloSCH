using CSV
using DataFrames

function input_InCor(t, Tc = 0.6, D = 40, amp = 190)
    t_m = (t%Tc)/Tc*100
    if t_m <= D
        u = amp
    else
        u = 0
    end
    return u
end

function new_Input(h, T)
    open("duty40.csv", "w") do inp
        write(inp,string(h))
        for time in h:h:T-h
            input = ","*string(input_InCor(time))
            write(inp,input)
        end
    end
end

function old_Input(t)
    h = CSV.File("duty40.csv"; transpose=true, limit=1, header = ["h"])
    n = Integer(round(t/h[1][1]))
    return CSV.File("duty40.csv"; transpose=true, skipto = n, limit=1, header = false)[1][1]
end
