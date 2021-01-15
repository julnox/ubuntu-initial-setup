actions () {
	clear
	echo 'Type (1) to start Emby Server'
	echo 'Type (2) to stop Emby Server'
	echo 'Type (3) to see Emby Server status'
	echo 'Type any other key to exit'
	
	read CHOICE
	
	case $CHOICE in
		1)
			sudo systemctl start emby-server
			clear
			echo '\nServer Initiated Sucessfully'
			echo 'Press any key to return to main menu'
			read dummy
			;;
		2)
			sudo systemctl stop emby-server
			clear
			echo '\nServer Stopped Sucessfully'
			echo 'Press any key to return to main menu'
			read dummy
			;;
		3)
			clear
			systemctl status emby-server
			;;
		*)
			exit
			;;
	esac
}

actions
while [ $CHOICE -ge 1 -a $CHOICE -le 3 ]; do 
	actions
done
