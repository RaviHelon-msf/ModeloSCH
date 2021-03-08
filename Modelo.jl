using Plots

include("""Parametros.jl""")

# Valores iniciais
p_la = [0] # Pressão átrio esquerdo
V_lv = [0] # Volume ventrículo esquerdo
p_as = [0] # Pressão arterial sistêmica
p_vs = [0] # Pressão venosa sistêmica
p_ra = [0] # Pressão átrio direito
V_rv = [0] # Volume ventrícular direito
p_ap = [0] # Pressão arterial pulmonar
p_vp = [0] # Pressão venosa pulmonar
q_as = [0] # Fluxo arterial sistêmico
q_vs = [0] # Fluxo venoso sistêmico
q_ap = [0] # Fluxo arterial pulmonar
q_vp = [0] # Fluxo venoso pulmonar

# Laço principal
for t in h:h:T

    p_lv =
    p_as =
    p_rv =
    p_ap = 

    # Modelagem dos Diodos
    D_mv = (p_la[end]-p_lv>0) ? true: false
    D_av = (p_lv-p_as>0) ? true: false
    D_tv = (p_ra[end]-p_rv>0) ? true: false
    D_pv = (p_rv-p_ap>0) ? true: false


    # Valores incrementais
    dp_la =
    dV_lv =
    dp_as =
    dp_vs =
    dp_ra =
    dV_rv =
    dp_ap =
    dp_vp =
    dq_as =
    dq_vs =
    dq_ap =
    dq_vp =

    # Dinâmica
    push!(p_la,p_la[end]+dp_la)
    push!(V_lv,V_lv[end]+dV_lv)
    push!(p_as,p_as[end]+dp_as)
    push!(p_vs,p_vs[end]+dp_vs)
    push!(p_ra,p_ra[end]+dp_ra)
    push!(V_rv,V_rv[end]+dV_rv)
    push!(p_ap,p_ap[end]+dp_ap)
    push!(p_vp,p_vp[end]+dp_vp)
    push!(q_as,q_as[end]+dq_as)
    push!(q_vs,q_vs[end]+dq_vs)
    push!(q_ap,q_ap[end]+dq_ap)
    push!(q_vp,q_vp[end]+dq_vp)
end

# Interface Final
