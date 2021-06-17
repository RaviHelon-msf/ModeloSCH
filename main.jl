using Dates
using Plots
using JuMP
using Ipopt
using Statistics
using BenchmarkTools

include("""Parametros_Sistemico.jl""")
include("""inputs.jl""")
include("""Modelo_Sistemico.jl""")

imagem = """.\\Imagens\\Ic\\"""
dados  = """.\\Dados\\Ic\\"""


function ajuda(R_ca = Rca, C_ca = Cca, R_i = Ri, L_i = Li, R_o = Ro, L_o = Lo, R_s = Rs, L_s = Ls, C_ao = Cao, R_cs = Rcs, C_cs = Ccs, P_ao = Pao)
    inp = simInCor(R_ca, C_ca, R_i, L_i, R_o, L_o, R_s, L_s, C_ao, R_cs, C_cs, P_ao)[1,1][end-2050:end-50]
    ref = referencia()[3,1][end-2000:end]
    resize!(ref, length(inp))
    delta = sqrt(mean((inp-ref).^2.0))
    return delta
end

function hellion(R_ca = Rca, C_ca = Cca, R_i = Ri, L_i = Li, R_o = Ro, L_o = Lo, R_s = Rs, L_s = Ls, C_ao = Cao, R_cs = Rcs, C_cs = Ccs, P_ao = Pao)
    inp = simInCor(R_ca, C_ca, R_i, L_i, R_o, L_o, R_s, L_s, C_ao, R_cs, C_cs, P_ao)[2,1][end-2050:end-50]
    ref = referencia()[2,1][end-2000:end]
    resize!(ref, length(inp))
    delta = sqrt(mean((inp-ref).^2.0))
    return delta
end

modelo = Model(Ipopt.Optimizer)

## Otimização multiobjetivo

JuMP.@variables(modelo, begin
    R_ca, (start = Rca, lower_bound=0.001, upper_bound=0.1)
    C_ca, (start = Cca, lower_bound=5, upper_bound=20)
    R_i, (start = Ri, lower_bound=0.01, upper_bound=10)
    L_i, (start = Li, lower_bound=0.001, upper_bound=1)
    R_o, (start = Ro, lower_bound=0.1, upper_bound=20)
    L_o, (start = Lo, lower_bound=0.001, upper_bound=1)
    R_s, (start = Rs, lower_bound=0.1, upper_bound=10)
    L_s, (start = Ls, lower_bound=0.01, upper_bound=1)
    #C_ao, (start = Cao, lower_bound=5, upper_bound=20)
    #R_cs, (start = Rcs, lower_bound=5, upper_bound=20)
    #C_cs, (start = Ccs, lower_bound=5, upper_bound=20)
    #P_ao, (start = Pao, lower_bound=5, upper_bound=20)
end)

JuMP.register(modelo,:ajuda,8,ajuda,autodiff=true)
JuMP.register(modelo,:hellion,8,ajuda,autodiff=true)

@NLobjective(modelo, Min, ajuda(R_ca, C_ca, R_i, L_i, R_o, L_o, R_s, L_s))
@NLobjective(modelo, Min, hellion(R_ca, C_ca, R_i, L_i, R_o, L_o, R_s, L_s))#, C_ao, R_cs, C_cs, P_ao
#theta = [Rca, Cca, Ri, Li, Ro, Lo, Rs, Ls, Cao, Rcs, Ccs, Pao]
#s = erroQuad(simInCor(theta)[1,1], ref[3,1])
optimize!(modelo)

## Resultados

if termination_status(modelo) != MOI.OPTIMIZE_NOT_CALLED
    R_ca_opt = value(R_ca)
    C_ca_opt = value(C_ca)
    R_i_opt = value(R_i)
    L_i_opt = value(L_i)
    R_o_opt = value(R_o)
    L_o_opt = value(L_o)
    R_s_opt = value(R_s)
    L_s_opt = value(L_s)
    C_ao_opt = value(C_ao)
    R_cs_opt = value(R_cs)
    #C_cs_opt = value(C_cs)
    #P_ao_opt = value(P_ao)
    Out_opt = objective_value(modelo)
    print("Resultado obtido: ")
    print(termination_status(modelo))
else
    print("The model was not solved correctly. Termination Status: ")
    print(termination_status(modelo))
end

## Plotagem

#gr()

sol = simInCor(R_ca_opt, C_ca_opt, R_i_opt, L_i_opt, R_o_opt, L_o_opt, R_s_opt, L_s_opt)
#bm = @benchmark simInCor() samples = 10000 seconds = 300

plot_press = plot(sol[1][end-2050:end-50])
plot_press = plot!(referencia()[3,1][end-2000:end])

title!("""Pressão na Câmara de ar""")
ylabel!("""Pressão (mmHg)""")
xlabel!("""Tempo (s)""")


#filename1 = imagem*"""Pao"""*string(today())
#png(plot_press, filename1)

# x_0[1] = [Pca] # Pressão camara de ar
# x_0[2] = [Pcs] # Pressão Complacência camera de sangue
# x_0[3] = [Pao] # Pressão Aortica

#plot_flux =  plot(sol[2])
#title!("""Fluxo na Cânula de saída""")
#ylabel!("""Fluxo (ml/s)""")
#xlabel!("""Tempo (s)""")

#4filename1 = imagem*"""qo"""*string(today())
#png(plot_flux, filename1)


# x_0[4] = [Qin] # Fluxo arterial sistêmico
# x_0[5] = [Qout] # Fluxo venoso sistêmico
# x_0[6] = [Qs] # Fluxo laço sistêmico
