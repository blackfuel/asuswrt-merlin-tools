#!/bin/bash
cd $HOME/blackfuel
find asuswrt-merlin-xtables-addons-1.47.1 -type f -name "*" -printf "$HOME/asuswrt-merlin/%P\0" | xargs -0 -I '{}' rm '{}'

