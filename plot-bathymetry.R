#! /usr/bin/env Rscript

library(ggplot2)
library(marmap)

long_limits = c(116.8, 126.2)
lat_limits = c(6.15, 20.2)
buffer = 1.0
# plot dimensions in inches
plot_width = 5.0
plot_height = 7.0
label_font_size = 16.0

sea_level_data = read.delim(
        "spratt2016-sea-level-projection.txt",
        header=T,
        sep="\t",
        skip=95)
# Combine sea level projection from 0-430k years ago with projection from
# 430k-798k years ago
sea_levels = c(sea_level_data$SeaLev_shortPC1[0:431], sea_level_data$SeaLev_longPC1[-0:-431])
sea_level_data$sealevel = sea_levels

bathy_raw_data = getNOAA.bathy(
        lon1 = long_limits[1] - buffer,
        lon2 = long_limits[2] + buffer,
        lat1 = lat_limits[1] - buffer,
        lat2 = lat_limits[2] + buffer,
        resolution = 1,
        keep = T)
bathy_data = fortify.bathy(bathy_raw_data)

for (i in 1:length(sea_level_data$age_calkaBP)) {
    time = sea_level_data$age_calkaBP[i]
    depth = sea_level_data$sealevel[i]
    time_ceiling_10k = round(time + 5, -1)
    label = paste(time_ceiling_10k, " kybp", sep = "")
    p = ggplot() +
        geom_raster(data = bathy_data, aes(x = x, y = y, fill = z),
                    alpha = 0.2,
                    show.legend = FALSE) +
        scale_fill_gradient(limits = c(depth, max(bathy_data)),
                low = "black",
                high = "black",
                na.value = "white") +
        coord_fixed(xlim = long_limits,
                    ylim = lat_limits,
                    ratio = 1.0) +
        theme_minimal(base_size = 14) +
        labs(x = "Longitude") +
        labs(y = "Latitude") +
        geom_label(aes(x = long_limits[2], y = lat_limits[2],
                      label = label,
                      size = label_font_size,
                      hjust = "right",
                      vjust = "top"),
                  show.legend = FALSE)
    
    plot_path = paste(
            formatC(time, format = "d", width = 4, flag = 0),
            "kybp-bathy.png",
            sep = "")
    ggsave(plot_path, width = plot_width, height = plot_height, units = "in")
}
