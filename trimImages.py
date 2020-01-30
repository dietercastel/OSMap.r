#!/usr/local/bin/python3
# From https://stackoverflow.com/questions/10615901/trim-whitespace-using-pil
import sys
from PIL import Image, ImageChops
print("Either './trimImages.py -all' for all images or give a file name for a single image.")
imgNames = ["wandeling2020.png",
        "map2005small.png",
        "map2013small.png",
        "map2020small.png",
        "map2005.png",
        "map2013.png",
        "map2020.png",
        "map2020bis.png",
        "mapANPR2020small.png",
        "mapANPR2020.png"]
def trim(im):
    bg = Image.new(im.mode, im.size, im.getpixel((0,0)))
    diff = ImageChops.difference(im, bg)
    diff = ImageChops.add(diff, diff, 2.0, -100)
    bbox = diff.getbbox()
    if bbox:
        return im.crop(bbox)

def trimFile(fn):
    im = Image.open(fn)
    im = trim(im)
    newFN = "trimmed_"+fn
    im.save(newFN)
    print("Saved file " + newFN)

if str(sys.argv[1]) == "-all":
    for i in imgNames:
        print("Processing: " + i)
        trimFile(i)
else: 
    trimFile(sys.argv[1])
