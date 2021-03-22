using Plots
using DifferentialEquations

include("""Parametros_Sistemico.jl""")
include("""rungekutta4.jl""")
include("""inputs.jl""")

## Pré-Processamento: Parâmetrização

theta = [Rca, Cca, Ri, Li, Ro, Lo, Rs, Ls, Cao, Rcs, Ccs]
#Rca, Cca, Ri, Li, Ro, Lo, Rs, Ls, Cao, Rcs, Ccs

# Valores iniciais
x0 = [[Pca], [Pcs], [Pao], [Qin], [Qout], [Qs]]

# x0[1] = [Pca] # Pressão camara de ar
# x0[2] = [Pcs] # Pressão Complacência camera de sangue
# x0[3] = [Pao] # Pressão Aortica
# x0[4] = [Qin] # Fluxo arterial sistêmico
# x0[5] = [Qout] # Fluxo venoso sistêmico
# x0[6] = [Qs] # Fluxo laço sistêmico

p_cs = [Pcs]
V_0 = Vo


## Simulação

function SimInCor(t, u, x_0 = x0, par = theta)

    if size(x0,1) != 6
        println("""Quantidade inadequada de valores iniciais""")
        return nothing
    elseif size(par,1) != 11
        println("""Quantidade inadequada de parâmetros""")
        return nothing
    end

    aux = [0.0]
    # Laço principal
    for n in range(1,length = size(t,1))

        # Modelagem dos Diodos
        if Pae > p_cs[end]
            D_i = 1.0
        else
            D_i = 0.0
        end

        if p_cs[end] > x0[3][end]
            D_o = 1
        else
            D_o = 0
        end

        #Fluxos Importantes
        dx0 = Array{Function}(undef, 6);
        # Passo de Euler
        dx0[1] = y -> (u[n] - y)/par[1]/par[2]
        dx0[2] = y -> (p_cs[end] - x0[1][end] - y)/par[10]/par[11]
        dx0[3] = y -> (x0[5][end]-x0[6][end])/par[9]
        dx0[4] = y -> (D_i*(x0[1][end]-p_cs[end])-par[3]*y)/par[4]
        dx0[5] = y -> (D_o*(p_cs[end]-x0[3][end])-par[5]*y)/par[6]
        dx0[6] = y -> (x0[3][end]-Pae-par[7]*y)/par[8]


        # Dinâmica
        push!(x0[1],rungekutta4(dx0[1], x0[1][end], h))
        push!(x0[2],rungekutta4(dx0[2], x0[2][end], h))
        push!(x0[3],rungekutta4(dx0[3], x0[3][end], h))
        push!(x0[4],rungekutta4(dx0[4], x0[4][end], h))
        push!(x0[5],rungekutta4(dx0[5], x0[5][end], h))
        push!(x0[6],rungekutta4(dx0[6], x0[6][end], h))

        push!(p_cs,((x0[4][end]-x0[5][end])*par[10]+x0[2][end]+x0[1][end]))

        aux = p_cs
    end

    ## Interface Final
    gr()

    pAux = plot(aux)
    display(pAux)

    #println(p_ap)
end

t,u = input_InCor(3*Tc, h, DutyCycle, Pej)

plot(t,u)

SimInCor(t,u)

#plotado = Plots.Plot{Plots.GRBackend}[]
#push!(plotado, plot(x0[1]))
#push!(plotado, plot(x0[2]))
#push!(plotado, plot(x0[3]))
#push!(plotado, plot(x0[4]))
#push!(plotado, plot(x0[5]))
#push!(plotado, plot(x0[6]))
