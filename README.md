# Blackfuel's tips and tricks

### HOWTO: Build the Blackfuel version of Asuswrt-Merlin firmware
```
cd ~/blackfuel/asuswrt-merlin-tools
vi build-asuswrt-merlin.sh  # update BUILD_VER to match firmware
./build-asuswrt-merlin.sh
```

### HOWTO: Patch the original source code
```
cd ~/blackfuel/asuswrt-merlin
patch -p2 -i ~/blackfuel/asuswrt-merlin-tools/380.65-beta4-ARM-mods+apps+xtables-addons.patch
```

### HOWTO: Remove packages from Asuswrt-Merlin using scripted search/replace
The **target.mak** file in Asuswrt-Merlin does not merge well, therefore we use an ed script to make our life easy.

1. Create an ed script to automatically edit the file, "release/src-rt/target.mak".

  Script file: **~/blackfuel/asuswrt-merlin-tools/380.65-beta4-target.patch**
  ```
  e ./release/src-rt/target.mak
  H
  g/MEDIASRV=y/s//MEDIASRV=n/g
  g/PARENTAL2=y/s//PARENTAL2=n/g
  g/WEBDAV=y/s//WEBDAV=n/g
  g/CLOUDSYNC=y/s//CLOUDSYNC=n/g
  g/EMAIL=y/s//EMAIL=n/g
  g/DROPBOXCLIENT=y/s//DROPBOXCLIENT=n/g
  g/TIMEMACHINE=y/s//TIMEMACHINE=n/g
  g/MDNS=y/s//MDNS=n/g
  g/BWDPI=y/s//BWDPI=n/g
  g/SWEBDAVCLIENT=y/s//SWEBDAVCLIENT=n/g
  g/SNMPD=y/s//SNMPD=n/g
  g/CLOUDCHECK=y/s//CLOUDCHECK=n/g
  g/DUALWAN=y/s//DUALWAN=n/g
  g/DNSFILTER=y/s//DNSFILTER=n/g
  g/HW_DUALWAN=y/s//HW_DUALWAN=n/g
  ,w
  ```

2. Run this ed script on the Asuswrt-Merlin source code.
  ```
  cd ~/blackfuel/asuswrt-merlin
  ed -s < ~/blackfuel/asuswrt-merlin-tools/380.65-beta4-target.patch
  ```

### HOWTO: Reset to upstream/master and apply the Blackfuel mod
```
git clone https://github.com/blackfuel/asuswrt-merlin
git remote add upstream https://github.com/RMerl/asuswrt-merlin
git fetch upstream
git checkout master
git reset --hard upstream/master
# (apply your patch here)
git status
git add -A
git status
git commit -m "Reset to upstream/master and apply the blackfuel mod"
git push -f origin master
```
