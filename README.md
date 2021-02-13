Container image for [The Levelator](http://www.conversationsnetwork.org/levelator)

### Usage

1. Build this image

   ```
   docker build -t levelator .
   ```

1. Change to the directory containing the files to process

1. Run levelator

   ```
   docker run --rm --user $(id -u):$(id -g) -v "$PWD:/levelator" levelator input.wav output.wav
   ```

   (Replace `input.wav` and `output.wav` with the names of the input/output files)
