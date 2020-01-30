# wmleuv
Security camera visualisation of Leuven.

## Docker

You might want to increase your docker memory & swap file size (in Preferences/Advanced) because R (or my code?) has a crashing tendency when not given enough resources.

In the repository folder run this (after installing docker):.

```bash
./docker.sh
```

This will take you inside the docker container ready to run the r scripts.

The repository map should be synced under `/tm/wmleuv` and if you open that folder inside the container you can run scripts like:

```bash
r dockerMakeFrames.r
```

and/or

For the overlay version I manually grabbed a nicely pre-rendered OpenStreetMaps overlay of the required region. I'd still like to automate this step. (See issue TODO)

```bash
r dockerANPROverlay.r
```

The output is placed inside the current directory.

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
