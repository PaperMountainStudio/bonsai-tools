#!/bin/sh
#
# http://github.com/bonsai-linux/tools
#
# syncs build-server repo to local repo
#

vps=vps
src=${HOME}/src/bonsai
bonsai=bonsai

rsync -rtvuh4c --progress --delete $src/ $vps:$bonsai
ssh $vps "cd $bonsai ; make clean ; make ; make install"
