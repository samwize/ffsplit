# ffsplit

This is a handy tool to split a large video files into smaller chunks.

Great for flickr users because flickr only allow up to 1 GB of video.


## How to use

    # Split a video file in chunk (default 480 sec)
    ./split.sh /path/to/awesome-video.MP4

    # Split a video file in chunk of 240 sec
    ./split.sh /path/to/awesome-video.MP4 240

    # Split all videos in a directory in chunk of 240 sec
    ./split.sh /path/to/videos/ 240
