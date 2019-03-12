#! /bin/sh

delay=25 # 100 = 1 second
density=600
size=1048576

./plot-bathymetry.R

# for plot_path in ????kybp-bathy.pdf
# do
#     convert -density "$density" "$plot_path" -flatten -strip -resize @${size} PNG8:${plot_path}.png
# done

convert -reverse -layers OptimizePlus -delay "$delay" ????kybp-bathy.png -loop 0 animated-bathymetry.gif

# rm ????kybp-bathy.pdf
# rm ????kybp-bathy.pdf.png
rm ????kybp-bathy.png
