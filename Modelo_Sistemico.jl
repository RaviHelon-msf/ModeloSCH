using DifferentialEquations

include("""Parametros_Sistemico.jl""")
include("""inputs.jl""")

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


# x_0[1] = [Pca] # Pressão camara de ar
# x_0[2] = [Pcs] # Pressão Complacência camera de sangue
# x_0[3] = [Pao] # Pressão Aortica


# x_0[4] = [Qin] # Fluxo arterial sistêmico
# x_0[5] = [Qout] # Fluxo venoso sistêmico
# x_0[6] = [Qs] # Fluxo laço sistêmico

function simInCor(x = Rca)
    alg = RK4()
    p_d = t -> input_InCor(t, Tc, DutyCycle, Pej)

    # Valores iniciais
    x0 = [Pca, Pcs, Pao, Qin, Qout, Qs]

    theta = [x, Cca, Ri, Li, Ro, Lo, Rs, Ls, Cao, Rcs, Ccs, Pao, p_d]
    #Rca, Cca, Ri, Li, Ro, Lo, Rs, Ls, Cao, Rcs, Ccs
    # Simulação
    ref = referencia()[1,1]
    tspan = (0.0, ref[end] )
    #plot(t,u)
    problem = ODEProblem(plantaInCor!,x0,tspan,theta)
    sol = DifferentialEquations.solve(problem, alg, dense = false, adaptive = false, dt = ref[2])

    P = sol[3,:]
    Q = sol[5,:]

    return [P, Q]
end

function erroQuad(x)
    return sqrt(sum(x))
end
