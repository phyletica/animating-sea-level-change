#! /usr/bin/env Rscript

library(ggplot2)
library(marmap)

# Coordinates for Philippines
long_limits = c(116.6, 126.5)
lat_limits = c(5.15, 20.45)
buffer = 2.0
# Coordinates for 4:3 of SE Asia
# long_limits = c(93.5, 149.5)
# lat_limits = c(-16.5, 25.5)
# buffer = 10.0

start_kybp = 430
land_color = "grey50"

# plot dimensions in cm
plot_size = 26.0 # specify length of longest side in cm
label_font_size = 12.0 # in mm
plot_dpi = 300

plot_width = long_limits[2] - long_limits[1]
plot_height = lat_limits[2] - lat_limits[1]
max_dimension = max(plot_height, plot_width)
scale_factor = plot_size / max_dimension 
plot_width = plot_width * scale_factor
plot_height = plot_height * scale_factor

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

if (start_kybp > length(sea_level_data$age_calkaBP)) {
    start_kybp = length(sea_level_data$age_calkaBP)
}

for (i in (start_kybp + 1):1) {
    frame_number = (start_kybp + 1) - i
    time = sea_level_data$age_calkaBP[i]
    depth = sea_level_data$sealevel[i]
    time_ceiling_10k = round(time + 4.9, -1)
    label = paste(formatC(time_ceiling_10k, format = "d", width = 4, flag = " "),
            " kybp",
            sep = "")
    p = ggplot() +
        geom_raster(data = bathy_data, aes(x = x, y = y, fill = z),
                    # alpha = 0.2,
                    show.legend = FALSE) +
        scale_fill_gradient(limits = c(depth, max(bathy_data)),
                low = land_color,
                high = land_color,
                na.value = "white") +
        coord_fixed(xlim = long_limits,
                    ylim = lat_limits,
                    ratio = 1.0) +
        theme_minimal(base_size = 14) +
        theme(
                axis.line = element_blank(),
                axis.text.x = element_blank(),
                axis.text.y = element_blank(),
                axis.ticks.x = element_blank(),
                axis.ticks.y = element_blank(),
                axis.title.x = element_blank(),
                axis.title.y = element_blank(),
                legend.position = "none",
                panel.background = element_blank(),
                panel.border = element_blank(),
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank(),
                plot.background = element_blank()
        ) +
        geom_text(aes(x = long_limits[2], y = lat_limits[2],
                      label = label,
                      hjust = "right",
                      vjust = "top"),
                  size = label_font_size,
                  show.legend = FALSE)
    
    plot_path = paste(
            "frame-",
            formatC(frame_number, format = "d", width = 4, flag = 0),
            "-",
            formatC(time, format = "d", width = 4, flag = 0),
            "kybp-bathy.png",
            sep = "")
    ggsave(plot_path, width = plot_width, height = plot_height,
            device = "png",
            units = "cm",
            dpi = plot_dpi)
}
