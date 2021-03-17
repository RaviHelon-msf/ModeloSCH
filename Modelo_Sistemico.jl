using Plots

include("""Parametros_Sistemico.jl""")
include("""rungekutta4.jl""")

# Valores iniciais
p_ca = [Pca] # Pressão camara de ar
p_ccs = [Pcs] # Pressão Complacência camera de sangue
p_ao = [Pao] # Pressão Aortica
q_i = [Qin] # Fluxo arterial sistêmico
q_o = [Qout] # Fluxo venoso sistêmico
q_s = [Qs] # Fluxo laço sistêmico
p_cs = [Pcs]
V_0 = Vo

aux = [0.0]

# Laço principal
for t in h:h:T-h

    t_m = (t%Tc)/Tc*100

    if t_m <= DutyCycle
        p_d = Pej
    else
        p_d = 0.0
    end

    # Modelagem dos Diodos
    if Pae > p_cs[end]
        D_i = 1.0
    else
        D_i = 0.0
    end

    if p_cs[end] > p_ao[end]
        D_o = 1.0
    else
        D_o = 0.0
    end

    #Fluxos Importantes

    # Passe de Euler
    dp_ca(y)  = (p_d - y)/Rca/Cca
    dp_ccs(y) = (p_cs[end] - p_ca[end] - y)/Rcs/Ccs
    dp_ao(y)  = (q_o[end]-q_s[end])/Cao
    dq_i(y)   = (D_i*(p_ca[end]-p_cs[end])-Ri*y)/Li
    dq_o(y)   = (D_o*(p_cs[end]-p_ao[end])-Ro*y)/Lo
    dq_s(y)   = (p_ao[end]-Pae-Rs*y)/Ls


    # Dinâmica
    push!(p_ca,rungekutta4(dp_ca, p_ca[end], h))
    push!(p_ccs,rungekutta4(dp_ccs, p_ccs[end], h))
    push!(p_ao,rungekutta4(dp_ao, p_ao[end], h))
    push!(q_i,rungekutta4(dq_i, q_i[end], h))
    push!(q_o,rungekutta4(dq_o, q_o[end], h))
    push!(q_s,rungekutta4(dq_s, q_s[end], h))

    push!(p_cs,((q_i[end]-q_o[end])*Rcs+p_ccs[end]+p_ca[end]))

    push!(aux, p_d)
end

# Interface Final
gr()
plot(q_o)
#println(p_ap)
