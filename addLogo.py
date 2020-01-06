from PIL import Image, ImageFont, ImageDraw, ImageOps
import re
legendColor = "#ce4544"
streetText = "De lokale politie filmt de rode straten 24/7."
overlayText = "De lokale politie zet mobiele camera's in op heel het grondgebied."
ANPRText = "Bij elke driehoek staan ANPR-camera's."
imgNames = ["map2005.png", "map2013.png", "map2020.png","map2020bis.png","mapANPRon2020.png"]
legendTxts = [streetText, streetText, streetText, overlayText, ANPRText]
logoName = "apacheLokaal2.png"
camLogoName = "/Users/dietercastel/Downloads/CCTV_RED.PNG"

logo = Image.open(logoName)
newLogoSize = (600,600)
print(logo.size)
scaledLogo = logo.resize(newLogoSize,Image.ANTIALIAS)
print(scaledLogo.size)
camLogo = Image.open(camLogoName).convert("RGBA")
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
    draw.text((0,0), legendTxt, font=legendFont, fill=apacheError)
    draw.text((0,h-sH-10), signature, font=sigFont, fill=(0,0,0,255))
    draw.text((logoX+cW,cH*3/4), city, font=apacheFont, fill=apacheColor)
    draw.text((logoX+cW,cH+yH), year, font=apacheFont, fill=apacheColor)
    Image.alpha_composite(img, txt).save("logo_"+imgName,"PNG")

for idx,im in enumerate(imgNames):
    addLogo(im,legendTxts[idx])
