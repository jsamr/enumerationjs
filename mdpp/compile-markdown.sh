#!/bin/sh
# This script compiles markdown pre processor files (.mdpp) to README.MD and README.JS.MD files.
# See the markdown-pp github project here : https://github.com/jreese/markdown-pp
$(cd ../ && echo "* ✓ Last Jasmine test run was the $(date -u "+%D at %R") UTC  with " > mdpp/lastbuild.mdpp && echo **$(jasmine | sed -e '$!{h;d;}' -e x)** >> mdpp/lastbuild.mdpp)
markdown-pp js_index.mdpp -o ../README.JS.MD
markdown-pp coffee_index.mdpp -o ../README.MD
