Container image for [The Levelator](http://www.conversationsnetwork.org/%20levelator)

#### Usage

This image has been published to [GitHub Container Registry](https://github.com/bmaupin/levelator-docker/pkgs/container/levelator) and [Docker Hub](https://hub.docker.com/r/bmaupin/levelator)

To use it:

1. Change to the directory containing the files to process

1. Run levelator

   ```
   docker run --rm --user $(id -u):$(id -g) -v "$PWD:/levelator" ghcr.io/bmaupin/levelator input.wav output.wav
   ```

   (Replace `input.wav` and `output.wav` with the names of the input/output files)

#### Build

To build this locally:

```
docker build -t levelator .
```

#### Publish

1. Build (see above)

1. (Optional) Run [`docker-slim`](https://github.com/docker-slim/docker-slim) to reduce the size of the image

   ```
   docker-slim build --http-probe=false --mount "$PWD:/levelator" --continue-after 1 levelator
   ```

   Since `levelator.sh` is in the Dockerfile entrypoint, it gets run, allowing `docker-slim` to detect everything used by the container and make sure it gets included in the final image

1. Tag and push to GitHub Container Registry

   1. [Authenticate to GHCR](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-with-a-personal-access-token-classic)

   1. Then

      ```
      docker tag levelator.slim ghcr.io/bmaupin/levelator:slim
      docker push ghcr.io/bmaupin/levelator:slim
      docker tag levelator.slim ghcr.io/bmaupin/levelator
      docker push ghcr.io/bmaupin/levelator
      ```

1. Tag and push to Docker Hub

   ```
   docker tag levelator.slim bmaupin/levelator:slim
   docker push bmaupin/levelator:slim
   docker tag levelator.slim bmaupin/levelator
   docker push bmaupin/levelator
   ```

#### List file contents

After `docker-slim` has been run, the final container doesn't have `ls`. You can use this to see the file contents of the container image:

```
docker run --name levelator ghcr.io/bmaupin/levelator 2> /dev/null; docker export levelator | tar t; docker container rm levelator &> /dev/null
```
