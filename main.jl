using Dates
using Plots
using DifferentialEquations

include("""Parametros_Sistemico.jl""")
include("""inputs.jl""")

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

plot_press = plot(sol, label = """Câmara de ar""", vars = (0,1))
plot_press = plot!(sol, label = """Complacência câmera de sangue""", vars = (0,2))
plot_press = plot!(sol, label = """Aorta""", vars = (0,3))
title!("""Pressões versus tempo""")
ylabel!("""Pressões (mmHg)""")
xlabel!("""Tempo (s)""")


#filename1 = """Pressões""" + teste + string(today())
#png(plot_press, filename1)

# x_0[1] = [Pca] # Pressão camara de ar
# x_0[2] = [Pcs] # Pressão Complacência camera de sangue
# x_0[3] = [Pao] # Pressão Aortica

plot_flux =  plot(sol, label = """Cânula de entrada""",vars = (0,4))
plot_flux =  plot!(sol, label = """Cânula de saída""",vars = (0,5))
plot_flux =  plot!(sol, label = """Sistêmico""",vars = (0,6))
title!("""Fluxos versus tempo""")
ylabel!("""Fluxos (ml/s)""")
xlabel!("""Tempo (s)""")

#filename1 = """Fluxos""" + teste + string(today())
#png(plot_press, filename1)

# x_0[4] = [Qin] # Fluxo arterial sistêmico
# x_0[5] = [Qout] # Fluxo venoso sistêmico
# x_0[6] = [Qs] # Fluxo laço sistêmico
