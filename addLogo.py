from PIL import Image
imgNames = ["map2005.png", "map2013.png", "map2020.png","mapANPRon.png"]
logoName = "apacheLokaal2.png"

logo = Image.open(logoName)
newLogoSize = (600,600)
print(logo.size)
scaledLogo = logo.resize(newLogoSize,Image.ANTIALIAS)
print(scaledLogo.size)
(lw,lh) = scaledLogo.size

def addLogo(imgName):
    img = Image.open(imgName)
    (w,h) = img.size
    newX = w - lw
    img.paste(scaledLogo, (newX, 0), scaledLogo)
    img.save("logo_"+imgName,"PNG")


for im in imgNames:
    addLogo(im)
