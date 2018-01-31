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
![alt text](https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.screenshots/Capture%20d%E2%80%99%C3%A9cran%20de%202018-01-31%2008-19-56.png)

![alt text](https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.screenshots/Capture%20d%E2%80%99%C3%A9cran%20de%202018-01-31%2008-20-48.png)

![alt text](https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.screenshots/Capture%20d%E2%80%99%C3%A9cran%20de%202018-01-31%2008-21-09.png)

![alt text](https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.screenshots/Capture%20d%E2%80%99%C3%A9cran%20de%202018-01-31%2008-21-25.png)
