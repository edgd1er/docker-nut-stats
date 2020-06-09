#!/usr/bin/env bash
set -e

info(){
echo -e "\nFCGI cmd: $SPAWN_FCGI -a $FCGI_ADDR -p $FCGI_PORT -- $DAEMON -f"
echo -e "SOCK cmd: $SPAWN_FCGI -F 1 -s /var/run/fcgiwrap/$NAME.socket -U www -G www -- $DAEMON -f\n"
}

setName(){
  #sed -i '/modules-enabled\/\*\.conf;$/a env SERVER_NAME' /etc/nginx/nginx.conf
  sed -i "s/SERVER_NAME/${SERVER_NAME}/" /etc/nginx/sites-enabled/default
  sed -i "s/WNAME/${NAME}/" /etc/nginx/sites-enabled/default
  sed -i 's/###//g' /etc/nut/upsset.conf
}

fillHost(){
  NAME=$1
  shift
  LOC=$*
  echo "LOC: $LOC, NAME: $NAME"
  isPresent=$(grep -c "$NAME" /etc/nut/hosts.conf)|| :
  if [[ "${isPresent}" == "0" ]]; then
    echo "adding $ups to ups monitored list"
    echo "MONITOR $NAME \"$LOC\"" >> /etc/nut/hosts.conf
  fi
}

createHtPwd(){
  CREATE=""
  [[ ! -f /etc/nginx/.htpasswd ]] && CREATE="-c"
  htpasswd -b ${CREATE} /etc/nginx/.htpasswd ${HT_USER} ${HT_PWD}
}

#main
HT_USER=${HT_USER:"nutuser"}
HT_PWD=${HT_PWD:"nutpassword"}

info
setName
createHtPwd

[[ -n ${UPS1_NAME} ]] && fillHost ${UPS1_LOC} ${UPS1_NAME}
[[ -n ${UPS2_NAME} ]] && fillHost ${UPS2_LOC} ${UPS2_NAME}
[[ -n ${UPS3_NAME} ]] && fillHost ${UPS3_LOC} ${UPS3_NAME}
[[ -n ${UPS4_NAME} ]] && fillHost ${UPS4_LOC} ${UPS4_NAME}
[[ -n ${UPS5_NAME} ]] && fillHost ${UPS5_LOC} ${UPS5_NAME}
[[ -n ${UPS6_NAME} ]] && fillHost ${UPS6_LOC} ${UPS6_NAME}
[[ -n ${UPS7_NAME} ]] && fillHost ${UPS7_LOC} ${UPS7_NAME}
[[ -n ${UPS8_NAME} ]] && fillHost ${UPS8_LOC} ${UPS8_NAME}
[[ -n ${UPS9_NAME} ]] && fillHost ${UPS9_LOC} ${UPS9_NAME}


supervisorctl start nginx
#supervisorctl start fcgisock

exit 0