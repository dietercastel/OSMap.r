# wmleuv
Security camera visualisation of Leuven.


TODO: cleanup, docs, ...

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

or

```bash
r dockerANPROverlay.r
```

The output is placed inside the current directory.

## Gif making

Trim the white edges

`./trimImages.py imageName`

Next with python 3 and pillow installed run:
`./addLogo.py`

finally with imagemagick convert installed run:

`./makeGif.sh`
