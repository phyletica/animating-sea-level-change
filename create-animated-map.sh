#! /bin/sh

set -e

delay=10 # 100 = 1 second
size=1048576
final_pause=300 # 100 = 1 second

./plot-bathymetry.R

for plot_path in ????kybp-bathy.png
do

    plot_path_prefix="${plot_path%.*}"
    small_plot_path="${plot_path_prefix}-small.png"
    convert "$plot_path" -flatten -strip -resize @${size} PNG8:${small_plot_path}
done

convert -monitor \
        -reverse -layers OptimizePlus \
        -delay "$delay" \
        ???[12345789]kybp-bathy-small.png \
        -delay "$final_pause" 0000kybp-bathy-small.png \
        animated-bathymetry.gif \
        && rm ????kybp-bathy.png ????kybp-bathy-small.png
ffmpeg -f gif -i animated-bathymetry.gif animated-bathymetry.mp4

# rm ????kybp-bathy.pdf
# rm ????kybp-bathy.pdf.png
