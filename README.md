# selfcheck.c.1m.sh
## Selfcheck script for Argos (gnome-shell)

This is my first public Argos Script.

Also gonna try GitHub with this project...


**Features:**
- collect and display infos on hardware/software
- detect and notify if any error(s) thru push notification

**Dependencies required:**
- apt-get install mesa-utils
- apt-get install curl
- apt-get install smartmontools
- apt-get install net-tools

**Temporary workaround for the smartctl sudo issue:**
- `sudo addgroup -a <user> disk`
- `sudo visudo` and add at then of the file `%sudo   ALL = (ALL) NOPASSWD: /usr/sbin/smartctl`

**Result:**
![alt text](https://i.imgur.com/p9LLYwm.png)
