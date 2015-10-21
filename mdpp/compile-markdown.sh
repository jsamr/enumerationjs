#!/bin/bash
# This script compiles markdown pre processor files (.mdpp) to README.MD and README.JS.MD files.
# See the markdown-pp github project here : https://github.com/jreese/markdown-pp
cd "${BASH_SOURCE%/*}" || exit 1
travisTest='![Travis build](https://travis-ci.org/sveinburne/enumeration.svg?branch=master) '
if [[ ! -f js-guide.mdpp ]] || [[ ! -f coffee-guide.mdpp ]] || [[ ! -f readme.mdpp ]]; then
    echo "Missing mdpp files !"
fi
$(cd ../ && echo " $travisTest *last Jasmine test run was the $(date -u "+%D at %R") UTC  with " > mdpp/lastbuild.mdpp && echo **$(jasmine | sed -e '$!{h;d;}' -e x)** >> mdpp/lastbuild.mdpp)
markdown-pp js-guide.mdpp -o ../JS.GUIDE.MD
markdown-pp coffee-guide.mdpp -o ../COFFEE.GUIDE.MD
markdown-pp readme.mdpp -o ../README.MD
