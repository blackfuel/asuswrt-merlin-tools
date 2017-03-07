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

### HOWTO: Delete files in one folder hierarchy that appear in another folder hierarchy
This example cleans the asuswrt-merlin folder of the Xtables addons files.  It uses the `find` command to pipe the list of files to be deleted to `xargs`.  It the process, the root folder name is changed to the place where I want to delete the files.
```
cd ~/blackfuel
find asuswrt-merlin-xtables-addons-1.47.1 -type f -name "*" -printf "$HOME/blackfuel/asuswrt-merlin/%P\0" | xargs -0 -I '{}' rm '{}'
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

### HOWTO: create pull request for a single commit (ex: torfirewall)
```
git remote add upstream https://github.com/RMerl/asuswrt-merlin
git fetch upstream
git checkout -b torfirewall upstream/master
git cherry-pick 5ea0eb689debdd5267d63f3954294b6b30c72694
git push origin torfirewall
#(now create the pull request)
```

### HOWTO: merge pull request with upstream master (ex: torfirewall)
```
git checkout torfirewall
git fetch upstream
git merge upstream/master
git push origin torfirewall
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


### Donations may be sent to my Bitcoin address: 1i5Tpno73gJdr1XdmoxT6CjVFGef5KkZM
Any amount is appreciated.  This helps me share new material and pay the bills.  Thank you.
