#!/bin/bash

# $1 - filename to split, or directory of MP4
# $2 - chunk duration (default 480 sec)


# Each chunk duration in sec. Flickr only can have up to 1 GB which is:
# 720 = ~480 seconds
# 1080 = ~240 seconds
chunk_duration=480;
if [ "$2" != "" ]; then
  chunk_duration=$2
fi
echo "Chunk duration: $chunk_duration sec"


script_dir="/${PWD#*/}"
echo "Script Directory: $script_dir"


# $1 - filename to split
function split() {
  filename="$1"
  echo "Spliting $filename"

  # Probe for video length
  d=$($script_dir/ffprobe -loglevel error -show_format -show_streams "$filename" | grep duration= -m 1 | cut -f2 -d"=" | cut -f1 -d".")
  echo "Video duration: $d sec"

  # This will get the number of chunks
  # A ceiling trick involved. For 90sec chunk, it basically add 89, then divide by 90.
  chunks=$((($d+chunk_duration-1)/$chunk_duration))

  if [ $chunks -le 1 ]; then
    echo "Only 1 chunk. No need to split."
    return
  else
    echo "Number of chunks to split: $chunks"
  fi

  for (( c=1; c<=$chunks; c++ ))
  	do $script_dir/ffmpeg -i "$filename" -ss $[ ($c-1)*$chunk_duration ] -t $chunk_duration -vcodec copy -acodec copy -strict -2 "${filename%.*}_$c.${filename##*.}"
  done
}


if [[ -d $1 ]]; then
  directory=$1
  echo "Splitting each file in $directory"
  cd "$directory"
  for file in *.[mM][pP]4; do
    split "$file"
  done
elif [[ -f $1 ]]; then
  file=$1
  split "$file"
fi
