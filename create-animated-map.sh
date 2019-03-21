#! /bin/bash

set -e

frames_per_second=10
delay=$(expr 100 / $frames_per_second) # 100 = 1 second
size=1048576
final_pause=300 # 100 = 1 second

./plot-bathymetry.R

for plot_path in frame-????-????kybp-bathy.png
do

    plot_path_prefix="${plot_path%.*}"
    small_plot_path="${plot_path_prefix}-small.png"
    convert "$plot_path" -flatten -strip -resize @${size} PNG8:${small_plot_path}
done

convert -monitor \
        -layers OptimizePlus \
        -delay "$delay" \
        frame-????-????kybp-bathy-small.png \
        -delay "$final_pause" frame-????-0000kybp-bathy-small.png \
        animated-bathymetry.gif
# convert -monitor \
#         -layers OptimizePlus \
#         -delay "$delay" \
#         frame-????-????kybp-bathy-small.png \
#         -delay "$final_pause" frame-????-0000kybp-bathy-small.png \
#         animated-bathymetry-im.mp4
# ffmpeg -f image2 \
#         -framerate "$frames_per_second" \
#         -pattern_type glob \
#         -i 'frame-????-????kybp-bathy-small.png' \
#         animated-bathymetry-ff.gif
ffmpeg -f image2 \
        -framerate "$frames_per_second" \
        -pattern_type glob \
        -i 'frame-????-????kybp-bathy-small.png' \
        -vf 'scale=trunc(iw/2)*2:trunc(ih/2)*2' \
        -movflags faststart \
        -c:v libx264 -profile:v high \
        -crf 18 \
        -pix_fmt yuv420p \
        animated-bathymetry-small.mp4
# ffmpeg -i 'animated-bathymetry.gif' \
#         -vf 'scale=trunc(iw/2)*2:trunc(ih/2)*2' \
#         -movflags faststart \
#         -c:v libx264 -profile:v high \
#         -crf 18 \
#         -pix_fmt yuv420p \
#         animated-bathymetry-from-gif.mp4

rm frame-????-????kybp-bathy.png
rm frame-????-????kybp-bathy-small.png
