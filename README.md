# Blackfuel's tips and tricks

### Build the Blackfuel version of Asuswrt-Merlin firmware
```
cd ~/blackfuel/asuswrt-merlin-tools
./build-asuswrt-merlin.sh
```

### Patch the original source code
```
cd ~/blackfuel/asuswrt-merlin
patch -p2 -i ~/blackfuel/asuswrt-merlin-tools/380.65-beta4-ARM-mods+apps+xtables-addons.patch
```

### Delete files in one folder hierarchy that appear in another folder hierarchy
This example cleans the asuswrt-merlin folder of the Xtables addons files.  It uses the `find` command to pipe the list of files to be deleted to `xargs`.  In the process, the root folder name is changed to the place where I want to delete the files.
```
cd ~/blackfuel
find asuswrt-merlin-xtables-addons-1.47.1 -type f -name "*" -printf "$HOME/blackfuel/asuswrt-merlin/%P\0" | xargs -0 -I '{}' rm '{}'
```

### Remove packages from Asuswrt-Merlin using scripted search/replace
The **target.mak** file in Asuswrt-Merlin does not merge well, therefore we use an ed script to make our life easy.

1. Create an ed script to automatically edit the file, "release/src-rt/target.mak".

  Script file: **~/blackfuel/asuswrt-merlin-tools/asuswrt-merlin-target.patch**
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
  g/HSPOT=y/s//HSPOT=n/g
  g/SMARTSYNCBASE=y/s//SMARTSYNCBASE=n/g
  ,w
  ```

2. Run this ed script on the Asuswrt-Merlin source code.
  ```
  cd ~/blackfuel/asuswrt-merlin
  ed -s < ~/blackfuel/asuswrt-merlin-tools/380.65-beta4-target.patch
  ```

### Create pull request for a single commit (ex: torfirewall)
```
git remote add upstream https://github.com/RMerl/asuswrt-merlin
git fetch upstream
git checkout -b torfirewall upstream/master
git cherry-pick 5ea0eb689debdd5267d63f3954294b6b30c72694
git push origin torfirewall
#(now create the pull request)
```

### Merge pull request with upstream master (ex: torfirewall)
```
git checkout torfirewall
git fetch upstream
git merge upstream/master
git push origin torfirewall
```

### Merge with upstream master
```
git checkout master
git fetch upstream
git merge upstream/master
#git commit -m "Sync with upstream master"
git push -f origin master
```

### Merge up to specific commit in upstream master
```
git checkout master
git fetch upstream
git merge 1d97633eb81cecbfd0b69c4f4439e774bf1cc0a3
git push -f origin master
```

### Reset to upstream/master and re-apply the full Blackfuel patch
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

### Upload Asus GPL source code to Github (first commit, slow)
```
cd $HOME/blackfuel
tar xzvf /mnt/hgfs/sandbox/GPL_RT-AC86U_300438211816.tgz
mv asuswrt asuswrt-rt-ac86u
cd asuswrt-rt-ac86u
git init
git remote add origin https://github.com/blackfuel/asuswrt-rt-ac86u.git
git add -A
git commit -m "Asus GPL 3.0.0.4 382.11816 (RT-AC86U) first commit"
git push -u origin master
git tag 382.11816
git push origin --tags
```

### Upload Asus GPL source code to Github (update existing repo)
```
cd $HOME/blackfuel
tar xvf /mnt/hgfs/sandbox/GPL_RT_AC86U_300438215098.tar
rm -rf asuswrt-rt-ac86u/*   # clear out everything except the .git directory
cd asuswrt-rt-ac86u
mv ../asuswrt/* .
rmdir ../asuswrt
git add -A
git commit -m "update GPL 382.15098"
git push -u origin master
git tag 382.15098
git push origin --tags
```

### Convert a man page to HTML for displaying on Github
```
cd /share/man/man1
cat wipe.1 | groff -mandoc -Thtml
```


### Donations may be sent to my Bitcoin address: 1i5Tpno73gJdr1XdmoxT6CjVFGef5KkZM
Any amount is appreciated.  This helps me share new material and pay the bills.  Thank you.
