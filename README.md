# Blackfuel's Github cheat sheet and other tricks

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

### Add/remove packages from Asuswrt-Merlin using regular expressions
The **target.mak** file in Asuswrt-Merlin does not merge well, therefore we use a script to make our life easy.

1. Change existing target settings
  ```
  cd ~/blackfuel/asuswrt-merlin.ng
  sed -r -i 's/MEDIASRV=y/MEDIASRV=n/g;s/PARENTAL2=y/PARENTAL2=n/g;s/WEBDAV=y/WEBDAV=n/g;s/CLOUDSYNC=y/CLOUDSYNC=n/g;s/DROPBOXCLIENT=y/DROPBOXCLIENT=n/g;s/TIMEMACHINE=y/TIMEMACHINE=n/g;s/MDNS=y/MDNS=n/g;s/BWDPI=y/BWDPI=n/g;s/SWEBDAVCLIENT=y/SWEBDAVCLIENT=n/g;s/SNMPD=y/SNMPD=n/g;s/CLOUDCHECK=y/CLOUDCHECK=n/g;s/DNSFILTER=y/DNSFILTER=n/g;s/HSPOT=y/HSPOT=n/g;s/SMARTSYNCBASE=y/SMARTSYNCBASE=n/g;s/EMAIL=y/EMAIL=n/g;s/NOTIFICATION_CENTER=y/NOTIFICATION_CENTER=n/g;s/NATNL_AICLOUD=y/NATNL_AICLOUD=n/g;s/NATNL_AIHOME=y/NATNL_AIHOME=n/g;s/IFTTT=y/IFTTT=n/g;s/ALEXA=y/ALEXA=n/g;s/LETSENCRYPT=y/LETSENCRYPT=n/g;s/VISUALIZATION=y/VISUALIZATION=n/g;s/WTFAST=y/WTFAST=n/g;s/ROG=y/ROG=n/g;s/MULTICASTIPTV=y/MULTICASTIPTV=n/g;s/QUAGGA=y/QUAGGA=n/g;s/OPTIMIZE_XBOX=y/OPTIMIZE_XBOX=n/g;s/AMAS=y/AMAS=n/g' release/src-rt/target.mak
  ```

2. Append new target settings, use Perl's regex **negative lookahead** because it's not supported in Sed
  ```
  perl -pi -e 's/ARM=y(?!\s+STRACE=y)/ARM=y STRACE=y USBRESET=y BONJOUR=n PROTECTION_SERVER=n UPNPC=n/g' release/src-rt/target.mak
  # learn more: https://www.regular-expressions.info/lookaround.html
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

### Unstage committed changes not yet pushed to remote
```
git reset HEAD~1
git pull
```

### Unstage uncomitted changes
```
git reset HEAD <file>
```

### Revert committed changes already pushed to remote
```
git revert HEAD
```

### List all commits AND reset to a specific commit
```
git reflog | more
git reset --hard <commit>
git push -f
```

### Clone my fork and update it to a specific upstream commit that is more recent than my fork
```
# EXAMPLE: binwalk
cd $HOME
git clone https://github.com/blackfuel/binwalk
cd binwalk
git remote add upstream https://github.com/devttys0/binwalk
git checkout master
git fetch upstream
git merge a709e0e3409eee066fe225e906fa413e95ca75e0
git push -f origin master
```

### Clone my fork and update it to a previous known good upstream commit
```
# EXAMPLE: ubi_reader
cd $HOME
git clone https://github.com/blackfuel/ubi_reader
cd ubi_reader
git remote add upstream https://github.com/jrspruitt/ubi_reader
git checkout master
git fetch upstream
git reset --hard 0955e6b95f07d849a182125919a1f2b6790d5b51
git push -f origin master
```

### Create local archive of github repo for source package distribution, like the OpenWRT does
```
# EXAMPLE: archive the original dnscrypt-proxy 1.9.5 for source package distribution
cd $HOME
git clone https://github.com/dyne/dnscrypt-proxy
cd dnscrypt-proxy
git checkout 3762f45e2f0d0781fbe3c73413b048dd9890cfd6 # version 1.9.5
git submodule update --init --recursive # not needed for this particular repo because there are no submodules
TAR_TIMESTAMP="`git log -1 --format='@%ct'`"
rm -rf .git
cd ..
chmod -R g-w,o-w dnscrypt-proxy
tar --numeric-owner --owner=0 --group=0 --sort=name --mtime=$TAR_TIMESTAMP -cv dnscrypt-proxy | xz -zc -7e > dnscrypt-proxy.tar.xz
```




### Donations may be sent to my Bitcoin address: 1i5Tpno73gJdr1XdmoxT6CjVFGef5KkZM
Any amount is appreciated.  This helps me share new material and pay the bills.  Thank you.
