#!/bin/bash
cd "${BASH_SOURCE%/*}" || exit 1
#Bundled version
coffee --compile -p ../src/Enumeration.coffee |  browserify - --standalone Enumeration > Enumeration.bd.js
coffee --compile -p ../src/Enumeration.coffee |  browserify - --standalone Enumeration | uglifyjs > Enumeration.bd.min.js
#Assuming _ defined versions
coffee --compile -p ../src/Enumeration.coffee  > Enumeration.js
coffee --compile -p ../src/Enumeration.coffee |  uglifyjs > Enumeration.min.js
