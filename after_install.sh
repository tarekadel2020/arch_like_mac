#!/bin/bash -x
set -e

yaourt(){
    sudo pacman -S --needed base-devel git wget yajl
    cd /tmp
    git clone https://aur.archlinux.org/package-query.git
    cd package-query/
    makepkg -si && cd /tmp/
    git clone https://aur.archlinux.org/yaourt.git
    cd yaourt/
    makepkg -si
}




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

vala_menu(){
pamac build vala-panel-appmenu-common-git vala-panel-appmenu-registrar-git vala-panel-appmenu-xfce-git
sudo pacman -S appmenu-gtk-module
}

vala_menu_2(){
yaourt -S vala-panel-appmenu-common-git vala-panel-appmenu-registrar-git vala-panel-appmenu-xfce-git
sudo pacman -S appmenu-gtk-module
}

Main(){
      #pamace-cli
      #pamace-aur
      yaourt
      vala_menu_2
      mugshot
      #vala-panel-appmenu-common-git
      #vala-panel-appmenu-registrar-git
      #vala-panel-appmenu-xfce-git
}

Main
