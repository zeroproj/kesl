#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import os
import subprocess
import shutil
import time

param = sys.argv
path = os.path.join('/tmp/', 'kaspersky')


##################Definição de Instalação Automatica################################################

ip_set = "" #Definir IP - Valores: "" ou "ip/dns"
USE_GUI = "no" #Ativar GIU - Valores: yes/no
USER = "" #Nome de usuario com direitos admin do Linux

##Agente URL
url_AG = 'https://products.s.kaspersky-labs.com/endpoints/keslinux10/11.0.0.2706/multilanguage-INT-11.0.0.2706/3237363231317c44454c7c31/klnagent64_11.0.0-38_amd64.deb'
name_agente = "klnagent64_11.0.0-38_amd64.deb"

##KESL URL
url_kes = 'https://products.s.kaspersky-labs.com/endpoints/keslinux10/11.0.0.2706/multilanguage-INT-11.0.0.2706/3237363230367c44454c7c31/kesl_11.0.0-2706_amd64.deb'
name_kes = "kesl_11.0.0-2706_amd64.deb"
###################################################################################################

def inst_agente(ip):
    print("\n####################################################")
    print("#       INSTALAÇÃO AGENTE KASPERSKY FOR LINUX      #")
    print("####################################################\n")
    string = f"KLNAGENT_SERVER={ip}\nKLNAGENT_PORT=14000\nKLNAGENT_SSLPORT=13000\nKLNAGENT_USESSL=y\nKLNAGENT_GW_MODE=1"
    arquivo = open('autoanswers.conf', 'w')
    arquivo.writelines(string)
    arquivo.close()
    #Download Agente de Rede
    subprocess.call(f"wget {url_AG} -c --read-timeout=5 --tries=0 -q --show-progress", shell = True)
    #Instalação do Agente de Rede
    subprocess.call(f"dpkg -i {name_agente}", shell = True)
    #Configuração do Agente de Rede
    subprocess.run(['/opt/kaspersky/klnagent64/lib/bin/setup/postinstall.pl --auto'], shell = True)

def inst_kes(k1,k2,k3,k4,k5,k6,k7,k8):
    #Configuraçoes Padroes de instalação do produto############################################################
    EULA_AGREED = k1
    PRIVACY_POLICY_AGREED = k2
    USE_KSN = k3
    UPDATER_SOURCE = k4 #SCServer|KLServers
    UPDATE_EXECUTE= k5
    USE_GUI = k6
    USER = k7
    IMPORT_SETTINGS = k8
    ############################################################################################################
    print("\n####################################################")
    print("#       INSTALAÇÃO ENDPOINT KASPERSKY FOR LINUX      #")
    print("####################################################\n")
    string1 = f"EULA_AGREED={EULA_AGREED}\nPRIVACY_POLICY_AGREED={PRIVACY_POLICY_AGREED}\nUSE_KSN={USE_KSN}\nUPDATER_SOURCE={UPDATER_SOURCE}\nUPDATE_EXECUTE={UPDATE_EXECUTE}\nUSE_GUI={USE_GUI}\nIMPORT_SETTINGS={IMPORT_SETTINGS}\nADMIN_USER_IF_USE_GUI={USER}"
    arquivo = open('kesl_autoanswers.conf', 'w')
    arquivo.writelines(string1)
    arquivo.close()
    #Download Endpoint
    subprocess.call(f"wget {url_kes} -c --read-timeout=5 --tries=0 -q --show-progress", shell = True)
    #Instalação do Endpoint
    subprocess.call(f"dpkg -i {name_kes}", shell = True)
    #Configuração ENDPOINT
    subprocess.run([f"/opt/kaspersky/kesl/bin/kesl-setup.pl --autoinstall={path}/kesl_autoanswers.conf"], shell = True)

def limp():
    if os.path.isdir(path):
        shutil.rmtree(path)
        os.mkdir(path)
        os.chdir(path)
    else:
        os.mkdir(path)
        os.chdir(path)

def inicio(ip_set,USE_GUI,USER):
    print("\n####################################################")
    subprocess.run(["apt install perl gcc binutils make libc6 libc6-i386 -y"], shell = True)
    print("\n####################################################\n")
    if (len(param) == 2):
        print(f"\nO IP/DNS: {param[1]} foi definido como paramentro na execução\n")
        return [param[0],USE_GUI,USER]
        
    elif(len(param) == 1 and ip_set != ""):
        print(f"\nO IP/DNS: {ip_set} já está definido como paramentrono pacote.\n")
        return [ip_set,USE_GUI,USER]
        
    elif(len(param) == 1 and ip_set == ""):
        ipk = input("\nDigite o IP/DNS do Servidor de Administração: ")
        print("\nAtivar GUI:\n1 - Sim\n2 - Não")
        gui = input("Opção: ")
        if (gui == "1"):
            GUI = "yes"
            ufg = input("Digite o usuario(admin) Linux: ")
        else:
            USE_GUI = "no"
            ufg = ""
        print(f"O IP/DNS: {ipk} foi definido como parametro no pacote.\n")
        return [ipk,GUI,ufg]
    

subprocess.call("clear", shell = True)
print("\n####################################################")
print("# INSTALAÇÃO PROTEÇÃO KASPERSKY ENDPOINT FOR LINUX #")
print("####################################################\n")

print("###############DEFININDO CONFIGURAÇÕES##############\n")
vet_ins = inicio(ip_set,USE_GUI,USER)
ip_set = vet_ins[0]

print("#####REALIZANDO LIMPEZA DOS ARQUIVOS TEMPORARIOS####\n")
limp()

inst_agente(vet_ins[0])
inst_kes("yes","yes","yes","SCServer","yes",vet_ins[1],vet_ins[2],"no")
shutil.rmtree(path)

subprocess.call("clear", shell = True)
print("\n####################################################")
print("#      INSTALAÇÃO PROTEÇÃO KASPERSKY CONCLUIDA     #")
print("####################################################\n")
time.sleep(2)


    
    
    
