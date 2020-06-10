#!/usr/local/bin/python3
# Generates empty files with the appropriately indexed names.
# Author: Dieter Castel
from sys import argv
import os
import math
import urllib.request, urllib.error, urllib.parse
import random
import os.path

def deg2num(lat_deg, lon_deg, zoom):
    lat_rad = math.radians(lat_deg)
    n = 2.0 ** zoom
    xtile = int((lon_deg + 180.0) / 360.0 * n)
    ytile = int((1.0 - math.log(math.tan(lat_rad) + (1 / math.cos(lat_rad))) / math.pi) / 2.0 * n)
    return (xtile, ytile)

def makeEmptyFile(zoom,xtile,ytile):
    dir_path = "fns/"
    if not os.path.exists(dir_path):
        os.makedirs(dir_path)
    fn = "fns/%d-%d-%d.png" % (zoom, xtile, ytile)
    print(fn)
    open(fn,'a').close()
    return fn

def usage():
    print("Usage: ")
    print("generateFns.py <TopLeftlat(Y1)> <TopLeftlon(X1)> <BotRightLat(Y2)> <BotRightLon(Y2)>")

def main(argv):
    try:
        script, TLlat, TLlon, BRlat, BRlon = argv
    except:
        usage()
        exit(2)

    # redefine me if need so
    minzoom = 14 # CHANGE ME
    maxzoom = 14 # CHANGE ME

    # from 6 to 15 ranges
    for zoom in range(minzoom, int(maxzoom)+1, 1):
        xtile, ytile = deg2num(float(TLlat), float(TLlon), zoom)
        final_xtile, final_ytile = deg2num(float(BRlat), float(BRlon), zoom)
        print("%d:%d-%d/%d-%d" % (zoom, xtile, final_xtile, ytile, final_ytile))
        minxt = min(xtile,final_xtile)
        maxxt = max(xtile,final_xtile)
        minyt = min(ytile,final_ytile)
        maxyt = max(ytile,final_ytile)
        for x in range(minxt, maxxt+ 1, 1):
            for y in range(maxyt- 1, minyt, -1):                
            #for y in range(ytile, final_ytile - 1, -1):                
                result = makeEmptyFile(zoom, x, y)
    
main(argv)    
