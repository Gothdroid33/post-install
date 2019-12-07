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
	         2 "LAMP Stack" off
	         3 "Node.js" off
	         5 "Git" off
	         6 "Composer" off
	         7 "JDK 8" off
	         8 "Docker" off
             9 "PhpStorm" off
             10 "VsCode" off
             11 "AutoClear && AutoRemove" on)

		choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
		clear
		for choice in $choices
		do
		    case $choice in
	        1)
	            	#Install VsCode
				echo "Installing Snap for Snapcrafter"
				apt install snapd
				;;

			2)
			    	#Install LAMP stack
				echo "Installing Apache"
				apt install apache2 -y

        		echo "Installing PHP"
				apt install php libapache2-mod-php php-mbstring php-dev php-intl php-gd php-pgsql php-sqlite3 php-pear php-mysql -y
	            
        		echo "Installing Phpmyadmin"
				apt install phpmyadmin -y

				echo "Cofiguring apache to run Phpmyadmin"
				echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf
				
				echo "Enabling module rewrite"
				sudo a2enmod rewrite
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
				echo "Installing Git, please congiure git later..."
				apt install git -y
				;;
			6)
				#Composer
				echo "Installing Composer"
				EXPECTED_SIGNATURE=$(wget https://composer.github.io/installer.sig -O - -q)
				php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
				ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

				if [ "$EXPECTED_SIGNATURE" = "$ACTUAL_SIGNATURE" ]
				  then
				php composer-setup.php --quiet --install-dir=/bin --filename=composer
				RESULT=$?
				rm composer-setup.php
				else
				  >&2 echo 'ERROR: Invalid installer signature'
				  rm composer-setup.php
				fi
				;;
			7)
				#JDK 8
				echo "Installing JDK 8"
				;;
			8)
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
            9)
                #PhpStorm
                echo "Installing PhpStorm"
                snap install phpstorm --classic
                ;;
            10) 
                #VsCode
                echo "Installing VsCode"
                snap install code --classic
                ;;
            11)
                #AutoClean && AutoRemove
                echo "Clean in progress and reboot"
                apt autoclean -y && apt autoremove -y
                reboot
                ;;
			
	    esac
	done
fi
