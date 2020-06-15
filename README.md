# OSMap.r

Creating custom (OSM-based) maps with R

This project uses:

- R scripts (inside Docker for generating map-based visualisations)
- Python 3 scripts (for post-processing generated images, downloading OSM tiles/some preprocessing)
- Bash scripts (for minor things)
- Julia scripts (my legacy, sorrynotsorry.)

## Docker

**You might want to increase your docker memory & swap file size (in Preferences/Advanced) because R has a crashing tendency when not given enough resources.**
See [run options here](https://docs.docker.com/config/containers/resource_constraints/#--memory-swap-details) or do it in your docker preferences.


After installing docker pull the required container (with R and all required libraries installed.)
```bash
./pullDockerContainers
# or well just atm
# docker pull robinlovelace/geocompr 
```
Now you're all set!

# Book case example

This will step you to the bookcase example.


1) Get the bounding box and generate a script for downloading the required map tiles.  
```bash
#~/git/OSMap.r · (master±)
./runPrintBB.sh "Oostende,Belgium"
#[1] "Oostende,Belgium"
#Data (c) OpenStreetMap contributors, ODbL 1.0. http://www.openstreetmap.org/copyright
#[1] "Oostende,Belgium"
#[1] "./osm_tile_downloaderBB.py 51.2455721 2.8386276 51.1846337 3.0035408"
#[1] "Executable file written: /tmp/wmleuv/osmtiling/tileDLBB-Oostende,Belgium.sh"
```
2) run the download script from the folder osmtiling
```bash
#~/git/OSMap.r · (master±)
cd osmtiling/
#~/git/OSMap.r/osmtiling · (master±)
./tileDLBB-Oostende,Belgium.sh
#14:8321-8328/5467-5471
#be/14-8321-5471.png
#downloading 'https://tile.openstreetmap.be/osmbe/14/8321/5471.png'
....
# tiles are in osmtiling/be
```

3) Run the book cases example with the same string. 

The r script run is [dockerMakeBookcases.r](https://github.com/dietercastel/OSMap.r/blob/master/dockerMakeBookcases.r) with the given command line argument inside the docker container.
```bash
cd ..
#~/git/OSMap.r · (master±)
./runBookcases.sh "Oostende,Belgium"                                                                                        
# "Look in the /output folder."
```

4) Possibly trim the white edges

Requires python3 and Pillow installed.

```bash
./trimImages.py output/bookcases.png
```
Result should look like:
![Book cases in Oostende as of 15-06-2020](https://github.com/dietercastel/OSMap.r/raw/master/output/trimmed_OostendeBookcases.png)

5) You can add text and logos by tweaking the `addLogo.py` script.

# Other (older) examples.
These can be run from within the docker container atm best checkout the wmleuv branch for all the required files. 

Then run a command prompt in the docker container with:
```bash
#~/git/OSMap.r · (wmleuv)
./docker.sh
```

This will take you inside the docker container ready to run the r scripts.

The repository map is synced under `/tmp/wmleuv` by the docker script and if you open that folder inside the container you can run scripts like:

```bash
cd /tmp/wmleuv
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

![Wandeling door het Leuvense stadscentrum.](https://github.com/dietercastel/OSMap.r/raw/wmleuv/output/trimmed_wandeling2020.png)

All public book cases listed on OSM around Leuven:
![Publieke boekenkasten op OpenStreetMaps in Leuven](https://github.com/dietercastel/OSMap.r/raw/wmleuv/output/mapBookcase.png)

