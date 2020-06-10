# Using OpenStreetMap tiles for your own (R ggplot) maps

You can either download them using osm_tile_downloader.py or import them from a HAR file you exported of your browser of the region of interest.

# Python tile downloading downloading

Using the script osm tile downloader you can download the tiles around a given coordinate. Please take into account the Fair Use Policy of the tile servers. e.g.
 ```bash
 ./osm_tile_downloader.py 50.873 4.6748

 ```
# HAR processing

To use the pre-rendered openstreetmap tiles of the region of interest I saved the network traffic using the developer console of all image files from `tile.openstreetmap.org`. Save all the pngs as a HAR file. 

1. run `savePNGsFromHAR.jl yourHARFile.har` 
2. run `calcCoords.jl images/ outTileCoords.csv`
3. use the files in the images directory and the csv file for further processsing.

# filename/zoom/x/y/ -> Bounding Box Coordinates CSV file for annotation_raster 
For the `annotation_raster` function of R you need bounding box coordinates of each included image in the coordinate system you are plotting. I pre-calculated all the zoom level 14 coordinates for Belgium in file `z14-be.csv` for that purpose. First three lines shown below for the very curious:

```CSV
filename,zoom,xtile,ytile,topLeftLat,topLeftLong,botRightLat,botRightLong
14-8300-5445.png,14,8300,5445,51.549751017014174,2.373046875,51.53608560178474,2.39501953125
14-8300-5446.png,14,8300,5446,51.53608560178474,2.373046875,51.52241608253254,2.39501953125
```

# Preparing tile coordinates:

If you need tiles of different zoom-levels you'll first need to get the latitude longitude bounding box of the region of interest. 

e.g. Run an interactive r prompt to get the bounding box of the interested area.
```R
./docker.sh 
root@20bf8bc239e6:/# r
library(osmdata)
Data (c) OpenStreetMap contributors, ODbL 1.0. http://www.openstreetmap.org/copyright
print(getbb("Belgium",featuretype="country"))
        min       max
x  2.388914  6.408097
y 49.496982 51.550781
```

Update the min/max zoom required. 
```
#... other stuff in generateFns.py
minzoom = 14 #CHANGE ME
maxzoom = 14 #CHANGE ME
```
With these coordinates generate the proper filenames (and download the appropriate tiles with osm_tile_downloader.py)

```bash
./generateFns.py 51.550781 2.388914 49.496982 6.408097
```

(It would probably be better to create the CSV directly with python instead of the -> filenames -> julia step but hey `¯\_(ツ)_/¯`)
