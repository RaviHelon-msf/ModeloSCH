#Fatores de conversão de medidas:
Kr = 1.0 #133.322e+6; #Resistência hidráulica (mmHg*s*ml^-1) para elétrica (Ohm)
Kc = 1.0 #7.5006e-9; #Capacitância hidráulica (ml*mmHg^-1) para elétrica (Farad)
Kl = 1.0 #133.322e+6; #Indutância hidráulica (mmHg*s^2*ml^-1) para elétrica (Henry)
#Fator_pressao
p = 1.0 #133.322; #mmHg para Volts
#Fator_fluxo
f = 1.0 #1e-6; #ml*s^-1 para Amperes
#Fator_volume
v = 1.0 #1e-6; #ml para Coulombs

## Parâmetros do Simulador hidráulico

flag_condicao = 1; #1 = healthy; 0 = HF

if(flag_condicao==1)

    #Simulações Daniel - Simscape
    #1) Pao - 80/40 mmHg: SH_UFCG_HR100_Pao_80_40.slx

    HR = 100.0; # frequência cardíaca (bpm)

    # # Resistências (mmHg.s/mL)
    Ri = 0.4283*Kr; #Resistência da cânula de entrada
    Ro = 1.2841*Kr; #Resistência da cânula de saída
    Rs = 2.2798*Kr; #Resistência sistêmica
    Rca = 0.0025*Kr; #Resistência da câmera de ar
    Rcs = 0.1*Kr; #Resistência da câmera de sangue

    # #Complacências (mL/mmHg)
    Cca = 13.7054*Kc; #Complacência da câmara de ar
    Ccs = 0.25*Kc; #Complacência da câmara de sangue
    Cao = 0.23*Kc; #Complacência da aorta

    # #Inertâncias (mmHg.s^2/mL)
    Li = 0.0402*Kl; #Inertância da cânula de entrada
    Lo = 0.0426*Kl; #Inertância da cânula de saída
    Ls = 0.1228*Kl; #Inertância sistêmica

    map = 61.0; #valor médio de Pao
    eep_num = 1523.0; #valor médio de Qout*Pao
    eep_den = 24.0; #valor médio de Qout

    #Condição Inicial - Pao = 80/40 mmHg
    Pao = 43.88*p; #Pressão aórtica
    Pcs = -3.44*p; #Pressão na câmara de sangue
    Qs = -17.75*f; #Fluxo sistêmico
    Qin = 10.0*f; #Fluxo da cânula de entrada
    Qout = 5.0*f; #Fluxo da cânula de saída
    Vo = 15.0*v; #Volume inicial

    #######################
    #2) Pao - 60/20 mmHg: SH_UFCG_HR150_Pao_60_20.slx

else

    HR = 150.0; # frequência cardíaca (bpm)

    # # Resistências (mmHg.s/mL)
    Ri = 0.4283*Kr; #Resistência da cânula de entrada
    Ro = 1.2841*Kr; #Resistência da cânula de saída
    Rs = 1.2363*Kr; #Resistência sistêmica
    Rca = 0.0025*Kr; #Resistência da câmera de ar
    Rcs = 0.1*Kr; #Resistência da câmera de sangue

    # #Complacências (mL/mmHg)
    Cca = 13.7054*Kc; #Complacência da câmara de ar
    Ccs = 0.25*Kc; #Complacência da câmara de sangue
    Cao = 0.16*Kc; #Complacência da aorta

    # #Inertâncias (mmHg.s^2/mL)
    Li = 0.0402*Kl; #Inertância da cânula de entrada
    Lo = 0.0426*Kl; #Inertância da cânula de saída
    Ls = 0.1194*Kl; #Inertância sistêmica

    map = 39.0; #valor médio de Pao
    eep_num = 1062.0; #valor médio de Qout*Pao
    eep_den = 26.5; #valor médio de Qout

    #Condição Inicial - Pao = 60/20 mmHg
    Pao = 21.39*p; #Pressão aórtica
    Pcs = 13.25*p; #Pressão na câmara de sangue
    Qs = -22.29*f; #Fluxo sistêmico
    Qin = 10.0*f; #Fluxo da cânula de entrada
    Qout = 5.0*f; #Fluxo da cânula de saída
    Vo = 11.0*v; #Volume inicial

end

#Ciclo cardíaco
Tc = 60/HR; #período do ciclo cardíaco (segundos) - valor definido por Daniel

#Fonte de pressão
Pae = 6.0*p; #Pressão no átrio esquerdo
Pca = 0.0*p; #Pressão na câmara de ar
Pej = 190.0*p; #Pressão de ejeção(atuador pneumático)

#Largura de pulso
DutyCycle = 40; #(%)

## Simulação

#Tempo:
T = Tc*3.0; #tempo de simulação (segundos)
h=1e-3
step_time = 4.0; #tempo de transição (aciona RBP)
