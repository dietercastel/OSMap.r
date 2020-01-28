#!/usr/local/bin/python3
from PIL import Image, ImageFont, ImageDraw, ImageOps
import re
legendColor = "#ce4544"
streetText = "De lokale politie filmt de rode straten 24/7."
centerText = "De lokale politie filmt de rode straten in het centrum 24/7."
wandelText = "Rode     = ANPR; Rode zone = gefilmed; wandelroute Donker Blauw."
overlayText = "De lokale politie zet mobiele camera's in op heel het grondgebied."
ANPRSmallText = "3 werkende ANPR-camera's aan Leuven station & tiensestwg."
ANPRText = "Bij elke driehoek staan ANPR-camera's."
runFlag = [True,
           False,
           False,
           False,
           False,
           False,
           False,
           False,
           False,
           False]
imgNames = ["trimmed_wandeling2020.png",
        "trimmed_map2005small.png",
        "trimmed_map2013small.png",
        "trimmed_map2020small.png",
        "trimmed_map2005.png",
        "trimmed_map2013.png",
        "trimmed_map2020.png",
        "trimmed_map2020bis.png",
        "trimmed_mapANPR2020small.png",
        "trimmed_mapANPR2020.png"]
legendTxts = [wandelText,
        centerText,
        centerText,
        centerText,
        streetText,
        streetText,
        streetText,
        overlayText,
        ANPRSmallText,
        ANPRText]
logoName = "apacheLokaal2.png"
camLogoName = "CCTV_RED.png"

logo = Image.open(logoName)
newLogoSize = (600,600)
print(logo.size)
scaledLogo = logo.resize(newLogoSize,Image.ANTIALIAS)
print(scaledLogo.size)
camLogo = Image.open(camLogoName).convert("RGBA")
print(logo.getpixel((0,0)))
print(camLogo.getpixel((0,0)))
camLogo = camLogo.resize((225,150),Image.ANTIALIAS) 
(camW,camH) = camLogo.size
(lW,lH) = scaledLogo.size
sigFont = ImageFont.truetype(font="/Users/dietercastel/Downloads/OpenDyslexic-Bold.otf", size=50)
legendFont = ImageFont.truetype(font="/Users/dietercastel/Downloads/Typesketchbook - NoyhBlack.otf", size=120)
apacheFont = ImageFont.truetype(font="/Users/dietercastel/Downloads/Typesketchbook - NoyhBlack.otf", size=200)
signature="@DieterCastel"
(sW,sH) = sigFont.getsize(signature)
city = "Leuven"
(cW,cH) = apacheFont.getsize(city)
apacheColor = (72,183,201,255)
apacheError = "#ce4544"
shadowColor = "#ffffff"
#shadowColor = "#222222"

def drawBorder(drawobj, loc, text, font):
    (x,y) = loc 
    drawobj.text((x-1, y-1), text, font=font, fill=shadowColor)
    drawobj.text((x+1, y-1), text, font=font, fill=shadowColor)
    drawobj.text((x-1, y+1), text, font=font, fill=shadowColor)
    drawobj.text((x+1, y+1), text, font=font, fill=shadowColor)

def addLogo(imgName,legendTxt):
    year = re.findall(r"\d\d\d\d",imgName)[0]
    print(year)
    (yW,yH) = apacheFont.getsize(year)
    img = Image.open(imgName).convert("RGBA")
    (w,h) = img.size
    logoX = w - (lW + cW)
    img.paste(scaledLogo, (logoX, 0), scaledLogo)
    img.paste(camLogo, (logoX+160, lH-yH), camLogo)
    txt = Image.new('RGBA', img.size, (255,255,255,0))
    draw = ImageDraw.Draw(txt)
    drawBorder(draw,(0,0), legendTxt, legendFont)
    draw.text((0,0), legendTxt, font=legendFont, fill=apacheError)
    drawBorder(draw, (0,h-sH-10), signature, sigFont)
    draw.text((0,h-sH-10), signature, font=sigFont, fill=(0,0,0,255))
    draw.text((logoX+cW,cH*3/4), city, font=apacheFont, fill=apacheColor)
    draw.text((logoX+cW,cH+yH), year, font=apacheFont, fill=apacheColor)
    Image.alpha_composite(img, txt).save("logo_"+imgName,"PNG")

for idx,im in enumerate(imgNames):
    if runFlag[idx]:
        addLogo(im,legendTxts[idx])
