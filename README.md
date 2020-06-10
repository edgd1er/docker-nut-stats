# docker-nut-stats
Just display stats from NUT's remote monitored UPS.

use [NUT](https://networkupstools.org/features.html) statistics cgi tool to display remote monitored UPS.

/!\ settings parameters and sending commands is not designed in this project as I only monitor UPS with limited rights remote user.

Available docker images architecture are: amd64 arm64 arm32v7

## usage  

Up to 9 UPS may be monitored, defined in docker-compose.xml.

UPS<X>_NAME: "ups X's name"
UPS<X>_LOC: "ups@host"

nginx's access is restricted thanks to htpasswd, defined with HT_USER and HT_PWD. If no values are given, HT_USER=nutuser, HT_PWD=nutpassword.




Github project: [docker-nut-stats](https://github.com/edgd1er/docker-nut-stats)