#!/bin/bash -x
set -e

##################### install pamace-aur #################################
cd $HOME
git clone https://aur.archlinux.org/pamac-aur.git
cd ./pamac-aur
makepkg -si 
###########################################################################

############ install vala-panel-appmenu-common-git  #######################
cd $HOME
git clone https://aur.archlinux.org/vala-panel-appmenu-xfce-git.git
cd ./vala-panel-appmenu-common-git
makepkg -si 
###########################################################################

########### install vala-panel-appmenu-registrar-git ######################
cd $HOME
git clone https://aur.archlinux.org/vala-panel-appmenu-registrar-git.git 
cd ./vala-panel-appmenu-registrar-git
makepkg -si 
###########################################################################

######################## install vala-panel-appmenu-xfce-git ##############
cd $HOME
git clone https://aur.archlinux.org/vala-panel-appmenu-xfce-git.git
cd ./vala-panel-appmenu-xfce-git
makepkg -si 

############################################################################
