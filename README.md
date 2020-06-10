# OSMap.r

Creating custom R maps for 

This project uses:

- R scripts (inside Docker for generating map-based visualisations)
- Python 3 scripts (for post-processing generated images, downloading OSM tiles/some preprocessing)
- Bash scripts (for minor things)
- Julia scripts (my legacy, sorrynotsorry.)

## Docker

**You might want to increase your docker memory & swap file size (in Preferences/Advanced) because R (or my code?) has a crashing tendency when not given enough resources.**
See [run options here](https://docs.docker.com/config/containers/resource_constraints/#--memory-swap-details) or do it in your docker preferences.


After installing docker pull the required container (with R and all required libraries installed.)
```bash
docker pull robinlovelace/geocompr
```

Then run a command prompt in the docker:
```bash
./docker.sh
```

This will take you inside the docker container ready to run the r scripts.

The repository map should be synced under `/tmp/wmleuv` and if you open that folder inside the container you can run scripts like:

```bash
r dockergeocode.r # required only once for generating necessary Rdata files.
r dockerMakeFrames.r 
```

Alternative example files run similarly
```bash
# Smallest and most trivial example plotting book cases in Leuven.
r dockerMakeLeuvenBookcases.r
r dockerMakeSmallFrames.r
# Incorporating a GPX track:
r dockerMakeWandeling.r
# Overlaying other images:
r dockerANPROverlay.r
```

The output is placed inside `output` directory.

## Gif/webm making

### Prep
Trim the white edges

`./trimImages.py imageName`

Next with python 3 and pillow installed run:
`./addLogo.py`

### For gifs

Finally with [imagemagick convert](https://imagemagick.org/script/download.php) installed run:

`./makeGif.sh`

### For webms

With the excellent [ffmpeg](https://ffmpeg.org/) installed you can run.

`./makeWebm.sh`

Which results in a modern, smaller webm in `./output` instead.


### Projects using this toolchain

[Leuvense ANPR-camera’s filmen je zonder reden](https://www.apache.be/2020/01/08/leuvense-anpr-cameras-filmen-zonder-reden/)

![ANPR camera's in het stadscentrum van Leuven](https://github.com/dietercastel/OSMap.r/raw/wmleuv/output/art2_2.png)

[Winkeldief of shopper: Leuven filmt u, 24/7](https://www.apache.be/2020/01/09/hoe-leuven-een-gefilmde-stad-werd/)
![Toenemende gefilmde straten in het centrum Leuven 2005,2013,2020](https://github.com/dietercastel/OSMap.r/raw/wmleuv/output/creepSmall.gif)

![Toenemende gefilmde straten regio ring van Leuven 2005,2013,2020](https://github.com/dietercastel/OSMap.r/raw/wmleuv/output/hlStreets.gif)

[De Leuvense Privacy-wandeling van Apache](https://www.facebook.com/events/openbaar-entrepot-voor-de-kunsten-opek/volzet-apache-lokaal-de-slimme-stad/1208596742863953/)

![Wandeling door het Leuvense stadscentrum.](https://github.com/dietercastel/OSMap.r/raw/wmleuv/output/wanderling2020.png)

All public book cases listed on OSM around Leuven:
![Publieke boekenkasten op OpenStreetMaps in Leuven](https://github.com/dietercastel/OSMap.r/raw/wmleuv/output/mapBookcase.png)

