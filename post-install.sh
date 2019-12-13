#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   	echo "This script must be run as root" 
   	exit 1
else
	#Update and Upgrade
	echo "Updating and Upgrading"
	apt-get update && sudo apt-get upgrade -y

	sudo apt-get install dialog
	cmd=(dialog --separate-output --checklist "Please Select Software you want to install:" 22 76 16)
	options=(1 "Snap" off    
	         2 "Apache & Php" off
	         3 "Node.js" off
	         5 "Git" off
	         6 "Composer" off
	         7 "Docker" off
             	 8 "PhpStorm" off
             	 9 "VsCode" off
               	 10 "AutoClear && AutoRemove" on)

		choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
		clear
		for choice in $choices
		do
		    case $choice in
	        1)
	            	#Install VsCode
				echo "Installing Snap for Snapcrafter"
				apt install snapd -y
				;;

			2)
			    	#Install Apache & Php
				echo "Installing Apache"
				apt install apache2 -y

        		echo "Installing PHP"
				apt install php libapache2-mod-php php-mbstring php-dev php-intl php-gd php-pgsql php-sqlite3 php-pear php-mysql -y
				php -v
				echo "Enabling module rewrite"
				sudo a2enmod rewrite
				echo "Enabling module proxy"
				sudo a2enmod proxy proxy_http
				echo "Restarting Apache Server"
				service apache2 restart
				;;
    		3)	
				#Install Build Essentials
				echo "Installing Build Essentials"
				apt install -y build-essential
				;;
				
			4)
				#Install Nodejs
				echo "Installing Nodejs"
				curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
				apt install -y nodejs
                npm i -g yarn
				;;

			5)
				#Install git
				echo "Installing Git, please congigure git later..."
				apt install git -y
				;;
			6)
				#Composer
				echo "Installing Composer"
				apt install composer -y
				;;
	
			7)
				#Docker
				echo "Installing Docker"
				apt remove docker docker-engine docker.io containerd runc -y
                apt update
                apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-agent -y
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
                add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
                apt update
                apt install docker-ce docker-ce-cli containerd.io docker-compose
                adduser $SUDO_USER docker
				;;
            8)
                #PhpStorm
                echo "Installing PhpStorm"
                snap install phpstorm --classic
                ;;
            9) 
                #VsCode
                echo "Installing VsCode"
                snap install code --classic
                ;;
            10)
                #AutoClean && AutoRemove
                echo "Clean in progress and reboot"
                apt autoclean -y && apt autoremove -y
                reboot
                ;;
			
	    esac
	done
fi
