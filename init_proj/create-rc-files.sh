#!/bin/bash

set -x

# .gemrc
cat <<EOF > ~/.gemrc
install: --no-document
update: --no-document

EOF

# .psqlrc
cat <<EOF > ~/.psqlrc
\x auto
\pset null null

EOF
