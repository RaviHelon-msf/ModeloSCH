using Plots

include("""Parametros.jl""")

# Valores iniciais
p_la = [6.0] # Pressão átrio esquerdo
V_lv = [V_lv_ed] # Volume ventrículo esquerdo
p_as = [43.88] # Pressão arterial sistêmica
p_vs = [3.44] # Pressão venosa sistêmica
p_ra = [6.0] # Pressão átrio direito
V_rv = [V_lv_ed] # Volume ventrícular direito
p_ap = [43.88] # Pressão arterial pulmonar
p_vp = [3.44] # Pressão venosa pulmonar
q_as = [17.75] # Fluxo arterial sistêmico
q_vs = [17.75] # Fluxo venoso sistêmico
q_ap = [17.75] # Fluxo arterial pulmonar
q_vp = [17.75] # Fluxo venoso pulmonar
p_lv = [p_lv_ed]
p_rv = [p_lv_ed]

aux = [0.0]

# Laço principal
for t in h:h:T-h
    t_m = t%T_c

    if t_m<=T_s
        E_m = 1 - cos(pi*t_m/T_s)
    elseif (t_m<T_d)&&(t_m>T_s)
        E_m = 1 + cos(pi*(t_m - T_s)/(T_d-T_s))
    else
        E_m = 0.0
    end

    E_rv = E_d_rv + 0.5*(E_s_rv - E_d_rv)*E_m
    E_lv = E_d_lv + 0.5*(E_s_lv - E_d_lv)*E_m

    push!(p_lv,p_lv_ed + E_lv*(V_lv[end] - V_lv_ed))
    push!(p_rv,p_lv_ed + E_lv*(V_rv[end] - V_lv_ed))


    # Modelagem dos Diodos
    D_mv = (p_la[end]-p_lv[end]>0) ? 1.0 : 0.0
    D_av = (p_lv[end]-p_as[end]>0) ? 1.0 : 0.0
    D_tv = (p_ra[end]-p_rv[end]>0) ? 1.0 : 0.0
    D_pv = (p_rv[end]-p_ap[end]>0) ? 1.0 : 0.0

    #Fluxos Importantes
    q_mv = (D_mv/R_mv)*(p_la[end]-p_lv[end])
    q_av = (D_av/R_av)*(p_lv[end]-p_as[end])
    q_tv = (D_tv/R_mv)*(p_ra[end]-p_rv[end])
    q_pv = (D_pv/R_mv)*(p_rv[end]-p_ap[end])

    # Valores incrementais
    #dp_la = (1/C_la)*(q_vp[end] - q_mv)
    dV_lv = (q_mv - q_av)
    dp_as = (1/C_as)*(q_av - q_as[end])
    dp_vs = (1/C_vs)*(q_as[end] - q_vs[end])
    #dp_ra = (1/C_ra)*(q_vs[end] - q_tv)
    dV_rv = (q_tv - q_pv)
    dp_ap = (1/C_ap)*(q_pv - q_ap[end])
    dp_vp = (1/C_vp)*(q_ap[end] - q_vp[end])
    dq_as = (1/L_as)*(q_as[end]+(p_vs[end]-p_as[end])/R_as)
    dq_vs = (1/L_vs)*(q_vs[end]+(p_ra[end]-p_vs[end])/R_vs)
    dq_ap = (1/L_ap)*(q_ap[end]+(p_vp[end]-p_ap[end])/R_ap)
    dq_vp = (1/L_vp)*(q_vp[end]+(p_la[end]-p_vp[end])/R_vp)

    # Dinâmica
    push!(p_la,p_la[end])
    push!(V_lv,V_lv[end]+dV_lv*h)
    push!(p_as,p_as[end]+dp_as*h)
    push!(p_vs,p_vs[end]+dp_vs*h)
    push!(p_ra,p_ra[end])
    push!(V_rv,V_rv[end]+dV_rv*h)
    push!(p_ap,p_ap[end]+dp_ap*h)
    push!(p_vp,p_vp[end]+dp_vp*h)
    push!(q_as,q_as[end]+dq_as*h)
    push!(q_vs,q_vs[end]+dq_vs*h)
    push!(q_ap,q_ap[end]+dq_ap*h)
    push!(q_vp,q_vp[end]+dq_vp*h)

    push!(aux,dq_as)
end

# Interface Final
gr()
plot(aux)
#println(p_ap)
