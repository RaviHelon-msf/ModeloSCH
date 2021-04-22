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


function ajuda(x)
    delta = sqrt(mean((simInCor(x)[1,1]-referencia()[3,1]).^2))
    return delta
end

#modelo = Model(Ipopt.Optimizer)

## Otimização multiobjetivo

#@variable(modelo, x >= 0)

#JuMP.register(modelo,:ajuda,1,ajuda,autodiff=true)

#@NLobjective(modelo, Min, ajuda(x))
#theta = [Rca, Cca, Ri, Li, Ro, Lo, Rs, Ls, Cao, Rcs, Ccs, Pao]
#s = erroQuad(simInCor(theta)[1,1], ref[3,1])
#optimize!(modelo)
## Plotagem

gr()

sol = simInCor()
bm = @benchmark simInCor()

#plot_press = plot(sol[1])
#title!("""Pressão na Câmara de ar""")
#ylabel!("""Pressão (mmHg)""")
#xlabel!("""Tempo (s)""")


#filename1 = imagem*"""Pao"""*string(today())
#png(plot_press, filename1)

# x_0[1] = [Pca] # Pressão camara de ar
# x_0[2] = [Pcs] # Pressão Complacência camera de sangue
# x_0[3] = [Pao] # Pressão Aortica

#plot_flux =  plot(sol[2])
#title!("""Fluxo na Cânula de saída""")
#ylabel!("""Fluxo (ml/s)""")
#xlabel!("""Tempo (s)""")

#filename1 = imagem*"""qo"""*string(today())
#png(plot_flux, filename1)


# x_0[4] = [Qin] # Fluxo arterial sistêmico
# x_0[5] = [Qout] # Fluxo venoso sistêmico
# x_0[6] = [Qs] # Fluxo laço sistêmico
