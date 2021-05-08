#!/bin/bash -x
set -e

########### install pamace-aur ######################
cd $HOME
git clone https://aur.archlinux.org/pamac-aur.git
cd ./pamac-aur
makepkg -si 
#####################################################
