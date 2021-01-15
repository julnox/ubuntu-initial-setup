get_latest_release() {
	#Taken From: https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

ubuntuRepositoryInstallation () {
	sudo apt update && sudo apt-get -f -y upgrade
 	
 	if [ $popos -e 0 ] 
 	then
		sudo apt-get -f -y install audacity blender codeblocks gedit gimp gpick gthumb gufw handbrake kdenlive libreoffice mysql openjdk-11-jdk postgresql pgadmin3 rhythmbox steam transmission vim vlc winetricks wine-stable && sudo add-apt-repository ppa:lutris-team/lutris && sudo apt update && sudo apt install lutris
	else 
		sudo apt-get -f -y install audacity blender codeblocks gedit gimp gpick gthumb gufw handbrake lutris kdenlive libreoffice mysql openjdk-11-jdk postgresql pgadmin3 rhythmbox steam transmission vim vlc winetricks wine-stable
	fi
}

flatpakInstallation (){
	sudo apt-get -f -y install flatpak && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && flatpak install flathub com.github.johnfactotum.Foliate org.telegram.desktop com.visualstudio.code
}

manualInstallation (){
	
	clear
	cd $HOME
 	mkdir manual-install
 	cd manual-install
 	
	curl -L -o bitwarden.AppImage https://vault.bitwarden.com/download/?app=desktop&platform=linux
	curl -L -o bitwarden.png https://images.sftcdn.net/images/t_app-cover-m,f_auto/p/fcec8b2d-e0a4-48dc-91fe-1a9ff0840ae8/1319010454/bitwarden-screenshot.png
	curl -L -o discord.deb https://discord.com/api/download?platform=linux&format=deb

	TAGNAME=$(get_latest_release "MediaBrowser/Emby.Releases") && ENDSTRING="_amd64.deb" && LOCATION="https://github.com/MediaBrowser/Emby.Releases/releases/latest/download/emby-server-deb_$TAGNAME$ENDSTRING"; curl -L -o emby.deb $LOCATION
	
	dpkg -i *.deb
	
	echo "[Desktop Entry]
Name=Bitwarden
Comment=Password Manager
Exec=$HOME/Apps/Bitwarden/Bitwarden.AppImage
Icon=$HOME/Apps/Bitwarden/bitwarden.png
Terminal=false
Type=Application
Categories=Utility;GTK;" >> bitwarden.desktop
	
	chmod 775 *.desktop
	mv ./*.desktop $HOME/.local/share/applications
}

echo "You're about to install a lot of programs, this was made to use once in a recent Ubuntu or Ubuntu derivative installation and assuming you're using Gnome Desktop Envrioment\n"
echo "Are you sure you want to continue? (Y/N) [Default=N]"
read ANSWERCONTINUE
if [ $ANSWERCONTINUE -e "Y" -o $ANSWERCONTINUE -e "y" ] 
	then
		clear
		echo "List of Ubuntu repository programs: "
		echo "Audacity, Blender, CodeBlocks, Gedit, GIMP, gPick, Gthumb, Gufw, HandBrake, Java JDK, Kdenlive, LibreOffice, MySQL, pgAdmin3, PostgreSQL, Rhythmbox, Steam, Transmission, VIM, VLC, Wine, Winetricks"
		
		echo "\nList of Flatpak programs: "
		echo "Foliate, Telegram, Visual Studio Code"
		
		echo "\nList of Manual installation programs: "
		echo "Bitwarden, Discord, Emby Server, Lutris (if not in Pop_Os)"
		
		echo "\nAre you using Pop_OS? (Y/N) [Default=Y]"
		read ANSWERPOPOS
		if [ $ANSWERPOPOS -e "N" -o "n" ] 
		then
			popos=0
		else
			popos=1
		fi
		
		ubuntuRepositoryInstallation
		flatpakInstallation
		manualInstallation
		
		clear
		echo "Programs not installed, but recommended: Eclipse, XAMPP, MySQL Workbench"
		exit
		
else
	exit
fi
