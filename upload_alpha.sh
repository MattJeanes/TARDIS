#! /bin/bash

. ./upload.sh

gma_file="tardis_alpha.gma"
addon_id="2650203837"

upload $*

echo -e "Branch \"alpha\" will be updated.\nContinue? (ctrl+C to abort)"
read
git branch -D alpha
git branch alpha
git push origin :alpha
git push origin alpha