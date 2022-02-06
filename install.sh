#!/bin/bash -x
set -e


## All Variable ##

hard="/dev/sda"
Bios_Type="bios"         ## (uefi - bios) 
Boot_Partiton=""     ## For uefi ##
Root_Partiton="/dev/sda1"
Home_Partiton=""
Swap_Partiton="/dev/sda2"
Timezone="Africa/Cairo"
## Desktop_GUI=""  ## (gnome - kde - xfce - mate - cinnamon - lxde - i3-wm - i3-gaps - dwm - openbox)
User_Name="tarek"


## All Variable ##



Boot_partiton(){

	if [ ! -z $Boot_Partiton ]; then

		if [ $(echo "$Bios_Type" |tr [:upper:] [:lower:]) = "uefi" ]; then
			mkfs.fat -n ESP -F32 $Boot_Partiton
		fi

		if [ $(echo "$Bios_Type" |tr [:upper:] [:lower:]) = "bios" ]; then
			mkfs.ext4 -L boot $Boot_Partiton
		fi
	fi
}


Make_partitons(){
	mkfs.ext4 $Root_Partiton
	mkswap $Swap_Partiton
}


Home_partiton(){
	if [ ! -z $Home_Partiton ];then
	makdir /mnt/home
	mkfs.ext4 $Home_Partiton
	mount $Home_Partiton /mnt/home
	fi

}

Mount(){
	cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
	mount $Root_Partiton /mnt
	swapon $Swap_Partiton
	Home_partiton
}

Base(){
	pacstrap /mnt base base-devel linux linux-firmware vim nano net-tools
	genfstab -U /mnt >> /mnt/etc/fstab
	arch-chroot /mnt timedatectl set-timezone $Timezone
	arch-chroot /mnt sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
	arch-chroot /mnt  locale-gen
	arch-chroot /mnt touch /etc/locale.conf
	echo LANG=en_US.UTF-8 > /mnt/etc/locale.conf
	arch-chroot /mnt touch /etc/hostname
	arch-chroot /mnt  echo "arch" > /etc/hostname
	arch-chroot /mnt touch /etc/hosts
	arch-chroot /mnt  echo -e "127.0.0.1	localhost\n::1	localhost\n127.0.1.1	arch.localdomain	arch" >> /etc/hosts
	arch-chroot /mnt ln -s /usr/share/zoneinfo/$Timezone /etc/localtime
}

Add_user(){
	clear
	echo "Enter Password For Root :"
	arch-chroot /mnt passwd
	arch-chroot /mnt useradd -m -G wheel,storage,optical,audio,video,root -s /bin/bash $User_Name
	echo "Enter Password For $User_Name : "
	arch-chroot /mnt passwd $User_Name
	sleep 1
	#cp after_install.sh /mnt/home/$User_Name
}

Wheel(){
	read -p "Are you want give all user sudo primmion ? [Y-N]" accept_base
	if [ $(echo "$accept_base" |tr [:upper:] [:lower:]) = "y" ]; then
		arch-chroot /mnt sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
	fi
}

App(){
	arch-chroot /mnt pacman -Syu --noconfirm --needed sudo wget git dhcpcd networkmanager network-manager-applet wireless_tools wpa_supplicant ntfs-3g os-prober
	arch-chroot /mnt systemctl enable NetworkManager
}

Grub(){
	if [ $(echo "$Bios_Type" | tr [:upper:] [:lower:]) = "bios" ]; then

			arch-chroot /mnt pacman -Syu --noconfirm --needed  grub

			arch-chroot /mnt grub-install --target=i386-pc $hard

			arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
		fi
		if [ $(echo "$Bios_Type" | tr [:upper:] [:lower:]) = "uefi" ]; then

			arch-chroot /mnt pacman -Syu --noconfirm --needed grub efibootmgr
			arch-chroot /mnt  mkdir /boot/efi
			arch-chroot /mnt  mount $Boot_Partiton /boot/efi
			arch-chroot /mnt  grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
			arch-chroot /mnt  grub-mkconfig -o /boot/grub/grub.cfg


		fi

}

Ask_install_base(){
	read -p "Are you install base ? [Y-N]" accept_base
	if [ $(echo "$accept_base" |tr [:upper:] [:lower:]) = "y" ]; then
		Boot_partiton
		Make_partitons
		Mount
		Base
		Add_user
		Wheel
		App
		Grub
		XFCE
		#After_install
		After
	fi
}


KDE(){
	arch-chroot /mnt pacman -Syu --noconfirm --needed xorg plasma plasma-meta plasma-wayland-session kde-applications-meta sddm
	arch-chroot /mnt systemctl enable sddm.service
	arch-chroot /mnt systemctl enable NetworkManager.service
				
}

XFCE(){
	arch-chroot /mnt pacman -Syu --noconfirm --needed vlc xfce4 xfce4-goodies ristretto thunar-archive-plugin thunar-media-tags-plugin xfce4-battery-plugin xfce4-datetime-plugin xfce4-mount-plugin xfce4-netload-plugin xfce4-notifyd xfce4-pulseaudio-plugin xfce4-screensaver xfce4-taskmanager xfce4-wavelan-plugin xfce4-weather-plugin xfce4-whiskermenu-plugin xfce4-xkb-plugin file-roller network-manager-applet leafpad epdfview galculator capitaine-cursors arc-gtk-theme xdg-user-dirs-gtk lightdm lightdm-gtk-greeter xorg-server plank
	############## SOUND #############################
	######## URL #####  https://github.com/erikdubois/ArchXfce4/tree/master/installation  ##### https://www.youtube.com/watch?v=Rn8WgJYxsa0 ###############
	arch-chroot /mnt pacman -Syu --noconfirm --needed pulseaudio pulseaudio-alsa pavucontrol 
	arch-chroot /mnt pacman -Syu --noconfirm --needed alsa-utils alsa-plugins alsa-lib alsa-firmware
	arch-chroot /mnt pacman -Syu --noconfirm --needed gst-plugins-good gst-plugins-bad gst-plugins-base gst-plugins-ugly  gstreamer
	############### SOUND ############################
	
	arch-chroot /mnt systemctl enable lightdm.service
	arch-chroot /mnt systemctl enable NetworkManager.service
     ## xfce4 mousepad parole ristretto thunar-archive-plugin thunar-media-tags-plugin xfce4-battery-plugin xfce4-datetime-plugin xfce4-mount-plugin xfce4-netload-plugin xfce4-notifyd xfce4-pulseaudio-plugin xfce4-screensaver xfce4-taskmanager xfce4-wavelan-plugin xfce4-weather-plugin xfce4-whiskermenu-plugin xfce4-xkb-plugin file-roller network-manager-applet leafpad epdfview galculator lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings capitaine-cursors arc-gtk-theme xdg-user-dirs-gtk ##
}


DWM(){
	arch-chroot /mnt pacman -Syu --noconfirm --needed base-devel libx11 libxft xorg-server xorg-xinit xorg-xrandr xorg-xsetroot
	arch-chroot /mnt mkdir /home/$User_Name/.config
	chown 1000:1000 /mnt/home/$User_Name/.config
	arch-chroot /mnt mkdir /home/$User_Name/.config/dwm
	chown 1000:1000 /mnt/home/$User_Name/.config/dwm
	arch-chroot /mnt mkdir /home/$User_Name/.config/st
	chown 1000:1000 /mnt/home/$User_Name/.config/st
	arch-chroot /mnt mkdir /home/$User_Name/.config/dmenu
	chown 1000:1000 /mnt/home/$User_Name/.config/dmenu

	arch-chroot /mnt git clone git://git.suckless.org/dwm /home/$User_Name/.config/dwm
	arch-chroot /mnt git clone git://git.suckless.org/st /home/$User_Name/.config/st
	arch-chroot /mnt git clone git://git.suckless.org/dmenu /home/$User_Name/.config/dmenu
				
				
	#arch-chroot /mnt cd /home/$User_Name/.config/dwm && make clean install
	#sleep 2
	#arch-chroot /mnt cd /home/$User_Name/.config/st && make clean install
	#sleep 2
	#arch-chroot /mnt cd /home/$User_Name/.config/dmenu && make clean install
	#sleep 2



	arch-chroot /mnt pacman -Syu --noconfirm --needed lightdm lightdm-gtk-greeter  ## lightdm-gtk-greeter-settings
	sleep 3
	arch-chroot /mnt systemctl start lightdm.service
	sleep 3
	arch-chroot /mnt systemctl enable lightdm.service




	arch-chroot /mnt mkdir /usr/share/xsessions
	sleep 1
	arch-chroot /mnt touch /usr/share/xsessions/dwm.desktop
	sleep 2
	echo -e "[Desktop Entry]\nEncoding=UTF-8\nName=Dwm\nComment=Dynamic window manager\nExec=dwm\nIcon=dwm\nType=XSession" > /mnt/usr/share/xsessions/dwm.desktop
	sleep 2
	touch /mnt/home/$User_Name/.dmrc
	chown 1000:1000 /mnt/home/$User_Name/.dmrc
	echo -e "[Desktop]\nSession=dwm" > /mnt/home/$User_Name/.dmrc
				
				
	mkdir /mnt/home/$User_Name/.config/sxhkd
	chown 1000:1000 /mnt/home/$User_Name/.config/sxhkd
	touch /mnt/home/$User_Name/.config/sxhkd/sxhkdrc
	chown 1000:1000 /mnt/home/$User_Name/.config/sxhkd/sxhkdrc
	touch /mnt/home/$User_Name/.profile
	chown 1000:1000 /mnt/home/$User_Name/.profile
	echo -e "nitrogen --restore &\nsxhkd &" > /mnt/home/$User_Name/.profile
	## echo -e "dwm &\nnitrogen --restore &\nsxhkd" > /mnt/home/$User_Name/.profile
				
				

	## APPS ##
	arch-chroot /mnt pacman -Syu --noconfirm --needed ttf-font-awesome alsa-utils firefox nitrogen htop ntfs-3g vlc sxhkd thunar zathura zathura-pdf-poppler feh mypaint man

}

After(){
	arch-chroot /mnt pacman -Syu --noconfirm --needed git wget yajl
	
	clear
	echo "###  AFTER INSTALL ###"
	sleep 3
	arch-chroot /mnt sed -i 's/%wheel ALL=(ALL) ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
	arch-chroot /mnt <<END
#!/bin/bash
set -e
su - $USER_NAME 

########### install Yaourt ############
#cd /home/$USER_NAME && git clone https://aur.archlinux.org/package-query.git && (cd package-query && makepkg -si --noconfirm)
#cd /home/$USER_NAME && git clone https://aur.archlinux.org/yaourt.git && (cd yaourt && makepkg -si --noconfirm)
#yaourt -Syy
#######################################


########### install pamac #############
#yaourt -S pamac-aur
#######################################


########### install Yay ############
cd /home/$USER_NAME && git clone https://aur.archlinux.org/yay.git && (cd yay && makepkg -si --noconfirm)
yay -Syy
####################################


######### vala-panel-appmenu ##########
yay -S vala-panel-appmenu-common-git
yay -S vala-panel-appmenu-registrar-git
yay -S vala-panel-appmenu-xfce-git
sudo pacman -S appmenu-gtk-module
#######################################


######### panther-launcher ##########
yay -S panther-launcher-git
#####################################



}



After_install(){
	echo "###  AFTER INSTALL ###"
	############# Background ##############
	cp Background/*.* /mnt/usr/share/backgrounds/xfce/
	#######################################
	
	########### install Fonts #############
	mkdir /mnt/home/$User_Name/.fonts
	cp -r  Fonts/* /mnt/home/$User_Name/.fonts
	chown -R 1000:1000 /mnt/home/$User_Name/.fonts
	#######################################
	
	######### install Xpple Menu ##########
	cp -r xpple_menu /mnt/home/$User_Name
	chown -R 1000:1000 /mnt/home/$User_Name/xpple_menu
	#######################################
	
	########### Lanucher rofi #############
	mkdir -p /mnt/home/$User_Name/.config/rofi/launchers/misc/
	cp  rofi/*  /mnt/home/$User_Name/.config/rofi/launchers/misc/
	chown -R 1000:1000 /mnt/home/$User_Name/.config/rofi/launchers/misc/rofi/*
	#######################################
	
	arch-chroot /mnt pacman -Syu --noconfirm --needed yajl
	arch-chroot /mnt <<END
#!/bin/bash
set -e

yes | pacman -S gtk-engine-murrine sassc
yes | pacman -S rofi

sleep 5

#########  plank auto start ##########
#touch /etc/profile.d/autostart.sh 
#echo '#!/bin/bash' > /etc/profile.d/autostart.sh 
#echo 'plank &' >> /etc/profile.d/autostart.sh 
#######################################

su - $User_Name
whoami
sleep 5

##########  install Yaourt ###########
yes | sudo pacman -Syy
yes | sudo pacman -S --needed base-devel git wget yajl
cd /home/$User_Name
git clone https://aur.archlinux.org/package-query.git
cd package-query/
yes | makepkg -si && cd /home/$User_Name
sleep 5
git clone https://aur.archlinux.org/yaourt.git
cd yaourt/
yes | makepkg -si
#######################################

##########  install Pamac-aur #########
# yaourt -S pamac-aur
#######################################

sleep 5
######### vala-panel-appmenu ##########
yes | yaourt -S vala-panel-appmenu-common-git
sleep 5
yes | yaourt -S vala-panel-appmenu-registrar-git
sleep 5
yes | yaourt -S vala-panel-appmenu-xfce-git
sleep 5
yes | sudo pacman -S appmenu-gtk-module
#######################################
sleep 5

############# mugshot #################
yes | yaourt -S mugshot
#######################################
sleep 5
######### install gtk theme ###########
cd ~
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
cd WhiteSur-gtk-theme
#./install.sh -c dark -c light
#######################################
sleep 5
############# Plank Theme #############
cd ~
cd WhiteSur-gtk-theme/src/other/plank/
cp -r *  ~/.local/share/plank/themes/
#######################################
sleep 5
########### install icons #############
cd ~
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
cd WhiteSur-icon-theme
#./install.sh
#######################################
sleep 5
########### install Curser ############
cd ~
git clone https://github.com/vinceliuice/WhiteSur-cursors.git
cd WhiteSur-cursors
#./install.sh
#######################################


exit
exit

END
}




Main(){

Ask_install_base

clear
echo "install Arch linux is successfully"
sleep 5
}

Main




##################################
# how to hide shadwo for plank on xfce
# https://www.youtube.com/watch?v=cHKl-WQ265w
