#!/bin/bash
# Pull it once initially
# docker pull robinlovelace/geocompr
docker run -v "$PWD:/tmp/wmleuv" -i -t robinlovelace/geocompr /bin/bash
