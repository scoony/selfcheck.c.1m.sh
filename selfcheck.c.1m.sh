#!/usr/bin/env bash

version="0.0.0.27"


## NOTIFICATION: zenity  --notification  --window-icon=update.png  --text "message"

#### Cleaning
if [[ -f "~/selfcheck-update.sh" ]]; then
  rm -f $HOME/selfcheck-update.sh
fi

#### Autoupdate Process
script_pastebin="https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/selfcheck.c.1m.sh"
local_version=$version
pastebin_version=`wget -O- -q "$script_pastebin" | grep "^version=" | sed '/grep/d' | sed 's/.*version="//' | sed 's/".*//'`

#### Comparing versions and updating if required
vercomp () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}
testvercomp () {
    vercomp $1 $2
    case $? in
        0) op='=';;
        1) op='>';;
        2) op='<';;
    esac
    if [[ $op != $3 ]]
    then
        echo "FAIL: Expected '$3', Actual '$op', Arg1 '$1', Arg2 '$2'"
    else
        echo "Pass: '$1 $op $2'"
    fi
}
compare=`testvercomp $local_version $pastebin_version '<' | grep Pass`
if [[ "$compare" != "" ]] ; then
  update_required="Mise à jour disponible"
  (
  echo "# Creation de l'updater." ; sleep 2
  touch ~/selfcheck-update.sh
  echo "25"
  echo "# Chmod de l'updater." ; sleep 2
  chmod +x ~/selfcheck-update.sh
  echo "50"
  echo "# Edition de l'updater." ; sleep 2
  echo "#!/bin/bash" > ~/selfcheck-update.sh
  echo "(" >> ~/selfcheck-update.sh
  echo "echo \"75\"" >> ~/selfcheck-update.sh
  echo "echo \"# Mise à jour en cours.\" ; sleep 2" >> ~/selfcheck-update.sh
  echo "curl -o ~/.config/argos/selfcheck.c.1m.sh $script_pastebin" >> ~/selfcheck-update.sh
  echo "sed -i -e 's/\r//g' ~/.config/argos/selfcheck.c.1m.sh" >> ~/selfcheck-update.sh
  echo "echo \"100\"" >> ~/selfcheck-update.sh
  echo ") |" >> ~/selfcheck-update.sh
  echo "zenity --progress \\" >> ~/selfcheck-update.sh
  echo "  --title=\"Mise à jour de SelfCheck\" \\" >> ~/selfcheck-update.sh
  echo "  --text=\"Démarrage du processus.\" \\" >> ~/selfcheck-update.sh
  echo "  --percentage=0 \\" >> ~/selfcheck-update.sh
  echo "  --auto-close \\" >> ~/selfcheck-update.sh
  echo "  --auto-kill" >> ~/selfcheck-update.sh
  echo "75"
  echo "# Lancement de l'updater." ; sleep 2
  bash ~/selfcheck-update.sh
  exit 1
) |
zenity --progress \
  --title="Mise à jour de SelfCheck" \
  --text="Démarrage du processus." \
  --percentage=0 \
  --auto-close \
  --auto-kill
fi

#### Declaring the push function
## usage: push-message "title" "message"
push-message() {
  push_title=$1
  push_content=$2
  token_app=`cat ~/.config/argos/.selfcheck-pushover | awk '{print $1}'`
  destinataire_1=`cat ~/.config/argos/.selfcheck-pushover | awk '{print $2}'`
  destinataire_2=`cat ~/.config/argos/.selfcheck-pushover | awk '{print $3}'`
  zenity --notification --window-icon="$HOME/.config/argos/.cache-icons/selfcheck.png" --text "$push_content" 2>/dev/null
  for user in {1..10}; do
    destinataire=`eval echo "\\$destinataire_"$user`
    if [ -n "$destinataire" ]; then
      curl -s \
        --form-string "token=$token_app" \
        --form-string "user=$destinataire" \
        --form-string "title=$push_title" \
        --form-string "message=$push_content" \
        --form-string "html=1" \
        --form-string "priority=0" \
        https://api.pushover.net/1/messages.json > /dev/null
    fi
  done
}


#### Get services list
list_services=`cat ~/.config/argos/.selfcheck-services 2>/dev/null | sed 's/|/ /g'`

#### Check icons cache (or create)
icons_cache=`echo $HOME/.config/argos/.cache-icons`
if [[ ! -f "$icons_cache" ]]; then
  mkdir -p $icons_cache
fi
if [[ ! -f "$icons_cache/motherboard.png" ]] ; then curl -o "$icons_cache/motherboard.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/motherboard.png" ; fi
if [[ ! -f "$icons_cache/cpu.png" ]] ; then curl -o "$icons_cache/cpu.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/cpu.png" ; fi
if [[ ! -f "$icons_cache/ram.png" ]] ; then curl -o "$icons_cache/ram.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/ram.png" ; fi
if [[ ! -f "$icons_cache/gpu.png" ]] ; then curl -o "$icons_cache/gpu.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/gpu.png" ; fi
if [[ ! -f "$icons_cache/ubuntu.png" ]] ; then curl -o "$icons_cache/ubuntu.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/ubuntu.png" ; fi
if [[ ! -f "$icons_cache/rj45.png" ]] ; then curl -o "$icons_cache/rj45.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/rj45.png" ; fi
if [[ ! -f "$icons_cache/wifi.png" ]] ; then curl -o "$icons_cache/wifi.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/wifi.png" ; fi
if [[ ! -f "$icons_cache/net_speed.png" ]] ; then curl -o "$icons_cache/net_speed.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/net_speed.png" ; fi
if [[ ! -f "$icons_cache/net.png" ]] ; then curl -o "$icons_cache/net.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/net.png" ; fi
if [[ ! -f "$icons_cache/hdd.png" ]] ; then curl -o "$icons_cache/hdd.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/hdd.png" ; fi
if [[ ! -f "$icons_cache/ssd.png" ]] ; then curl -o "$icons_cache/ssd.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/ssd.png" ; fi
if [[ ! -f "$icons_cache/usb.png" ]] ; then curl -o "$icons_cache/usb.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/usb.png" ; fi
if [[ ! -f "$icons_cache/service.png" ]] ; then curl -o "$icons_cache/service.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/service.png" ; fi
if [[ ! -f "$icons_cache/selfcheck.png" ]] ; then curl -o "$icons_cache/selfcheck.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/selfcheck.png" ; fi
if [[ ! -f "$icons_cache/selfcheck_bad.png" ]] ; then curl -o "$icons_cache/selfcheck_bad.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/selfcheck_bad.png" ; fi
if [[ ! -f "$icons_cache/user.png" ]] ; then curl -o "$icons_cache/user.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/user.png" ; fi
if [[ ! -f "$icons_cache/user_sudo.png" ]] ; then curl -o "$icons_cache/user_sudo.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/user_sudo.png" ; fi
if [[ ! -f "$icons_cache/uptime.png" ]] ; then curl -o "$icons_cache/uptime.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/uptime.png" ; fi
if [[ ! -f "$icons_cache/vpn.png" ]] ; then curl -o "$icons_cache/vpn.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/vpn.png" ; fi
if [[ ! -f "$icons_cache/dns.png" ]] ; then curl -o "$icons_cache/dns.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/dns.png" ; fi
if [[ ! -f "$icons_cache/background.png" ]] ; then curl -o "$icons_cache/background.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/background.png" ; fi
if [[ ! -f "$icons_cache/x64.png" ]] ; then curl -o "$icons_cache/x64.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/x64.png" ; fi
if [[ ! -f "$icons_cache/x86.png" ]] ; then curl -o "$icons_cache/x86.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/x86.png" ; fi
if [[ ! -f "$icons_cache/kernel.png" ]] ; then curl -o "$icons_cache/kernel.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/kernel.png" ; fi
if [[ ! -f "$icons_cache/version.png" ]] ; then curl -o "$icons_cache/version.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/version.png" ; fi
if [[ ! -f "$icons_cache/settings.png" ]] ; then curl -o "$icons_cache/settings.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/settings.png" ; fi
if [[ ! -f "$icons_cache/local_ip.png" ]] ; then curl -o "$icons_cache/local_ip.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/local_ip.png" ; fi
if [[ ! -f "$icons_cache/health.png" ]] ; then curl -o "$icons_cache/health.png" "https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.cache-icons/health.png" ; fi

#### Get my script icon
SELFCHECK_ICON=$(curl -s "file://$icons_cache/selfcheck.png" | base64 -w 0)
SELFCHECK_ICON_BAD=$(curl -s "file://$icons_cache/selfcheck_bad.png" | base64 -w 0)
BACKGROUND_IMAGE=$(curl -s "file://$icons_cache/background.png" | base64 -w 0)
HDD_ICON=$(curl -s "file://$icons_cache/hdd.png" | base64 -w 0)
SSD_ICON=$(curl -s "file://$icons_cache/ssd.png" | base64 -w 0)
USB_ICON=$(curl -s "file://$icons_cache/usb.png" | base64 -w 0)
NET_ICON=$(curl -s "file://$icons_cache/net.png" | base64 -w 0)
CPU_ICON=$(curl -s "file://$icons_cache/cpu.png" | base64 -w 0)
RAM_ICON=$(curl -s "file://$icons_cache/ram.png" | base64 -w 0)
MOTHERBOARD_ICON=$(curl -s "file://$icons_cache/motherboard.png" | base64 -w 0)
OS_ICON=$(curl -s "file://$icons_cache/ubuntu.png" | base64 -w 0)
GPU_ICON=$(curl -s "file://$icons_cache/gpu.png" | base64 -w 0)
USER_ICON=$(curl -s "file://$icons_cache/user.png" | base64 -w 0)
USER_SUDO_ICON=$(curl -s "file://$icons_cache/user_sudo.png" | base64 -w 0)
RJ45_ICON=$(curl -s "file://$icons_cache/rj45.png" | base64 -w 0)
WIFI_ICON=$(curl -s "file://$icons_cache/wifi.png" | base64 -w 0)
ETH_SPEED=$(curl -s "file://$icons_cache/net_speed.png" | base64 -w 0)
SERVICES_ICON=$(curl -s "file://$icons_cache/service.png" | base64 -w 0)
UPTIME_ICON=$(curl -s "file://$icons_cache/uptime.png" | base64 -w 0)
VPN_ICON=$(curl -s "file://$icons_cache/vpn.png" | base64 -w 0)
DNS_ICON=$(curl -s "file://$icons_cache/dns.png" | base64 -w 0)
X86_ICON=$(curl -s "file://$icons_cache/x86.png" | base64 -w 0)
X64_ICON=$(curl -s "file://$icons_cache/x64.png" | base64 -w 0)
KERNEL_ICON=$(curl -s "file://$icons_cache/kernel.png" | base64 -w 0)
VERSION_ICON=$(curl -s "file://$icons_cache/version.png" | base64 -w 0)
SETTINGS_ICON=$(curl -s "file://$icons_cache/settings.png" | base64 -w 0)
LOCAL_IP_ICON=$(curl -s "file://$icons_cache/local_ip.png" | base64 -w 0)
HEALTH_ICON=$(curl -s "file://$icons_cache/health.png" | base64 -w 0)

#### Get Hardware informations
cpu_info_raw=`lscpu | grep "modèle" | cut -d':' -f2- - | sed -e 's/^[ \t]*//'`
if [[ "$cpu_info_raw" =~ "-" ]]; then
  cpu_type=`echo $cpu_info_raw | sed 's/-.*//' | sed 's/(R)//' | sed 's/(TM)//'`
  cpu_model=`echo $cpu_info_raw | sed 's/.*-//' | sed 's/ CPU//'`
else
  cpu_type=`echo $cpu_info_raw | sed 's/ CPU.*//' | sed 's/(R)//' | sed 's/(TM)//'`
  cpu_model=`echo $cpu_info_raw | sed 's/.*CPU //'`
fi
ram_amount=`free -h --si | sed '/Mem:/!d' | awk '{print $2}' | sed 's/G/ Go/'`
gpu_info=`glxinfo | grep "OpenGL renderer string" | sed 's/.*string: //' | sed 's/\/.*$//'`
motherboard_brand=`cat /sys/devices/virtual/dmi/id/board_vendor`
motherboard_model=`cat /sys/devices/virtual/dmi/id/board_name`

#### Get Software infos
os_type=`lsb_release -i --short`
os_version=`lsb_release -r --short`
os_arch=`uname -m`
os_kernel_raw=`uname -r`
os_uptime=`awk '{printf("%d:%02d:%02d:%02d\n",($1/60/60/24),($1/60/60%24),($1/60%60),($1%60))}' /proc/uptime`

#### Get users infos
users=`getent passwd | grep "1[0-9][0-9][0-9]" | awk -F':' '{ print $1}' | sed '/uuidd/d'`
users_amount=`getent passwd | grep "1[0-9][0-9][0-9]" | awk -F':' '{ print $1}' | sed '/uuidd/d' | wc -l`
users_sudo=`grep '^sudo' /etc/group`

#### Get overall HDD capacity
overall_hdd=`df --total -hl | grep "total" | awk '{print $2}' | sed 's/T/ To/' | sed 's/G/ Go/'`

#### Get overall Free capacity
overall_free=`df --total -hl | grep "total" | awk '{print $4}' | sed 's/T/ To/' | sed 's/G/ Go/'`

#### Get HDD bad sectors
## require user in group disk and visudo to allow sudo smartctl without pass
##smartctl_no_root=`sudo -n smartctl 2>&1 | grep "^sudo:"`
if [[ "$smartctl_no_root" == "" ]]; then
  smart_drive=()
  smart_status=()
  smart_pending=()
  smart_offline=()
  smart_reallocated=()
  smart_temperature=()
  for hdd in {a..z}; do
    smart_drive_name=`echo "sd"$hdd | tr '[:lower:]' '[:upper:]'`
    smart_drive+=("$smart_drive_name")
    sudo smartctl --all /dev/sd$hdd | sed 's/([^()]*)//g' > ~/smart-info.txt
    smart_status_drive=`cat ~/smart-info.txt | grep "SMART overall-health " | awk '{print $NF}'`
    smart_status+=("$smart_status_drive")
    smart_pending_sectors=`cat ~/smart-info.txt | grep "^197 " | awk '{print $NF}'`
    smart_pending+=("$smart_pending_sectors")
    smart_offline_uncorrectable=`cat ~/smart-info.txt | grep "^198 " | awk '{print $NF}'`
    smart_offline+=("$smart_offline_uncorrectable")
    smart_reallocated_sector=`cat ~/smart-info.txt | grep "5 Reallocated" | awk '{print $NF}'`
    smart_reallocated+=("$smart_reallocated_sector")
    smart_temperature_drive=`cat ~/smart-info.txt | grep "^194 " | awk '{print $NF}'`
    smart_temperature+=("$smart_temperature_drive")
  done
fi

#### Get scripts in crontab
##echo "eval '/bin/echo $root_pass | /usr/bin/sudo -S /usr/bin/crontab -l'" > ~/cron.sh
##eval 'bash ~/cron.sh' | tee -a ~/cron.txt
##eval '/bin/echo $root_pass | /usr/bin/sudo -S /usr/bin/crontab -l' | tee -a ~/cron.txt
##cat ~/cron.txt | grep -iE "^\@|^[0-9]|^\*" | sed 's/>.*//' | sed 's/--.*//' | awk '{print $NF}' | rev | cut -d"/" -f1 | rev | cut -d"." -f1 | sort -u | awk '{print $1}' > ~/scripts.txt
##my_scripts=()
##while IFS= read -r -d $'\n'; do
##  my_scripts+=("$REPLY")
##done <~/scripts.txt
##rm -f ~/scripts.txt
##rm -f ~/cron.sh
##rm -f ~/cron.txt

#### Check network details
local_ip=`hostname -I | cut -d' ' -f1`
network_eth=`ip addr show | grep "state UP" | awk '{print $2}' | sed 's/:$//'`
speed_eth=`cat /sys/class/net/$network_eth/speed`
ETH_DEVICE=$RJ45_ICON
if [[ "$network_eth" =~ "wlo" ]]; then
  speed_eth=`iwconfig $network_eth | grep "Bit Rate" | awk '{print $2 $3}' | sed 's/.*Rate=//'`
  ETH_DEVICE=$WIFI_ICON
fi
vpn_eth=`ifconfig | grep "tun[0-9]" | sed 's/:.*//'`
dns_eth=`dig yourserver.somedomain.xyz | grep "SERVER:" | awk '{print $3}' | sed 's/#.*//'`
if [[ "$dns_eth" == "127.0.0.53" ]]; then
  dns_eth=`cat /run/systemd/resolve/resolv.conf | grep "nameserver" | sed '/grep/d' | sed -n '1p' | awk '{print $2}'`
fi

#### Check IP (for VPN)
local_ip=`hostname -I | cut -d' ' -f1`
router_ip=`dig -b $local_ip +short myip.opendns.com @resolver1.opendns.com`
if [[ "$vpn_eth" != "" ]]; then
  current_ip=`dig +short myip.opendns.com @resolver1.opendns.com`
  if [[ "$current_ip" == "" ]]; then
    current_ip=`dig -4 +short myip.opendns.com @resolver1.opendns.com`
  fi
  if [[ "$router_ip" == "$current_ip" ]]; then
    ERROR="1"
    main_title="VPN Désactivé"
    push-message "SelfCheck" "Le VPN est désactivé"
  fi
fi

#### HDD Sizes and mount points
size_drive_size=()
size_current_drive=()
size_mount_point=()
size_usb=()
size_ssd=()
for hdd in {a..z}; do
  current_drive=`echo "/dev/sd"$hdd`
  check_usb_drive=`readlink /sys/block/sd$hdd | grep "usb"`
  if [ -e $current_drive ]; then
    mount_point=`cat /etc/mtab | grep "$current_drive" | sed '/grep/d' | sed -n '1p' | awk '{print $2}'`
    drive_size=`df -h $mount_point | sed -n '2p' | awk '{print $2}' | sed 's/T/ To/' | sed 's/G/ Go/' | sed 's/M/ Mo/'`
    drive_ssd=`cat /sys/block/sd$hdd/queue/rotational`
    size_drive_size+=("$drive_size")
    size_current_drive+=("$current_drive")
    size_mount_point+=("$mount_point")
    size_usb+=("$check_usb_drive")
    size_ssd+=("$drive_ssd")
  fi
done

#### FREE Sizes and mount points
free_drive_size=()
free_current_drive=()
free_mount_point=()
free_usb=()
free_ssd=()
for hdd in {a..z}; do
  current_drive=`echo "/dev/sd"$hdd`
  check_usb_drive=`readlink /sys/block/sd$hdd | grep "usb"`
  if [ -e $current_drive ]; then
    mount_point=`cat /etc/mtab | grep "$current_drive" | sed '/grep/d' | sed -n '1p' | awk '{print $2}'`
    drive_free=`df -h $mount_point | sed -n '2p' | awk '{print $4}' | sed 's/T/ To/' | sed 's/G/ Go/' | sed 's/M/ Mo/'`
    drive_ssd=`cat /sys/block/sd$hdd/queue/rotational`
    free_drive_size+=("$drive_free")
    free_current_drive+=("$current_drive")
    free_mount_point+=("$mount_point")
    free_usb+=("$check_usb_drive")
    free_ssd+=("$drive_ssd")
  fi
done

#### Checking services
my_service_name=()
my_service_status=()
my_service_pid=()
for service in $list_services; do
  service_status=`service $service status | grep "active (running)"`
  service_pid=`service $service status | grep "Main PID" | sed '/grep/d' | awk '{print $3}'`
  if [[ "$service_pid" == "" ]]; then
    service_pid=`service $service status | grep "["$'\xe2\x94\x94'"-"$'\xe2\x94\x80'"]" | sed '/grep/d' | awk '{print $1}' | grep -Eo '[0-9]{1,5}'`
  fi
  my_service_name+=("$service")
  my_service_pid+=("$service_pid")
  if [[ "$service_status" != "" ]]; then
    my_service_status+=("Actif")
  else
    my_service_status+=("Inactif")
    ERROR="1"
    main_title="Service(s) Inactif(s)"
    push-message "SelfCheck" "Le service $service ne répond plus"
  fi
done
my_service_amount=`echo $list_services | wc -w`

#### Create Settings
settings_services=`echo "zenity  --list  --title=\"Paramètres des services\" --text \"Quels services voulez vous surveiller?\" --width=600 --height=400 --checklist --column \"Choix\" --column \"Services\" $(systemctl list-units --type service | grep "loaded active running" | awk '{print $1}' | sed 's/.service//' | sort -u | sed ':a;N;$!ba;s/\n/ FALSE /g' | sed 's/^/FALSE /') 2>/dev/null >~/.config/argos/.selfcheck-services"`
##smart_info=`echo "zenity --warning --text \"Le status des disques dur ne peut être obtenu que via les privilèges du compte root.\n\nAfin de pouvoir les surveiller il faut:\n- ajouter l'utilisateur dans le groupe "disk"\n  addgroup -a disk $(whoami)\n- authoriser l'utilisation de sudo avec smarctl sans mot de passe\n  ajouter \"%sudo   ALL = (ALL) NOPASSWD: /usr/sbin/smartctl\" à la fin de visudo\""`
echo "" > $HOME/root_warning.txt
cat <<EOT >> $HOME/root_warning.txt
ATTENTION !!


Le status des disques dur ne peut être obtenu que via les privilèges du compte root.

Afin de pouvoir les surveiller il faut:
- ajouter l'utilisateur dans le groupe "disk"
  addgroup -a disk $(whoami)
- authoriser l'utilisation de sudo avec smarctl sans mot de passe
  ajouter "%sudo   ALL = (ALL) NOPASSWD: /usr/sbin/smartctl" à la fin dans la commande "visudo"

EOT
smart_info=`echo -e "zenity --text-info --width=700 --height=400 --title \"Root required\" --filename \"$HOME/root_warning.txt\""`
push_settings=`echo -e "zenity --forms --width=500 --window-icon=\"~/.config/argos/.cache-icons/selfcheck.png\" --title=\"Paramètres PushOver\" --text=\"Vos clés PushOver\rDisponibles sur le site http://www.pushover.net\" --add-entry=\"API Key\" --add-entry=\"User_1 Key\" --add-entry=\"User_2 Key\" --separator=\" \" 2>/dev/null >~/.config/argos/.selfcheck-pushover"`

#### Affichage
if [[ "$ERROR" == "" ]]; then
  echo -e "SelfCheck | image='$SELFCHECK_ICON' imageWidth=25" 
else
  echo -e "\e[41m $main_title \e[0m | image='$SELFCHECK_ICON_BAD' imageWidth=25"
fi
echo "---"

printf "%s | ansi=true font='Ubuntu Mono' trim=false size=22 terminal=false image=$BACKGROUND_IMAGE imageWidth=200 \n" "$HOSTNAME"
echo "---"
printf "%70s | ansi=true font='Ubuntu Mono' trim=false size=8 \n" "version: $version"
echo "---"

#### Hardware infos
printf "\e[1m%-25s\e[0m | ansi=true font='Ubuntu Mono' trim=false \n" "Informations Materiel"
printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "Carte Mere (marque)" "$motherboard_brand" "$MOTHERBOARD_ICON"
printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "Carte Mere (modele)" "$motherboard_model" "$MOTHERBOARD_ICON"
printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "CPU (type)" "$cpu_type" "$CPU_ICON"
printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "CPU (modele)" "$cpu_model" "$CPU_ICON"
printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "RAM (total)" "$ram_amount" "$RAM_ICON"
printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "GPU (modele)" "$gpu_info" "$GPU_ICON"

#### Software infos
printf "\e[1m%-25s\e[0m | ansi=true font='Ubuntu Mono' trim=false \n" "Informations Logiciel"
printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "OS (type)" "$os_type" "$OS_ICON"
printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "OS (version)" "$os_version" "$VERSION_ICON"
if [[ "$os_arch" =~ "64" ]]; then
  printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "OS (architecture)" "$os_arch" "$X64_ICON"
else
  printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "OS (architecture)" "$os_arch" "$X86_ICON"
fi
printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "OS (kernel)" "$os_kernel_raw" "$KERNEL_ICON"
printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "OS (uptime)" "$os_uptime" "$UPTIME_ICON"

#### Users infos
if [[ "$users" != "" ]]; then
  printf "\e[1m%-25s\e[0m : %-15s  | ansi=true font='Ubuntu Mono' trim=false \n" "Utilisateurs locaux" "$users_amount"
  for user in $users; do
    if [[ "$users_sudo" =~ "$user" ]]; then
      printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "Utilisateur" "$user" "$USER_SUDO_ICON"
    else
      printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "Utilisateur" "$user" "$USER_ICON"
    fi
  done
fi

#### Network infos
printf "\e[1m%-25s\e[0m | ansi=true font='Ubuntu Mono' trim=false \n" "Informations Reseau"
printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "Interface Reseau" "$network_eth" "$ETH_DEVICE"
printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "IP Locale" "$local_ip" "$LOCAL_IP_ICON"
printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "Vitesse locale" "$speed_eth Mb/s" "$ETH_SPEED"
if [[ "$vpn_eth" != "" ]]; then
  printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "Interface VPN" "$vpn_eth" "$VPN_ICON"
fi
printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "Serveur DNS" "$dns_eth" "$DNS_ICON"

#### IPS for VPN
if [[ "$current_ip" == "$router_ip" ]] || [[ "$vpn_eth" == "" ]]; then
  printf "\e[1m%-25s\e[0m : %-15s  | ansi=true font='Ubuntu Mono' trim=false \n" "Status IP" "Visible"
  printf "%-2s [%4s] \e[1m%-13s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "IPV4" "IP Publique" "$router_ip" "$NET_ICON"
else
  printf "\e[1m%-25s\e[0m : %-15s  | ansi=true font='Ubuntu Mono' trim=false \n" "Status IP" "Masquée"
  printf "%-2s \e[1m[\e[0m%4s\e[1m]\e[0m \e[1m%-13s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "IPV4" "IP Publique" "$current_ip" "$NET_ICON"
  printf "%-2s \e[1m[\e[0m%4s\e[1m]\e[0m \e[1m%-13s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "IPV4" "IP Routeur" "$router_ip" "$NET_ICON"
fi

#### HDD Sizes and mount points
printf "\e[1m%-25s\e[0m : %-15s  | ansi=true font='Ubuntu Mono' trim=false \n" "Capacite Totale HDD" "$overall_hdd"
for output in {0..100}; do
  if [[ "${size_current_drive[$output]}" != "" ]]; then
    if [[ "${size_usb[$output]}" == "" ]]; then
      if [[ "${size_ssd[$output]}" == "1" ]]; then
        printf "%-2s \e[1m[\e[0m%6s\e[1m]\e[0m \e[1m%-11s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "${size_drive_size[$output]}" "${size_current_drive[$output]}" "${size_mount_point[$output]}" "$HDD_ICON"
      else
        printf "%-2s \e[1m[\e[0m%6s\e[1m]\e[0m \e[1m%-11s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "${size_drive_size[$output]}" "${size_current_drive[$output]}" "${size_mount_point[$output]}" "$SSD_ICON"
      fi
    else
      printf "%-2s \e[1m[\e[0m%6s\e[1m]\e[0m \e[1m%-11s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "${size_drive_size[$output]}" "${size_current_drive[$output]}" "${size_mount_point[$output]}" "$USB_ICON"
    fi
  fi
done

#### HDD Free Space and mount points
printf "\e[1m%-25s\e[0m : %-15s  | ansi=true font='Ubuntu Mono' trim=false \n" "Capacite Libre HDD" "$overall_free"
for output2 in {0..100}; do
  if [[ "${free_current_drive[$output2]}" != "" ]]; then
    if [[ "${free_usb[$output2]}" == "" ]]; then
      if [[ "${free_ssd[$output2]}" == "1" ]]; then
        printf "%-2s \e[1m[\e[0m%6s\e[1m]\e[0m \e[1m%-11s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "${free_drive_size[$output2]}" "${free_current_drive[$output2]}" "${free_mount_point[$output2]}" "$HDD_ICON"
      else
        printf "%-2s \e[1m[\e[0m%6s\e[1m]\e[0m \e[1m%-11s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "${free_drive_size[$output2]}" "${free_current_drive[$output2]}" "${free_mount_point[$output2]}" "$SSD_ICON"
      fi
    else
      printf "%-2s \e[1m[\e[0m%6s\e[1m]\e[0m \e[1m%-11s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "${free_drive_size[$output2]}" "${free_current_drive[$output2]}" "${free_mount_point[$output2]}" "$USB_ICON"
    fi
  fi
done

#### HDD Smart
printf "\e[1m%-25s\e[0m | ansi=true font='Ubuntu Mono' trim=false \n" "Status HDD"
if [[ "$smartctl_no_root" == "" ]]; then
  for output4 in {0..100}; do
    if [[ "${smart_status[$output4]}" != "" ]]; then
      printf "%-2s \e[1m[\e[0m%3s\e[1m]\e[0m \e[1m%-8s\e[0m %8s %8s %8s %8s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "${smart_drive[$output4]}" "${smart_status[$output4]}" "${smart_pending[$output4]}" "${smart_offline[$output4]}" "${smart_reallocated[$output4]}" "${smart_temperature[$output4]}°C" "$HEALTH_ICON"
    fi
  done
else
  printf "%-2s %s | image='$SETTINGS_ICON' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false bash='$smart_info' terminal=false \n" "--" "Comment activer la surveillance"
fi


#### Services
printf "\e[1m%-25s\e[0m : %-15s  | ansi=true font='Ubuntu Mono' trim=false \n" "Services" "$my_service_amount"
for output3 in {0..100}; do
  if [[ "${my_service_name[$output3]}" != "" ]]; then
    if [[ "${my_service_status[$output3]}" == "Actif" ]]; then
      printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "${my_service_name[$output3]}" "${my_service_status[$output3]} (PID: ${my_service_pid[$output3]})" "$SERVICES_ICON"
    else
      printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "--" "${my_service_name[$output3]}" "${my_service_status[$output3]}" "$SERVICES_ICON"
    fi
  fi
done
echo "-- ---"
printf "%-2s %s | image='$SETTINGS_ICON' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false bash='$settings_services' terminal=false \n" "--" "Paramètres des services à surveiller"
printf "%-2s %s | image='$SETTINGS_ICON' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false bash='$push_settings' terminal=false \n" "" "Paramètres des messages push"
