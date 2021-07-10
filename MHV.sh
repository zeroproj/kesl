#!/bin/bash
clear
echo "###########################################################################"
echo "################# INSTALAÇÃO PROTEÇÃO KASPERSKY ENDPOINT ##################"
echo "#################### OS: Debian/Ubuntu/CentOS/Fedora ######################"
echo -e "## www.microhard.com.br ############################### KESL ## MH_V10 ###\n"
#Desenvolvido por Lucas Matheus
#Lucas Matheus - lucasmatheus@microhard.com.br
#Suporte - atendimento@microhard.com.br
#################################################
#***********************************************#
#Paramentros de Instalação Kaspersky Agente
#################################################
KLNAGENT_SERVER=kcs.com.br
#################################################
KLNAGENT_PORT=14000
KLNAGENT_SSLPORT=13000
KLNAGENT_USESSL=y
KLNAGENT_GW_MODE=1
#Paramentros de Instalação Kaspersky Endpoint
#################################################
EULA_AGREED=yes
PRIVACY_POLICY_AGREED=yes
USE_KSN=yes
UPDATER_SOURCE=KLServers
UPDATE_EXECUTE=no
USE_GUI=yes
USER=ksc
IMPORT_SETTINGS=no
#Produtos Kaspersky Link
#################################################################################################################################################################################
link_kla_deb="https://products.s.kaspersky-labs.com/endpoints/keslinux10/11.1.0.3013/multilanguage-INT-11.1.0.3013/3330333430367c44454c7c31/klnagent64_11.0.0-38_amd64.deb"     #
link_kla_rpm="https://products.s.kaspersky-labs.com/endpoints/keslinux10/11.1.0.3013/multilanguage-INT-11.1.0.3013/3330333430347c44454c7c31/klnagent64-11.0.0-38.x86_64.rpm"    #
link_kes_deb="https://products.s.kaspersky-labs.com/endpoints/keslinux10/11.1.0.3013/multilanguage-INT-11.1.0.3013/3330333430317c44454c7c31/kesl_11.1.0-3013_amd64.deb"         #
link_kes_rpm="https://products.s.kaspersky-labs.com/endpoints/keslinux10/11.1.0.3013/multilanguage-INT-11.1.0.3013/3331353036317c44454c7c31/kesl-11.1.0-3013.x86_64.rpm"        #
link_up="https://raw.githubusercontent.com/zeroproj/kesl/master/versionMH"                                                                                                      #
scriptline="https://raw.githubusercontent.com/zeroproj/kesl/master/MHV.sh"                                                                                                      #
#################################################################################################################################################################################
#DEFINIR PARAMETROS DE PASTAS/LOGS/DESISNTALÇÃO #
#################################################
klna=/opt/kaspersky/klnagent64/bin/
kes=/opt/kaspersky/kesl/bin/
dic_temp=/tmp/kaslinux/
#################################################
#Arquivos temporarios /tmp/kaslinux/            #
#################################################
if [ ! -d $dic_temp ]
then
mkdir -m 755 -p $dic_temp
else
rm -rf /tmp/kaslinux/*
fi
#################################################
#Pre-Instalação                                 #
#################################################
N_arq="$0" #Nome do Arquivo - Não Alterar       #
P_01="$1" #Parametro 1 - Não Alterar            #
P_0T="$2" #Parametro 2 - Não Alterar            #
pkg='linux' #Paramentro Reconhecimento Linux    #
instpkg=""  #Paramentro Reconhecimento Linux    #
INST="0" #Paramentro Instalação                 #
CONF="0" #Parametro Configuração                #
avs="10"                                        #
#################################################
#################################################################################
#Parametro Instalação de Bibliotecas para Funcionamento do Agente              ##
#0 - Desativado                                                                ##
#1 - Ativado (Recomendado)                                                     ##
ATV_BIBLIA='1'                                                                 ##
inst_ag=""                                                                     ##
#################################################################################
#################################################################################
#Parametro Instalação de Bibliotecas para funcionamento do Kaspersky Endpoint  ##
#0 - Desativado                                                                ##
#1 - Ativado (Recomendado)                                                     ##
ATV_BIBLI='1'                                                                  ##
bib=""                                                                         ##
bibc=""                                                                        ##
#################################################################################
#################################################################################
#TESTE ROOT                                                                    ##
#################################################################################
if [ "$(id -u)" != "0" ];then #TESTE ROOT
  echo ""
  echo "###########################################################################"
  echo "            Voce deve ter poder de root par executar este scrip.           "
  echo "###########################################################################"
  exit 0
#################################################################################
#INSTALAÇÃO                                                                    ##
#################################################################################
else
  if [[ $P_01 = "-help" ]]; then
    echo -e "\n###########################################################################"
    echo -e "       É necessario definir argumento para instalação do Kaspersky         "
    echo -e "###########################################################################\n"
    echo -e "| Argumentos |                            Ação                            |"
    echo -e "|   -yum     | Instalação Gerenciador de pacote YUM*                      |"
    echo -e "|   -deb     | Instalação Gerenciador de pacote DEB*                      |"
    echo -e "|   -dnf     | Instalaçao Gerenciador de pacote DNF*                      |"
    echo -e "|   -a       | Instalação automatizada                                    |"
    echo -e "|   -c       | Reconfigurar Kaspersky for Linux                           |"
    echo -e "|   -r       | Remover Kaspersky for Linux                                |"
    echo -e "|   -d       | Alterar configurações padrão do script                     |"
    echo -e "|   -u       | Atualizar Script (BETA)                                    |"
    echo -e "\n * Recomendado para instalção"
    echo -e "\nExemplo: script.sh [argumento]"
    echo -e "\n###########################################################################"
    echo -e "                         Parametros opcionais                                "
    echo -e "###########################################################################\n"
    echo -e "Caso deseje definir o servidor de administração manualmente na execução do "
    echo -e "script adicione o servidor apos o argumento"
    echo -e "\nExemplo: script.sh [argumento] [KServer]"
    echo -e "\n###########################################################################\n"
    exit 0
  elif [[ $P_01 = "-yum" ]]; then
    pkg='rpm'avs
    instpkg="yum"
    echo -e "\nInstalação Gerenciador de pacote YUM selecionado" >> $dic_temp'kaspersky.log'

  elif [[ $P_01 = "-deb" ]]; then
    pkg='dpkg'
    instpkg="apt"
    echo -e "\nInstalação Gerenciador de pacote DEB selecionado" >> $dic_temp'kaspersky.log'

  elif [[ $P_01 = "-dnf" ]]; then
    pkg='rpm'
    instpkg="dnf"
    echo -e "\nInstalação Gerenciador de pacote DNF selecionado" >> $dic_temp'kaspersky.log'

  elif [[ $P_01 = "-a" ]]; then
    echo -e "\nInstalação AUTO selecionado" >> $dic_temp'kaspersky.log'
############################################################################################
#IDENTIFICAÇÃO DE SISTEMAS OPERACIONAL                                                     #
############################################################################################
    syst=$(cat /etc/*release* |tr '\n' '%')
    echo $syst |tr '%' '\n' >> $dic_temp'kaspersky.log'
    pkg="$(grep -Ei '(fedora|centos|suse|rhel|sles|altlinux|red hat enterprise)' $(find /etc/ -maxdepth 1 -iname '*-release' -o -iname '*_version') >/dev/null 2>&1 && echo rpm || echo dpkg)"
    if [ $pkg = "rpm" ]; then
      if (echo $(which dnf) |grep -iw dnf > /dev/null); then
        echo $(which dnf) >> $dic_temp'kaspersky.log'
        instpkg="dnf"
      else
        instpkg="yum"
      fi
    elif [ $pkg = "dpkg" ]; then
        instpkg="apt"
    else
        echo "     - Sitema Operacional não suportado."
        exit 0
    fi
    echo -e " * Identificando Sistema Operacional: $pkg"

  elif [[ $P_01 = "-c" ]]; then
    pkg='c'
    echo -e "\nSelecionado reconfiguração do Kaspersky Agente e Endpoint" >> $dic_temp'kaspersky.log'

  elif [[ $P_01 = "-r" ]]; then
    pkg="$(grep -Ei '(fedora|centos|suse|rhel|sles|altlinux|red hat enterprise)' $(find /etc/ -maxdepth 1 -iname '*-release' -o -iname '*_version') >/dev/null 2>&1 && echo rpm || echo dpkg)"
    echo -e "\nSelecionado remoção do Kaspersky Agente e Endpoint" >> $dic_temp'kaspersky.log'

  elif [[ $P_01 = "-d" ]]; then
    pkg='d'
    echo -e "\nSelecionado reconfiguração do Script" >> $dic_temp'kaspersky.log'

  elif [[ $P_01 = "-u" ]]; then
    echo -e "\nSelecionado atualização de script" >> $dic_temp'kaspersky.log'
    wget -q -c -O $dic_temp'vs.raw' -P $dic_temp $link_up
    if [ $? -eq 0 ];then
      echo -e "\nArquivo de atualizacao baixado" >> $dic_temp'kaspersky.log'
    else
      echo "Falha ao realizar a checagem da atualização"
      echo -e "\nFalha ao baixar o arquivo de atualizacao" >> $dic_temp'kaspersky.log'
      exit 0
    fi
    arquivo=$dic_temp'vs.raw'
    while read linha || [[ -n "$linha" ]]; do
    nvs=$linha
    done < "$arquivo"
    echo -e "\nVersão Atual $avs" >> $dic_temp'kaspersky.log'
    echo -e "\nVersão Atual $nvs" >> $dic_temp'kaspersky.log'
    if [ $nvs -gt $avs ]; then  
        echo -e "SCRIPT DESTAUALIZADO\n"
        echo -e "INFORMAÇOES DO SCRIPT"
        Dir_def=$(pwd)$(echo /MHV$nvs.sh)
        Dir_avs=$(pwd)$(echo $N_arq|sed 's/^.//g')
        echo $Dir_def
        wget -q -c -O $(pwd)$(echo /MHV$nvs.sh) -P $(pwd) $scriptline
        if [ $? -eq 0 ];then
            echo -e "\nArquivo de atualizacao (SCRIPT) baixado" >> $dic_temp'kaspersky.log'
        else
            echo "Falha ao realizar a checagem da atualização"
            echo -e "\nFalha ao baixar o arquivo (SCRIPT) de atualizacao" >> $dic_temp'kaspersky.log'
            exit 0
        fi
                echo " * KLNAGENT_SERVER=$srvl"
        echo "Script Novo $Dir_def"
        echo "Script Anterior $Dir_avs"
        echo -e "\nCONFIGURAÇÃO DO SCRIPT"
        echo " * $KLNAGENT_SERVER"
        echo " * $USE_GUI" 
        echo " * $USER" 
        echo " * $UPDATE_EXECUTE" 
        echo " * $KLNAGENT_PORT" 
        echo " * $KLNAGENT_SSLPORT" 
        echo " * $ATV_BIBLIA" 
        echo " * $ATV_BIBLI" 
        #ServADM
        Serv_Antigo="KLNAGENT_SERVER=kcs.com.br"
        Serv_Novo="KLNAGENT_SERVER="$KLNAGENT_SERVER
        sed -i s/^$Serv_Antigo/$Serv_Novo/ $Dir_def

        #GUI e User
        T_USE_GUI="USE_GUI=yes"
        T_USER="USER=ksc"
        V_USE_GUI="USE_GUI="$USE_GUI
        V_USER="USER=$USER"
        sed -i "s/^$T_USE_GUI/$V_USE_GUI/" $Dir_def
        sed -i "s/^$T_USER/$V_USER/" $Dir_def

        #UPdate
        T_UPDATE_EXECUTE="UPDATE_EXECUTE=no"
        V_UPDATE_EXECUTE="UPDATE_EXECUTE="$UPDATE_EXECUTE
        sed -i "s/^$T_UPDATE_EXECUTE/$V_UPDATE_EXECUTE/" $Dir_def

        #Systema
        T_ATV_BIBLIA="ATV_BIBLIA='1'"
        T_ATV_BIBLI="ATV_BIBLI='1'"
        V_ATV_BIBLIA="ATV_BIBLIA='$ATV_BIBLIA'"
        V_ATV_BIBLI="ATV_BIBLI='$ATV_BIBLI'"
        sed -i "s/^$T_ATV_BIBLIA/$V_ATV_BIBLIA/" $Dir_def
        sed -i "s/^$T_ATV_BIBLI/$V_ATV_BIBLI/" $Dir_def

        #portas
        T_KLNAGENT_PORT="KLNAGENT_PORT=14000"
        T_KLNAGENT_SSLPORT="KLNAGENT_SSLPORT=13000"
        V_KLNAGENT_PORT="KLNAGENT_PORT="$KLNAGENT_PORT
        V_KLNAGENT_SSLPORT="KLNAGENT_SSLPORT="$KLNAGENT_SSLPORT
        sed -i "s/^$T_KLNAGENT_PORT/$V_KLNAGENT_PORT/" $Dir_def
        sed -i "s/^$T_KLNAGENT_SSLPORT/$V_KLNAGENT_SSLPORT/" $Dir_def
        if [ $? -eq 0 ];then
            echo "ATUALIZAÇÃO REALIZADA DO SUCESSO!"
            exit 0
        else
            echo "FALHA AO REALIZAR A ATUALIZAÇÃO!"
            exit 0
        fi
    else  
      echo "Script Atualizado"
    fi
    exit 0
  else
    echo -e "\n###########################################################################"
    echo -e "       É necessario definir argumento para instalação do Kaspersky         "
    echo -e "\n             script.sh -help (Para mais informaçoes)                     "
    echo -e "###########################################################################"
    exit 0
  fi
fi
#################################################################################
#CHECANDO SERVIDOR DE ADMINISTRAÇÃO                                            ##
#################################################################################
if [[ $P_0T != "" ]]; then #CHECANDO SERVIDOR DE ADMINISTRAÇÃO 1 
 KLNAGENT_SERVER=$P_0T
 echo " * Servidor de Administração: "$KLNAGENT_SERVER
 echo -e "\nParametro do Servidor de administração definido: "$KLNAGENT_SERVER >> $dic_temp'kaspersky.log'
else #CHECANDO SERVIDOR DE ADMINISTRAÇÃO 2
 echo " * Servidor de Administração: "$KLNAGENT_SERVER
 echo -e "\nServidor de administração: "$KLNAGENT_SERVER >> $dic_temp'kaspersky.log'
fi

if [[ $pkg = "d" ]]; then #Reconfigurando Script
  echo -e "\n###########################################################################"
  echo "                        Configuração Script                                  "
  echo -e "###########################################################################\n"
  #Servidor
  read -p 'Digite o novo Servidor de Administração: ' srvl
  read -p 'Digite a Porta(14000): ' p1
  if [[ -n ${p1//[0-9]/} ]]; then
    echo "Valor invalido! Tente Novamente"
    exit 0
  else
    if [[ $p1 != "" ]]; then
      V_KLNAGENT_PORT="KLNAGENT_PORT="$p1
    else
      V_KLNAGENT_PORT="KLNAGENT_PORT=14000"
    fi
  fi
  read -p 'Digite a Porta SSL(13000): ' p2
  if [[ -n ${p2//[0-9]/} ]]; then
    echo "Valor invalido! Tente Novamente"
    exit 0
  else
    if [[ $p2 != "" ]]; then
      V_KLNAGENT_SSLPORT="KLNAGENT_SSLPORT="$p2
    else
      V_KLNAGENT_SSLPORT="KLNAGENT_SSLPORT=13000"
    fi
  fi
  #Interface Grafica
  GUI=" "
  read -p 'Ativar interface Grafica:(S/N): ' GUI
  if [ $GUI = "S" ] || [ $GUI = "s" ]; then
    read -p '(Opcional) Usuario Root do sistema: ' USR
    V_USE_GUI="USE_GUI=yes"
    V_USER="USER=$USR"
  elif [ $GUI = "N" ] || [ $GUI = "n" ]; then
    V_USE_GUI="USE_GUI=no"
    V_USER="USER="
  else
    echo "Comando invalido! Tente Novamente"
    exit 0
  fi
  #Base de Dados
  read -p 'Atualizar base de dados(S/N): ' UPS
  if [ $UPS = "S" ] || [ $UPS = "s" ]; then
    V_UPDATE_EXECUTE="UPDATE_EXECUTE=yes"
  elif [ $UPS = "N" ] || [ $UPS = "n" ]; then
    V_UPDATE_EXECUTE="UPDATE_EXECUTE=no"
  else
    echo "Comando invalido! Tente Novamente"
    exit 0
  fi
  #Biblioteca Agente
  read -p 'RECOMENDADO - Ativar instalação de bibliotecas do Agente de Rede :(S/N): ' BLA
  if [ $BLA = "S" ] || [ $BLA = "s" ]; then
    V_ATV_BIBLIA="ATV_BIBLIA='1'"
  elif [ $BLA = "N" ] || [ $BLA = "n" ]; then
    V_ATV_BIBLIA="ATV_BIBLIA='0'"
  else
    echo "Comando invalido! Tente Novamente"
    exit 0
  fi
  #Biblioteca ENDPOINT
  read -p 'RECOMENDADO - Ativar instalação de bibliotecas do Endpoint :(S/N): ' BLE
  if [ $BLE = "S" ] || [ $BLE = "s" ]; then
    V_ATV_BIBLI="ATV_BIBLI='1'"
  elif [ $BLE = "N" ] || [ $BLE = "n" ]; then
    V_ATV_BIBLI="ATV_BIBLI='0'"
  else
    echo "Comando invalido! Tente Novamente"
    exit 0
  fi
  echo
  echo "Valores de Configuração"
  echo " * KLNAGENT_SERVER=$srvl"
  echo " * $V_USE_GUI"
  echo " * $V_USER"
  echo " * $V_UPDATE_EXECUTE"
  echo " * $V_KLNAGENT_PORT"
  echo " * $V_KLNAGENT_SSLPORT"
  echo " * $V_ATV_BIBLIA"
  echo " * $V_ATV_BIBLI"
  read -p 'Deseja confirmar as alteraçoes(S\N): ' conx
  if [ $conx = "S" ] || [ $conx = "s" ]; then
    Dir_def=$(pwd)$(echo $N_arq|sed 's/^.//g')
    #ServADM
    Serv_Antigo="KLNAGENT_SERVER="$KLNAGENT_SERVER
    Serv_Novo="KLNAGENT_SERVER="$srvl
    sed -i s/^$Serv_Antigo/$Serv_Novo/ $Dir_def
    #GUI e User
    T_USE_GUI="USE_GUI="$USE_GUI
    T_USER="USER="$USER
    sed -i "s/^$T_USE_GUI/$V_USE_GUI/" $Dir_def
    sed -i "s/^$T_USER/$V_USER/" $Dir_def
    #UPdate
    T_UPDATE_EXECUTE="UPDATE_EXECUTE="$UPDATE_EXECUTE
    sed -i "s/^$T_UPDATE_EXECUTE/$V_UPDATE_EXECUTE/" $Dir_def
    #Systema
    T_ATV_BIBLIA="ATV_BIBLIA='$ATV_BIBLIA'"
    T_ATV_BIBLI="ATV_BIBLI='$ATV_BIBLI'"
    sed -i "s/^$T_ATV_BIBLIA/$V_ATV_BIBLIA/" $Dir_def
    sed -i "s/^$T_ATV_BIBLI/$V_ATV_BIBLI/" $Dir_def
    #portas
    T_KLNAGENT_PORT="KLNAGENT_PORT="$KLNAGENT_PORT
    T_KLNAGENT_SSLPORT="KLNAGENT_SSLPORT="$KLNAGENT_SSLPORT
    sed -i "s/^$T_KLNAGENT_PORT/$V_KLNAGENT_PORT/" $Dir_def
    sed -i "s/^$T_KLNAGENT_SSLPORT/$V_KLNAGENT_SSLPORT/" $Dir_def
    if [ $? -eq 0 ];then
    	echo "Alteração realizada com sucesso!"
        exit 0
    else
        echo "Falha ao realizar as alteraçoes."
        exit 0
    fi
  else
    echo -e "Operação não concluida"
    exit 0
  fi
  exit 0
fi
cd $dic_temp
if [[ $P_01 = "-r" || $instpkg = "yum" || $instpkg = "apt" || $instpkg = "dnf" ]]; then #Remover Solução Kaspersky
  if [[ -d $klna ]]; then
    echo " * Realizando remoção do Kaspersky Agente"
    echo -e "Realizando remoção do Kaspersky Agente" >> $dic_temp'kaspersky.log'
    if [ $pkg = "rpm" ]; then
      rpm -e klnagent >> $dic_temp'kaspersky.log'
      rpm -e klnagent64 >> $dic_temp'kaspersky.log'
    elif [ $pkg = "dpkg" ]; then
      dpkg -r klnagent >> $dic_temp'kaspersky.log'
      dpkg -r klnagent64 >> $dic_temp'kaspersky.log'
    fi
    echo -e "Remoção do Kaspersky Agente concluida" >> $dic_temp'kaspersky.log'
  else
    echo " * Não foi identificado Kaspersky Agente instalado"
    echo -e "Não foi identificado Kaspersky Agente instalado" >> $dic_temp'kaspersky.log'
  fi
  if [[ -d $kes ]]; then
    echo " * Realizando remoção do Kaspersky Endpoint"
    echo -e "Realizando remoção do Kaspersky Endpoint" >> $dic_temp'kaspersky.log'
    if [ $pkg = "rpm" ]; then
      rpm -e kesl >> $dic_temp'kaspersky.log'
    elif [ $pkg = "dpkg" ]; then
      dpkg -r kesl >> $dic_temp'kaspersky.log'
    fi
    echo -e "Remoção do Kaspersky Endpoint concluida" >> $dic_temp'kaspersky.log'
  else
    echo " * Não foi identificado Kaspersky Endpoint instalado"
    echo -e "Não foi identificado Kaspersky Endpoint instalado" >> $dic_temp'kaspersky.log'
  fi
fi

if [[ $instpkg = "yum" || $instpkg = "apt" || $instpkg = "dnf" ]]; then #Install KAS & KESL Server
  echo "###########################################################################"
  echo "                      Instalação Proteção Kaspersky                        "
  echo -e "###########################################################################"
  echo -e " * Verificando FANOTIFY"
  if (cat /boot/config-$(uname -r) |grep -iw CONFIG_FANOTIFY=y > /dev/null); then
    if (cat /boot/config-$(uname -r) |grep -iw CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y > /dev/null); then
      echo "     - Todo o recurso do Fanotify é suportado pelo o Sitema Operacional."
      echo -e "Todo o recurso do Fanotify é suportado pelo o Sitema Operacional" >> $dic_temp'kaspersky.log'
      FT="0"
    else
      echo -e "     - Fanotify não é suportado no Kernel. (PS1)"
      echo -e "Recurso do Fanotify não suportado pelo o Sitema Operacional" >> $dic_temp'kaspersky.log'
      FT="1"
    fi
  else
    echo -e "     - Fanotify não é suportado no Kernel. (PS2)"
    echo -e "Recurso do Fanotify não suportado pelo o Sitema Operacional" >> $dic_temp'kaspersky.log'
    FT="1"
  fi  
  echo -e " * (Agente de Rede) Checando bibliotecas necessarias para instalação"
  if [[ $pkg = "rpm" ]]; then
    if !(echo $(rpm -qa perl) | grep -iw perl > /dev/null); then
    inst_ag="$inst_ag perl"
    BA="1"
    fi
    if !(echo $(rpm -qa wget) | grep -iw wget > /dev/null); then
    inst_ag="$inst_ag wget"
    BA="1"
    fi
  fi
  if [[ $pkg = "dpkg" ]]; then
    if !(echo $(dpkg -l perl) | grep -iw perl > /dev/null); then
    inst_ag="$inst_ag perl"
    BA="1"
    fi
    if !(echo $(dpkg -l wget) | grep -iw wget > /dev/null); then
    inst_ag="$inst_ag wget"
    BA="1"
    fi
  fi
  if [[ $inst_ag != "" ]]; then
    echo -e "     - BIBLIOTECA $inst_ag: Instalação Necessaria"
    if [[ $ATV_BIBLIA = "1" ]]; then
      echo -e " * (Agente de Rede) Instalação de bibliotecas necessarias"
      echo -e "(Agente de Rede) Instalação de bibliotecas necessarias: $inst_ag" >> $dic_temp'kaspersky.log'
      $instpkg install -y $inst_ag >> $dic_temp'kaspersky.log'
      if [ $? -eq 0 ]; then
			  echo " * (Agente de Rede) Instalação das completa"
			  echo -e "\nKaspersky Endpoint = OK" >> $dic_temp'kaspersky.log'
		  else
			  echo " * Falha na instação das bibliotecas Agente de Rede\n     - Instalação abortada"
			  echo -e "\nKaspersky Endpoint = ERRO" >> $dic_temp'kaspersky.log'
			  exit 0
		  fi
    else
      echo " * (Agente de Rede) Instalação será abortada. Necessario realizar a instalação das bibliotecas:"
      echo -e "     - (Agente de Rede) Recurso de instalação automatica desativado"
      echo -e "(Agente de Rede) Instalação de bibliotecas necessarias: $inst_ag/nRecurso de instalação automatica desativado" >> $dic_temp'kaspersky.log'
      exit 0
    fi
  fi
  if [[ $FT = "1" ]]; then #KERNEL INSTALL
    klinux=$(uname -r)
    echo -e " * (Kaspersky Endpoint) Checando recursos adicionais do KERNEL: $klinux para instalação"
    #Instalação Kernel Devel
    kernel=""
    echo "Kernel $klinux"  >> $dic_temp'kaspersky.log'
    if [[ $pkg = 'rpm' ]]; then
      if (echo $(uname -r) |grep "uek" > /dev/null); then
        #echo " * (Kaspersky Endpoint) Kernel UEK $klinux"
        if !(echo $(rpm -qa kernel-uek-devel) | grep -iw "$klinux" > /dev/null); then
          kernel="kernel-uek-devel-$klinux"
        else
          echo " * (Kaspersky Endpoint) Kernel Devel $klinux ja instalado"  >> $dic_temp'kaspersky.log'
          echo " * (Kaspersky Endpoint) Kernel Devel UEK $klinux já instalado no dispostivo"
        fi
      else
        #echo " * (Kaspersky Endpoint) Kernel $klinux"
        if !(echo $(rpm -qa kernel-devel) | grep -iw "$klinux" > /dev/null); then
          kernel="kernel-devel-$klinux"
          #kernel="kernel-devel-uname-r == $(uname -r)"
        else
          echo " * (Kaspersky Endpoint) Kernel Devel $klinux ja instalado"  >> $dic_temp'kaspersky.log'
          echo " * (Kaspersky Endpoint) Kernel Devel $klinux já instalado no dispostivo"
        fi
      fi
    fi
    if [[ $pkg = 'dpkg' ]]; then
      #echo " * Kernel $klinux"
      if !(echo $(dpkg -l linux-headers-$klinux) | grep -iw "$klinux" > /dev/null); then
        kernel="linux-headers-$klinux"
      else
        echo " * (Kaspersky Endpoint) Kernel Devel $klinux ja instalado"  >> $dic_temp'kaspersky.log'
        echo " * (Kaspersky Endpoint) Kernel Devel $klinux já instalado no dispostivo"
      fi
    fi
    if [[ $kernel != "" ]]; then
      echo -e "     - KERNEL $kernel: Instalação Necessaria"
      if [[ $ATV_BIBLI = "1" ]]; then
        $instpkg install -y $kernel >> $dic_temp'kaspersky.log'
        if [ $? -eq 0 ]; then
			    echo " * (Kaspersky Endpoint) Instalação KERNEL: $kernel completa"
			    echo -e "\nKaspersky Endpoint = OK" >> $dic_temp'kaspersky.log'
		    else
			    echo " * (Kaspersky Endpoint) Falha na instação do KERNEL: $kernel\n     - Instalação abortada"
			    echo -e "\nAgente de Rede = ERRO" >> $dic_temp'kaspersky.log'
			    exit 0
		    fi
      else
        echo " * (Kaspersky Endpoint) Instalação será abortada. Necessario realizar a instalação do $kernel:"
        echo -e "     - (KERNEL) Recurso de instalação automatica desativado"
        echo -e " * (Kaspersky Endpoint) Instalação de kernel necessarias: $kernel/nRecurso de instalação automatica desativado" >> $dic_temp'kaspersky.log'
        exit 0
      fi
    fi
    if [[ $pkg = "rpm" ]]; then
      if !(echo $(rpm -qa gcc) | grep -iw gcc > /dev/null); then
        bib="$bib gcc"
      fi
      if !(echo $(rpm -qa glibc) | grep -iw glibc > /dev/null); then
        #Não pode Remover
        bib="$bib glibc"
      fi
      if !(echo $(rpm -qa glibc-devel) | grep -iw glibc-devel > /dev/null); then
        bib="$bib glibc-devel"
      fi
      if !(echo $(rpm -qa make) | grep -iw make > /dev/null); then
        bib="$bib make"
      fi
      if !(echo $(rpm -qa rpcbind) | grep -iw rpcbind > /dev/null); then
        bib="$bib rpcbind"
      fi
      if !(echo $(rpm -qa binutils) | grep -iw binutils > /dev/null); then
        bib="$bib binutils"
      fi 
    fi

    if [[ $pkg = "dpkg" ]]; then
      if !(echo $(dpkg -l gcc) | grep -iw gcc > /dev/null); then
        bib="$bib gcc"
      fi
      if !(echo $(dpkg -l libc6) | grep -iw libc6 > /dev/null); then
        #Não pode Remover
        bib="$bib libc6"
      fi
      if !(echo $(dpkg -l libc6-dev) | grep -iw libc6-dev > /dev/null); then
        bib="$bib libc6-dev"
      fi

      if !(echo $(dpkg -l make) | grep -iw make > /dev/null); then
        bib="$bib make"
      fi
      if !(echo $(dpkg -l rpcbind) | grep -iw rpcbind > /dev/null); then
        bib="$bib rpcbind"
      fi
      if !(echo $(dpkg -l binutils) | grep -iw binutils > /dev/null); then
        bib="$bib binutils"
      fi
    fi

    if [[ $bib != "" ]]; then
      echo -e "     - BIBLIOTECA $bib: Instalação Necessaria"
      if [[ $ATV_BIBLI = "1" ]]; then
        echo -e " * (Kaspersky Endpoint) Instalação de bibliotecas necessarias"
        echo -e "(Kaspersky Endpoint) Instalação de bibliotecas necessarias $bibc$bib" >> $dic_temp'kaspersky.log'
        echo -e "     - (Kaspersky Endpoint) Instalação de bibliotecas necessarias $bibc$bib"
        $instpkg install -y $bib >> $dic_temp'kaspersky.log'
        if [ $? -eq 0 ]; then
          echo " * Instalação das bibliotecas Kaspersky Endpoint completa"
          echo -e "\nKaspersky Endpoint = OK" >> $dic_temp'kaspersky.log'
        else
          echo " * Falha na instação das bibliotecas Kaspersky Endpoint\n     - Instalação abortada"
          echo -e "\nKaspersky Endpoint = ERRO" >> $dic_temp'kaspersky.log'
          exit 0
        fi
      else
        echo " * (Kaspersky Endpoint) Instalação será abortada. Necessario realizar a instalação das bibliotecas:"
        echo -e "     - (Kaspersky Endpoint) Recurso de instalação automatica desativado"
        echo -e " * (Kaspersky Endpoint) Instalação de bibliotecas necessarias: $bib/nRecurso de instalação automatica desativado" >> $dic_temp'kaspersky.log'
        exit 0
      fi
    fi
  fi
  echo -e "\nINSTALAÇÃO KASPERSKY" >> $dic_temp'kaspersky.log'
  echo " * Download do Agente de Rede"
  if [[ $pkg = "rpm" ]]; then
    wget -q -c -O $dic_temp'KLA.rpm' -P $dic_temp $link_kla_rpm
    echo " * Instalando Kaspersky Agente de Rede"
    rpm -ivh $dic_temp'KLA.rpm' >> $dic_temp'kaspersky.log'
    if [ $? -eq 0 ];then
      echo " * Instação do Agente de Rede completa"
      echo -e "\nKaspersky Agente de Rede = OK" >> $dic_temp'kaspersky.log'
    else
      echo " * Falha na instação do Agente de Rede.\n     - Instalação abortada"
      echo -e "\nKaspersky Agente de Rede = ERRO" >> $dic_temp'kaspersky.log'
      exit 0
    fi
    echo " * Download do Kaspersky Endpoint"
    wget -q -c -O $dic_temp'KES.rpm' -P $dic_temp $link_kes_rpm
    echo " * Instalando Kaspersky Endpoint"
    rpm -ivh $dic_temp'KES.rpm' >> $dic_temp'kaspersky.log'
    if [ $? -eq 0 ];then
      echo " * Instalação do Kaspersky Endpoint completa"
      echo -e "\nKaspersky Endpoint = OK" >> $dic_temp'kaspersky.log'
    else
      echo " * Falha na instação do Kaspersky Endpoint\n     - Instalação abortada"
      echo -e "\nKaspersky Endpoint = ERRO" >> $dic_temp'kaspersky.log'
      exit 0
    fi
  fi
  if [[ $pkg = "dpkg" ]]; then
    wget -q -c -O $dic_temp'KLA.deb' -P $dic_temp $link_kla_deb
    echo " * Instalando Kaspersky Agente de Rede"
    dpkg -i $dic_temp'KLA.deb' >> $dic_temp'kaspersky.log'
    if [ $? -eq 0 ];then
      echo " * Instação do Agente de Rede completa"
      echo -e "\nKaspersky Agente de Rede = OK" >> $dic_temp'kaspersky.log'
    else
      echo " * Falha na instação do Agente de Rede.\n     - Instalação abortada"
      echo -e "\nKaspersky Agente de Rede = ERRO" >> $dic_temp'kaspersky.log'
      exit 0
    fi
    echo " * Download do Kaspersky Endpoint"
    wget -q -c -O $dic_temp'KES.deb' -P $dic_temp $link_kes_deb
    echo " * Instalando Kaspersky Endpoint"
    dpkg -i $dic_temp'KES.deb' >> $dic_temp'kaspersky.log'
    if [ $? -eq 0 ];then
      echo " * Instalação do Kaspersky Endpoint completa"
      echo -e "\nKaspersky Endpoint = OK" >> $dic_temp'kaspersky.log'
    else
      echo " * Falha na instação do Kaspersky Endpoint\n     - Instalação abortada"
      echo -e "\nKaspersky Endpoint = ERRO" >> $dic_temp'kaspersky.log'
      exit 0
    fi
  fi
fi
if [[ $pkg = "c" || $instpkg = "yum" || $instpkg = "apt" || $instpkg = "dnf" ]]; then #Reconfigurando Kaspersky
  if [[ -d $klna ]]; then
  echo " * Gerando arquivo de configuração Agente de Rede"
  touch $dic_temp'kesl_autoanswers.conf'
  echo -e "KLNAGENT_SERVER=$KLNAGENT_SERVER\nKLNAGENT_PORT=$KLNAGENT_PORT\nKLNAGENT_SSLPORT=$KLNAGENT_SSLPORT\nKLNAGENT_USESSL=$KLNAGENT_USESSL\nKLNAGENT_GW_MODE=$KLNAGENT_GW_MODE" >> $dic_temp'autoanswers.conf'
  echo " * Configurando Agente de Rede"
  /opt/kaspersky/klnagent64/lib/bin/setup/postinstall.pl --auto
  if [ $? -eq 0 ];then
    echo " * Agente de Rede Configurado"
    echo -e "Kaspersky Agente de Rede = Configurado" >> $dic_temp'kaspersky.log'
  else
    echo " * Falha na configuração do Agente de Rede.\n     - Instalação abortada"
    echo -e "Kaspersky Agente de Rede = ERRO de Configuração" >> $dic_temp'kaspersky.log'
    exit 0
  fi
  else
    echo " * Não foi identificado Kaspersky Agente instalado"
    echo -e "Não foi identificado Kaspersky Agente instalado" >> $dic_temp'kaspersky.log'
  fi
  if [[ -d $kes ]]; then
    echo " * Gerando arquivo de configuração Endpoint"
    touch $dic_temp'kesl_autoanswers.conf'
    echo -e "EULA_AGREED=$EULA_AGREED\nPRIVACY_POLICY_AGREED=$PRIVACY_POLICY_AGREED\nUSE_KSN=$USE_KSN\nUPDATER_SOURCE=$UPDATER_SOURCE\nUPDATE_EXECUTE=$UPDATE_EXECUTE\nUSE_GUI=$USE_GUI\nIMPORT_SETTINGS=$IMPORT_SETTINGS\nADMIN_USER_IF_USE_GUI=$USER" >> $dic_temp'kesl_autoanswers.conf'
    echo " * Configurando Kaspersky Endpoint"
    /opt/kaspersky/kesl/bin/kesl-setup.pl --autoinstall=$dic_temp'kesl_autoanswers.conf'
    if [ $? -eq 0 ];then
      echo " * Kaspersky Endpoint Configurado"
      echo -e "Kaspersky Endpoint = Configurado" >> $dic_temp'kaspersky.log'
    else
      echo " * Falha na configuração do Kaspersky Endpoint.\n     - Instalação abortada"
      echo -e "Kaspersky Endpoint = ERRO de Configuração" >> $dic_temp'kaspersky.log'
      exit 0
    fi
    else
      echo " * Não foi identificado Kaspersky Endpoint instalado"
      echo -e "Não foi identificado Kaspersky Endpoint instalado" >> $dic_temp'kaspersky.log'
    fi
    exit 0
  fi
  exit 0
fi
#Desenvolvido por Lucas Matheus
#Lucas Matheus - lucasmatheus@microhard.com.br
#Suporte - atendimento@microhard.com.br
