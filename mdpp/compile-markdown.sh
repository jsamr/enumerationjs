#!/bin/bash
# This script compiles markdown pre processor files (.mdpp) to README.MD and README.JS.MD files.
# It also generates the specs badge.
# See the markdown-pp github project here : https://github.com/jreese/markdown-pp
cd "${BASH_SOURCE%/*}" || exit 1
if [[ ! -f js-guide.mdpp ]] || [[ ! -f coffee-guide.mdpp ]] || [[ ! -f readme.mdpp ]]; then
    echo "Missing mdpp files !"
fi

markdown-pp > /dev/null 2>&1
if [[ $? -eq 127 ]] ; then echo "markdown-pp is not installed" && exit 1;
fi
reportFile=jasmine-report
jasmineReport=$(cd ../ && jasmine | sed -e '$!{h;d;}' -e x)
reports=(${jasmineReport//,/ })
style=""
failures=${reports[@]:2:2}
specs=${reports[@]:0:2}
if [[ ${reports[2]}  -eq 0 ]]; then style="brightgreen"
else style="red"
fi
echo " ![jasmine](https://img.shields.io/badge/${specs// /_}-${failures// /_}-${style}.svg)" > jasmine-badge.mdpp
markdown-pp js-guide.mdpp -o ../JS.GUIDE.MD
markdown-pp coffee-guide.mdpp -o ../COFFEE.GUIDE.MD
markdown-pp readme.mdpp -o ../README.MD