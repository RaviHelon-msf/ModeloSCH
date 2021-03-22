function input_InCor(t, Tc = 0.6, D = 40, amp = 190)
    t_m = (t%Tc)/Tc*100
    if t_m <= D
        u = amp
    else
        u = 0
    end
    return u
end
