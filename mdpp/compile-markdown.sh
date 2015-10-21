#!/bin/sh
# This script compiles markdown pre processor files (.mdpp) to README.MD and README.JS.MD files.
# See the markdown-pp github project here : https://github.com/jreese/markdown-pp
markdown-pp js_index.mdpp -o ../README.JS.MD
markdown-pp coffee_index.mdpp -o ../README.MD
