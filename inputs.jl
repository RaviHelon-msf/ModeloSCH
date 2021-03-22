function input_InCor(T = 3, passo = 1e-5, DutyCycle = 40, p_ejection = 190)
    t = h:h:T-h
    u = []

    for n in h:h:T-h

        t_m = (n%Tc)/Tc*100

        if t_m <= DutyCycle
            push!(u, Pej)
        else
            push!(u, 0)
        end
    end

    return t, u
end
