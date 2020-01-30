#!/bin/bash
ffmpeg -i creep.gif -c:v libvpx -crf 4 -auto-alt-ref 0 creep.webm
ffmpeg -i creepSmall.gif -c:v libvpx -crf 4 -auto-alt-ref 0 creepSmall.webm
