#!/bin/bash

objdump -p $1 | sed -n -e's/^[[:space:]]*SONAME[[:space:]]*//p' | sed -r -e's/([0-9])\.so\./\1-/; s/\.so(\.|$)//; y/_/-/; s/(.*)/\L&/'
