using Dates
using Plots
using DifferentialEquations

include("""Parametros_Sistemico.jl""")
include("""inputs.jl""")
include("""Modelo_Sistemico.jl""")

teste = """default"""
alg = RK4()

## Pré-Processamento: Parâmetrização
p_d = t -> input_InCor(t, Tc, DutyCycle, Pej)

theta = [Rca, Cca, Ri, Li, Ro, Lo, Rs, Ls, Cao, Rcs, Ccs, Pao, p_d]
#Rca, Cca, Ri, Li, Ro, Lo, Rs, Ls, Cao, Rcs, Ccs

# Valores iniciais
x0 = [Pca, Pcs, Pao, Qin, Qout, Qs]


## Simulação
tspan = (0.0, 3*T)
#plot(t,u)
problem = ODEProblem(plantaInCor!,x0,tspan,theta)
sol = solve(problem, alg)

## Plotagem

gr()

plot_press = plot(sol, vars = (0,1))
title!("""Pressão na Câmara de ar""")
ylabel!("""Pressão (mmHg)""")
xlabel!("""Tempo (s)""")


filename1 = """Pca"""*teste*string(today())
png(plot_press, filename1)


plot_press = plot(sol, vars = (0,2))
title!("""Pressão na Complacência câmera de sangue""")
ylabel!("""Pressão (mmHg)""")
xlabel!("""Tempo (s)""")


filename1 = """Pccs"""*teste*string(today())
png(plot_press, filename1)


plot_press = plot(sol, vars = (0,3))
title!("""Pressão na Aorta""")
ylabel!("""Pressão (mmHg)""")
xlabel!("""Tempo (s)""")


filename1 = """Pao"""*teste*string(today())
png(plot_press, filename1)

# x_0[1] = [Pca] # Pressão camara de ar
# x_0[2] = [Pcs] # Pressão Complacência camera de sangue
# x_0[3] = [Pao] # Pressão Aortica

plot_flux =  plot(sol, vars = (0,4))
title!("""Fluxo na Cânula de entrada""")
ylabel!("""Fluxo (ml/s)""")
xlabel!("""Tempo (s)""")

filename1 = """qi"""*teste*string(today())
png(plot_flux, filename1)


plot_flux =  plot(sol,vars = (0,5))
title!("""Fluxo na Cânula de saída""")
ylabel!("""Fluxo (ml/s)""")
xlabel!("""Tempo (s)""")

filename1 = """qo"""*teste*string(today())
png(plot_flux, filename1)


plot_flux =  plot(sol, vars = (0,6))
title!("""Fluxo Sistêmico""")
ylabel!("""Fluxo (ml/s)""")
xlabel!("""Tempo (s)""")

filename1 = """qs """*teste*string(today())
png(plot_flux, filename1)

# x_0[4] = [Qin] # Fluxo arterial sistêmico
# x_0[5] = [Qout] # Fluxo venoso sistêmico
# x_0[6] = [Qs] # Fluxo laço sistêmico
