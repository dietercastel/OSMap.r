#!/bin/bash
docker run -v "$PWD:/tmp/wmleuv" -i -t robinlovelace/geocompr /usr/local/bin/Rscript /tmp/wmleuv/dockerMakeBookcases.r "$1"
