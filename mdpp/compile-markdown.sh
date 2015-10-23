#!/bin/bash
# This script compiles markdown pre processor files (.mdpp) to README.MD and README.JS.MD files.
# It also generates the specs badge.
# See the markdown-pp github project here : https://github.com/jreese/markdown-pp
cd "${BASH_SOURCE%/*}" || exit 1
if [[ ! -f js-guide.mdpp ]] || [[ ! -f coffee-guide.mdpp ]] || [[ ! -f readme.mdpp ]]; then
    echo "Missing mdpp files !"
fi
xmlstarlet --version > /dev/null 2>&1
if [[ $? -eq 127 ]] ; then echo "xmlstarlet is not installed" && exit 1;
markdown-pp > /dev/null 2>&1
fi
if [[ $? -eq 127 ]] ; then echo "markdown-pp is not installed" && exit 1;
rsvg-converter --version > /dev/null 2>&1
fi
if [[ $? -eq 127 ]] ; then echo "rsvg-converter from package librsvg2-bin is not installed" && exit 1;
fi
reportFile=jasmine-report
jasmineReport=$(cd ../ && jasmine | sed -e '$!{h;d;}' -e x)
reports=(${jasmineReport//,/ })
style=""
failures=${reports[@]:2:2}
specs=${reports[@]:0:2}
if [[ ${reports[2]}  -eq 0 ]]; then style="fill:#44cc11;"
else style="fill:#e05d44;"
fi
xmlstarlet ed -N svg="http://www.w3.org/2000/svg" -u '//svg:defs/svg:text[@id="failures"]' -v "$failures" -u '//svg:defs/svg:text[@id="specs"]' -v "$specs" -u '//svg:*[@class="wrapped"]/@style' -v $style  ${reportFile}.svg | rsvg-convert -o ${reportFile}.png
markdown-pp js-guide.mdpp -o ../JS.GUIDE.MD
markdown-pp coffee-guide.mdpp -o ../COFFEE.GUIDE.MD
markdown-pp readme.mdpp -o ../README.MD
