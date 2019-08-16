#!/bin/sh -e
#
# http://github.com/bonsai-linux/tools
#
# syncs build-server repo to local repo
#

[ "$1" ] || set -- -$1
src=${HOME}/src/bonsai

vps=vps
bonsai=bonsai

rsync -rtvuh4c --delete $src/ $vps:$bonsai
ssh $vps "cd $bonsai ; make clean ; make ; make install"
