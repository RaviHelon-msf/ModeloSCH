# Parâmetros de Simulação
T = 8 # Tempo em segundos
h = 1e-5 # Passo de cálculo em segundos

# Lado Direito do Coração
C_ra = [5, 5] # ml/mmHg
D_tv = [1, 1] # Diodo
R_tv = [5e-3, 5e-3] # mmHg.s/ml
E_s_rv = [1.15, 0.5] # mmHg/ml
E_d_rv = [0.1, 0.1] # mmHg/ml
D_pv = [1, 1] # Diodo
R_pv = [3e-3, 3e-3] # mmHg.s/ml

# Lado Esquerdo do Coração
C_la = [5, 5] # ml/mmHg
D_mv = [1, 1] # Diodo
R_mv = [5e-3, 5e-3] # mmHg.s/ml
E_s_lv = [2.5, 0.5] # mmHg/ml
E_d_lv = [0.1, 0.1] # mmHg/ml
D_av = [1, 1] # Diodo
R_av = [8e-3, 8e-3] # mmHg.s/ml


# Circulação Sistêmica
C_as = [1.5, 1.5] # ml/mmHg
R_as = [1, 1.4] # mmHg.s/ml
L_as = [1e-5, 1e-5] # mmHg.s2/ml
C_vs = [82.5, 82.5] # ml/mmHg
R_vs = [0.09, 0.09]# mmHg.s/ml
L_vs = [1e-5, 1e-5] # mmHg.s2/ml

# Circualação Pulmonar
C_ap = [3, 3] # ml/mmHg
R_ap = [3e-3, 3e-3] # mmHg.s/ml
L_ap = [1e-5, 1e-5] # mmHg.s2/ml
C_vp = [5, 5] # ml/mmHg
R_vp = [0.07, 0.07] # mmHg.s/ml
L_vp = [1e-5, 1e-5] # mmHg.s2/ml


# Dispositivo de Assistência Ventricular
