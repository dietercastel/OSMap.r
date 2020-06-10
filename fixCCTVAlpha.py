#!/usr/local/bin/python3
# This script coverts a black & white image to a PNG image with red & transparent.
from PIL import ImageOps, Image
imgPath = "input/CCTV.PNG"
blackColor = (255,0,0,0)
whiteColor = (255,255,255,0)

img = Image.open(imgPath)
thresh = 200
fn = lambda x : 255 if x > thresh else 0
r = img.convert('L').point(fn, mode='1')
print(r.getpixel((0,0))) # should be white
print(r.getpixel((250,150))) # should be black
print(r.getpixel((329,325))) # should be white

#Convert to pure black&white
data = r.getdata()

newData = []
for p in data:
    if p == 0:
        newData.append((255, 0, 0, 255))
    else:
        newData.append((255, 255, 255, 0))

r = r.convert("RGBA")
print(r.getpixel((0,0))) # should be transp 
print(r.getpixel((250,150)))
print(r.getpixel((329,325))) # should be transp 
r.putdata(newData)
print(r.getpixel((0,0))) # should be transp 
print(r.getpixel((250,150)))
print(r.getpixel((329,325))) # should be transp 
r.save("output/CCTV_RED.png", "PNG")
