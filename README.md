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

or

```bash
r dockerANPROverlay.r
```

The output is placed inside the current directory.

## Gif making

In docker container started with `docker.sh`

run in `/tmp/wmleuv`
`r dockerMakeFrames.r`


Next with python and pillow installed run:

`python3 addLogo.py`


finally run
