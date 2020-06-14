!/usr/local/bin/python3
# Initially converted with 2to3.py and then tweaked at bit
# from the original script by tonyrewin at https://gist.github.com/tonyrewin/9444410
# Author: tonyrewin & Dieter Castel
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

def download_url(zoom, xtile, ytile):
    # Switch between otile1 - otile4
    subdomain = random.randint(1, 4)
    
    #dir_path = "be/%d/%d/" % (zoom, xtile)
    dir_path = "be/"
    url = "https://tile.openstreetmap.be/osmbe/%d/%d/%d.png" % (zoom, xtile, ytile)
    download_path = "be/%d-%d-%d.png" % (zoom, xtile, ytile)
    
    print(download_path)
    if not os.path.exists(dir_path):
        os.makedirs(dir_path)

    if(not os.path.isfile(download_path)):
        print("downloading %r" % url)
        req = urllib.request.Request(url)
        req.add_header("User-Agent","osm_tile_downloader.gist")
        source = urllib.request.urlopen(req)
        content = source.read()
        source.close()
        destination = open(download_path,'wb')
        destination.write(content)
        destination.close()
    else: print("skipped %r" % url)

def usage():
    print("Usage: ")
    print("osm_tiles_downloader <lat> <lon>")
    print("Please mind the Fair Usage Policy of the tile servers. e.g. https://operations.osmfoundation.org/policies/tiles/")

def main(argv):
    try:
        script, lat, lon = argv
    except:
        usage()
        exit(2)

    # redefine me if need so
    minzoom = 14
    maxzoom = 14 
    latoffset = 0.3
    lonoffset = 0.3

    # from 0 to 6 download all
    # for zoom in range(0,7,1):
    #     for x in range(0,2**zoom,1):
    #         for y in range(0,2**zoom,1):
    #             download_url(zoom, x, y)

    # from 6 to 15 ranges
    for zoom in range(minzoom, int(maxzoom)+1, 1):
    # zoom = 14
        xtile, ytile = deg2num(float(lat)-latoffset, float(lon)-lonoffset, zoom)
        final_xtile, final_ytile = deg2num(float(lat)+latoffset, float(lon)+lonoffset, zoom)

        print("%d:%d-%d/%d-%d" % (zoom, xtile, final_xtile, ytile, final_ytile))
        for x in range(xtile, final_xtile + 1, 1):
            for y in range(ytile, final_ytile - 1, -1):                
                print(zoom,x,y)
                # result = download_url(zoom, x, y)
    
main(argv)    
