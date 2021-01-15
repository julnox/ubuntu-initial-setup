get_latest_release() {
    #Taken From: https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c
    curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

ubuntuRepositoryInstallation (){
    sudo apt update && sudo apt -f -y install && sudo apt -y upgrade

    if [ $popos -e 0 ]
    then
        sudo apt -y install audacity blender codeblocks gedit gimp gpick gdebi-core gthumb gufw handbrake kdenlive libreoffice mysql-server-8.0 openjdk-11-jdk postgresql pgadmin3 rhythmbox steam transmission vim vlc winetricks wine-stable && sudo add-apt-repository ppa:lutris-team/lutris && sudo apt update && sudo apt -y install lutris
    else
        sudo apt -y install audacity blender codeblocks gedit gimp gpick gdebi-core gthumb gufw handbrake lutris kdenlive libreoffice mysql-server-8.0 openjdk-11-jdk postgresql pgadmin3 rhythmbox steam transmission vim vlc winetricks wine-stable
    fi
}

flatpakInstallation (){
    sudo apt-get -y install flatpak
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install flathub com.github.johnfactotum.Foliate org.telegram.desktop com.visualstudio.code
}

manualInstallation (){
    clear
    mkdir -p $HOME/Apps/
    mkdir -p $HOME/Apps/Bitwarden
    mkdir -p $HOME/Apps/Emby
    mkdir -p $HOME/Apps/icons
    cp -n ./icons/*.png $HOME/Apps/icons
    cp -n ./scripts/emby.sh $HOME/Apps/Emby
    mkdir -p files
    cd ./files

    curl -L -o bitwarden.AppImage https://vault.bitwarden.com/download/?app=desktop&platform=linux
    curl -L -o discord.deb https://discord.com/api/download?platform=linux&format=deb
    curl -L -o atom.deb https://atom.io/download/deb
    TAGNAME=$(get_latest_release "MediaBrowser/Emby.Releases") && ENDSTRING="_amd64.deb" && LOCATION="https://github.com/MediaBrowser/Emby.Releases/releases/latest/download/emby-server-deb_$TAGNAME$ENDSTRING";
    curl -L -o emby.deb $LOCATION

    sudo gdebi *.deb

    echo -e "[Desktop Entry]\nName=Bitwarden\nComment=Password Manager\nExec=$HOME/Apps/Bitwarden/bitwarden.AppImage\nIcon=$HOME/Apps/icons/bitwarden.png\nTerminal=false\nType=Application\nCategories=Utility;GTK;" >> bitwarden.desktop
    echo -e "[Desktop Entry]\nName=Emby\nComment=Media Server\nExec=sh $HOME/Apps/Emby/emby.sh\nIcon=$HOME/Apps/icons/emby.png\nTerminal=true\nType=Application\nCategories=Video;Audio;Network;" >> emby.desktop

    chmod 775 *.AppImage
    cp -n bitwarden.AppImage $HOME/Apps/Bitwarden/
    cp -n *.desktop $HOME/.local/share/applications
    cd ..
}

echo "You're about to install a lot of programs, this was made to use once in a recent Ubuntu or Ubuntu derivative installation and assuming you're using Gnome Desktop Envrioment\n"
echo "Are you sure you want to continue? (Y/N) [Default=N]"
read ANSWERCONTINUE
if [ $ANSWERCONTINUE = "Y" -o $ANSWERCONTINUE = "y" ]
then
    clear
    echo "List of Ubuntu repository programs: "
    echo "Audacity, Blender, CodeBlocks, Gedit, Gdebi, GIMP, gPick, Gthumb, Gufw, HandBrake, Java JDK, Kdenlive, LibreOffice, MySQL, pgAdmin3, PostgreSQL, Rhythmbox, Steam, Transmission, VIM, VLC, Wine, Winetricks"

    echo "\nList of Flatpak programs: "
    echo "Foliate, Telegram, Visual Studio Code"

    echo "\nList of Manual installation programs: "
    echo "Atom, Bitwarden, Discord, Emby Server, Lutris (if not in Pop_Os)"

    echo "\nAre you using Pop_OS? (Y/N) [Default=Y]"
    read ANSWERPOPOS
    if [ $ANSWERPOPOS = "N" -o $ANSWERPOPOS = "n" ]
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
    echo "Do you wish to clean all unnecessary files of the installation? (Y/N) [Default=Y]"
    read ANSWERCLEAN
    if [ $ANSWERCLEAN = "N" -o $ANSWERCLEAN = "n" ]
    then
        exit
    else
        cd ..
        rm -r ubuntu-initial-setup/
    fi
else
    exit
fi
