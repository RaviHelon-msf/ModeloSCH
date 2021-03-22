using Dates
using Plots
using DifferentialEquations

include("""Parametros_Sistemico.jl""")
include("""rungekutta4.jl""")
include("""inputs.jl""")

teste = """default"""
alg = RK4()

## Planta

function plantaInCor!(du,u,p,t)
    p_cs = ((u[4]-u[5])*p[10]+u[2]+u[1])

    if p[12] > p_cs
        D_i = 1.0
    else
        D_i = 0.0
    end

    if p_cs > u[3]
        D_o = 1
    else
        D_o = 0
    end

    du[1] = (p[13](t) - u[1])/p[1]/p[2]
    du[2] = (p_cs[end] - u[1] - u[2])/p[10]/p[11]
    du[3] = (u[5]-u[6])/p[9]
    du[4] = (D_i*(u[1]-p_cs[end])-p[3]*u[4])/p[4]
    du[5] = (D_o*(p_cs[end]-u[3])-p[5]*u[5])/p[6]
    du[6] = (u[3]-p[12]-p[7]*u[6])/p[8]
end


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
