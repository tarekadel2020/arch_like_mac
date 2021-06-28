#!/bin/bash -x
set -e

pamace-aur(){
    cd $HOME
    git clone https://aur.archlinux.org/pamac-aur.git
    cd ./pamac-aur
    makepkg -si 
}

pamace-cli(){
    cd $HOME
    git clone https://aur.archlinux.org/pamac-cli.git
    cd ./pamac-cli
    makepkg -si 
}

vala-panel-appmenu-common-git(){
      #cd $HOME
      #git clone https://aur.archlinux.org/vala-panel-appmenu-xfce-git.git
      #cd ./vala-panel-appmenu-common-git
      #makepkg -si
      pamac build vala-panel-appmenu-common-git
}

vala-panel-appmenu-registrar-git(){
      #cd $HOME
      #git clone https://aur.archlinux.org/vala-panel-appmenu-registrar-git.git 
      #cd ./vala-panel-appmenu-registrar-git
      #makepkg -si 
      pamac build vala-panel-appmenu-registrar-git
}

vala-panel-appmenu-xfce-git(){
      #cd $HOME
      #git clone https://aur.archlinux.org/vala-panel-appmenu-xfce-git.git
      #cd ./vala-panel-appmenu-xfce-git
      #makepkg -si 
      pamac build vala-panel-appmenu-xfce-git
}

mugshot(){
      pamac build mugshot
}

vala_menu{
pamac build vala-panel-appmenu-common-git vala-panel-appmenu-registrar-git vala-panel-appmenu-xfce-git
sudo pacman -S appmenu-gtk-module
}

Main(){
      mugshot
      pamace-cli
      pamace-aur
      vala_menu
      #vala-panel-appmenu-common-git
      #vala-panel-appmenu-registrar-git
      #vala-panel-appmenu-xfce-git
}

Main
