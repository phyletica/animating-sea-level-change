#! /bin/bash

set -e

frames_per_second=10
delay=$(expr 100 / $frames_per_second) # 100 = 1 second
size=1048576
final_pause=300 # 100 = 1 second
num_extra_frames_for_pause=30

./plot-bathymetry.R

for plot_path in frame-????-????kybp-bathy.png
do
    plot_path_prefix="${plot_path%.*}"
    small_plot_path="${plot_path_prefix}-small.png"
    # Crop to remove margin left by ggplot and reduce size of pngs
    convert "$plot_path" -gravity center -crop 96.25%\! -flatten -strip -resize @${size} PNG8:${small_plot_path}
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

# Setting a prolonged pause on the last frame in ffmpeg is too convoluted for
# my simple mind, so I'm doing a hack to simply repeat the last frame
last_frame_path="$(ls frame-????-????kybp-bathy-small.png | tail -n 1)"
last_frame_index_str="${last_frame_path/frame-/}"
last_frame_index_str="${last_frame_index_str/-0000kybp-bathy-small.png/}"
last_frame_index="$(expr $last_frame_index_str + 1)"
end_frame_index="$(expr $last_frame_index + $num_extra_frames_for_pause - 1)"
for i in $(seq $last_frame_index $end_frame_index)
do
    frame_label="$(printf "%0${#last_frame_index_str}d" $i)"
    next_frame_path="${last_frame_path/$last_frame_index_str/$frame_label}"
    cp "$last_frame_path" "$next_frame_path"
done

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
        animated-bathymetry.mp4

rm frame-????-????kybp-bathy.png
rm frame-????-????kybp-bathy-small.png
