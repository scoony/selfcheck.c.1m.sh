# selfcheck.c.1m.sh
## Selfcheck script for Argos (gnome-shell)

This is my first public Argos Script.

Also gonna try GitHub with this project...


**Features:**
- collect and display infos on hardware/software
- detect and notify if any error(s) thru push notification
- an auto-updating process is included

**Dependencies required:**
- `sudo apt-get install mesa-utils`
- `sudo apt-get install curl`
- `sudo apt-get install smartmontools`
- `sudo apt-get install net-tools`

**Temporary workaround for the smartctl sudo issue:**
- `sudo addgroup -a <user> disk`
- `sudo visudo` and add at then of the file `%sudo   ALL = (ALL) NOPASSWD: /usr/sbin/smartctl`
> the user must be in the sudo group<br>
> can be done using `sudo addgroup -a <user> sudo`

**Easy Installation:**

simply copy/paste in a terminal:

`wget -q https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/selfcheck.c.1m.sh -O ~/.config/argos/selfcheck.c.1m.sh && sed -i -e 's/\r//g' ~/.config/argos/selfcheck.c.1m.sh && chmod +x ~/.config/argos/selfcheck.c.1m.sh`

**Result:**
![alt text](https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.screenshots/Capture%20d%E2%80%99%C3%A9cran%20de%202018-01-31%2008-19-56.png)

![alt text](https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.screenshots/Capture%20d%E2%80%99%C3%A9cran%20de%202018-01-31%2008-20-48.png)

![alt text](https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.screenshots/Capture%20d%E2%80%99%C3%A9cran%20de%202018-01-31%2008-21-09.png)

![alt text](https://raw.githubusercontent.com/scoony/selfcheck.c.1m.sh/master/.screenshots/Capture%20d%E2%80%99%C3%A9cran%20de%202018-01-31%2008-21-25.png)
