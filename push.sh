#!/bin/sh
#
# http://github.com/bonsai-linux/tools
#
# syncs build-server repo to local repo
#

# I keep different branches as different folders
# by default, use 'bonsai-master'.
# If arg provided, use 'bonsai-$arg'.
[ "$1" ] || set -- master
src=${HOME}/src/bonsai-$1

vps=vps
bonsai=bonsai

rsync -rtvuh4c --delete $src/ $vps:$bonsai
ssh $vps "cd $bonsai ; make clean ; make ; make install"
