#!/bin/bash
#		1 frame/s      INPUT frames          encoder, yuva420 for transparancy support ,max twitter scale
ffmpeg -framerate 1 -i frames/frame%1d.png -c:v libvpx-vp9 -pix_fmt yuva420p -vf scale=720:-1 -lossless 1 output/creepFast.webm
ffmpeg -framerate 0.4 -i frames/frame%1d.png -c:v libvpx-vp9 -pix_fmt yuva420p -vf scale=720:-1 -lossless 1 output/creepSlow.webm
ffmpeg -framerate 1 -i frames/smallFrame%1d.png -c:v libvpx-vp9 -pix_fmt yuva420p -vf scale=720:-1 -lossless 1 output/creepSmallFast.webm
ffmpeg -framerate 0.4 -i frames/smallFrame%1d.png -c:v libvpx-vp9 -pix_fmt yuva420p -vf scale=720:-1 -lossless 1 output/creepSmallSlow.webm
