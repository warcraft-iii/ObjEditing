#!/bin/bash
cd "$(dirname "$0")"

if [ -f "bin/premake5" ]; then
    bin/premake5 gmake2
else
    premake5 gmake2
fi
