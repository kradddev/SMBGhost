#!/usr/bin/env bash

#
#IPS from nmap to ipsSMBV3.txt
#

# Define colors
greenc=`tput setaf 2`	# OK
redc=`tput setaf 1`	# FAIL
yellowc=`tput setaf 3`	# WARNING
resetc=`tput sgr0`

#Requirements.
function requirements
{
    apt install nmap
    pip3 install netaddr
    if [ $? -eq 1 ];
    then
        echo "${$redc}[-] Problems installing requirements${resetc}"
    fi
}

which nmap
if [ $? -eq 1 ];
then
    echo "${redc}[-] Nmap is not installed${resetc}"
    read -p "Do you want install it? (Y/N)" inmap
    
    if [ "$inmap" == "Y" || "$inmap" == "y" ]; 
    then
        requirements
    else
        echo "${yellowc}[-] Exiting...${resetc}"
        exit 0;
    fi
else
    echo "${greenc}[+] Nmap is installed${resetc}"
fi

read -p "Type network ip (Example: 10.10.10.0): " ip
read -p "Type network mask (Example: /24): " mask

clear
echo "${greenc}[+] Running nmap...${resetc}"
nmap -n -sn $ip"/"$mask -oG - | awk '/Up$/{print $2}' > ipsSMBV3.txt
if [ $? -eq 1 ];
then
    "[-] Problems running nmap scan"
    exit 1;
fi

echo "${greenc}[+] Running Scanner.py...${resetc}"
python3 scanner.py ipsSMBV3.txt
if [ $? -eq 1 ];
then
    echo "${redc}[-] Problems running scanner.py${resetc}"
    exit 1;
fi
