R code for plotting sea level changes over the last 800,000 years.

Just run:
```
    ./create-animated-map.sh
```
or
```
    bash create-animated-map.sh
```

# Acknowledgments

## Resources

Sea-level estimates are from the projection of
[Spratt and Lisiecki (2016)](https://www.clim-past.net/12/1079/2016/).
These data are included in the repository and can be found here:

<https://www.ncdc.noaa.gov/paleo-search/study/19982>

The bathymetry data are from the ETOPO1 1-arc-minute global relief model
([Amante and Eakins, 2009](https://www.ngdc.noaa.gov/mgg/global/relief/ETOPO1/docs/ETOPO1.pdf)),
which are here:

<https://data.nodc.noaa.gov/cgi-bin/iso?id=gov.noaa.ngdc.mgg.dem:316>

Animation generated using
[marmap](https://cran.r-project.org/web/packages/marmap/index.html)
Version 1.0.2
([Pante and Simon-Bouhet, 2013](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0073051)),
[ggplot2](https://ggplot2.tidyverse.org/)
Version 2.2.1 (Wickham, 2009), and
[ImageMagick](https://imagemagick.org/index.php)
Version 6.9.10-8 Q16
x86_64 20180723.

### Literature cited

Amante, C. and B. W. Eakins, 2009. ETOPO1 1 arc-minute global relief model:
Procedures, data sources and analysis. Tech. rep., National Geophysical Data
Center, Marine Geology and Geophysics Division, National Oceanic and
Atmospheric Administration, Boulder,  Colorado, USA.

Pante, E. and B. Simon-Bouhet, 2013. marmap: a package for importing, plotting
and analyzing bathymetric and topographic data in R. PLoS ONE 8:e73051.
Doi:10.1371/journal.pone.0073051.

Spratt, R. M. and L. E. Lisiecki, 2016. A Late Pleistocene sea level stack.
Climate of the Past 12:1079–1092.

## Funding

This work was made possible by funding provided to
[Jamie Oaks](http://phyletica.org)
from the National Science Foundation (grant number DEB
1656004).

# License

The R and bash code for this work are licensed under a Creative Commons
Attribution 4.0 International License.

You should have received a copy of the license along with this
work. If not, see <http://creativecommons.org/licenses/by/4.0/>.
