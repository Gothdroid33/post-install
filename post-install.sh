#!/bin/bash

PHP_VERSION="7.4"

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
	         4 "Git" off
	         5 "Composer" off
	         6 "Docker" off
             	 7 "PhpStorm" off
             	 8 "VsCode" off
               	 9 "AutoClear && AutoRemove" on)

		choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
		clear
		for choice in $choices
		do
		    case $choice in
	        1)
	            		#Install Snap
				echo "Installing Snap for Snapcrafter"
				apt install snapd -y
				;;

			2)
			    	#Install Apache & Php
				echo "Installing Apache"
				add-apt-repository ppa:ondrej/apache2 -y
				apt update
				apt install apache2 -y

        			echo "Installing PHP"
				add-apt-repository ppa:ondrej/php -y
				apt update
				apt install php$PHP_VERSION libapache2-mod-php php$PHP_VERSION-mbstring php$PHP_VERSION-dev php$PHP_VERSION-intl php$PHP_VERSION-gd php$PHP_VERSION-zip php$PHP_VERSION-pgsql php$PHP_VERSION-sqlite3 php-pear php$PHP_VERSION-mysql -y
				php -v
				echo "Enabling module rewrite"
				sudo a2enmod rewrite
				echo "Enabling module proxy"
				sudo a2enmod proxy proxy_http
				echo "Restarting Apache Server"
				service apache2 restart
				;;
  				
			3)
				#Install Nodejs
				echo "Installing Nodejs"
				curl -sL https://deb.nodesource.com/setup_15.x | sudo -E bash -
				apt install -y nodejs
                		npm i -g yarn
				;;

			4)
				#Install git
				echo "Installing Git, please congigure git later..."
				apt install git -y
				;;
			5)
				#Composer
				echo "Installing Composer"
				php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
				php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
				php composer-setup.php
				php -r "unlink('composer-setup.php');"
				mv composer.phar /usr/local/bin/composer
				;;
	
			6)
				#Docker
				echo "Installing Docker"
				apt remove docker docker-engine docker.io containerd runc -y
                		apt update
                		apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-agent -y
                		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
                		add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
                		apt update
                		apt install docker-ce docker-ce-cli containerd.io docker-compose -y
                		adduser $SUDO_USER docker
				;;
            		7)
                		#PhpStorm
                		echo "Installing PhpStorm"
                		snap install phpstorm --classic
                		;;
            		8) 
                		#VsCode
                		echo "Installing VsCode"
                		snap install code --classic
                		;;
            		9)
                		#AutoClean && AutoRemove
                		echo "Clean in progress and reboot"
                		apt autoclean -y && apt autoremove -y
                		reboot
                		;;
			
	    esac
	done
fi
