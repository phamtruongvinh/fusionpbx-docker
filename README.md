# fusionpbx-docker-image

## Build the image

1. `$ git clone https://github.com/truongvinh2112/fusionpbx`
2. `$ cd fusionpbx-docker-image`
3. `fusionpbx-docker-image$ docker build -t <image-name>[:<tag>] .` (note the `.` at end)

## Create and start the container

1. `$ docker run --privileged -it --rm --name <container-name> <image-name>[:<tag>]`

## Stop the container

1. `$ docker stop <container-name>`
