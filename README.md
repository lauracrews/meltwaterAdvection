# Meltwater advection hastens autumn freeze up
This repo contains code to reproduce the analysis and figures in the paper "Meltwater advection hastens autumn freeze up" by Crews et al. (2022)

Crews, L., Lee, C. M., Rainville, L., & Thomson, J. (2022). Direct observations of the role of lateral advection of sea ice meltwater in the onset of autumn freeze up. Journal of Geophysical Research: Oceans, 127, e2021JC017775. https://doi.org/10.1029/2021JC017775

![ice_formation_melt](https://github.com/lauracrews/meltwaterAdvection/blob/main/docs/fig1/ice_formation_melt.png)
### Abstract 
In seasonally ice-free parts of the Arctic Ocean, autumn is characterized by heat loss from the upper ocean to the atmosphere and the onset of freeze up, in which first year sea ice begins to grow in open water areas. The timing of freeze up can be highly spatially variable, complicating efforts to provide accurate sea ice forecasting for marine operations. While melt season anomalies can be used to predict freeze up anomalies in some parts of the Arctic, this one-dimensional view merits further examination in light of recent work demonstrating the importance of three-dimensional flows in setting mixed layer properties in marginal ice zones. In this study we show that horizontal advection of sea ice meltwater hastens freeze up in areas distant from the ice edge. We use nearly 800 temperature and salinity profiles along with satellite imagery collected in the central Beaufort Sea in autumn 2018 to document the roughly 100 km advection of a cold and fresh surface meltwater layer over several weeks. This advected meltwater hastened freeze up by cooling and shoaling the mixed layer relative to adjacent areas unaffected by the meltwater. A mixed layer heat budget showed that advection was nearly as important as one-dimensional heat loss to the atmosphere for seasonally integrated mixed layer heat loss within the meltwater-affected area. 

# Dependencies

### MATLAB and toolboxes
* MATLAB (R2018b used to develop this code) <br />
* MATLAB image processing toolbox (the function imgaussfilt.m is used) <br />
* Gibbs SeaWater (GSW) Oceanographic Toolbox (version 3.0.11 used here), available at http://www.TEOS-10.org <br />
* m_map Toolbox (version 1.4m used here), available at https://www.eoas.ubc.ca/~rich/map.html#download <br />

### Colormaps used in figures
* cmocean, available on the MATLAB file exchange at https://www.mathworks.com/matlabcentral/fileexchange/57773-cmocean-perceptually-uniform-colormaps <br />
* ColorBrewer, available on the MATLAB file exchange at https://www.mathworks.com/matlabcentral/fileexchange/45208-colorbrewer-attractive-and-distinctive-colormaps <br />

# Getting started
Reproducing the analysis and figures requires the following steps:
1. Download this repository to the first directory on the Matlab search path (this can be found by running `userpath`). <br /> **Note:** If you would like to store this repo elsewhere, edit the variable `rootPath` in the script `run_meltwaterAdvection.m` to reflect the location of this repository’s contents
2. Download the needed external data to the appropriate directories (instructions below)
3. Within Matlab, add the ~/meltwaterAdvection/ directory and subdirectories to the path
4. Enter `run_meltwaterAdvection` in the Matlab command line to reproduce all figures 

## Download data
From the University of Washington ResearchWorks archive at http://hdl.handle.net/1773/47135, download 
* **Seaglider, underway CTD, Wave Glider, and USCGC *Healy* underway data** to the directory ~/meltwaterAdvection/data/ 
* **PWP model results** used to make the heat budget should be unzipped into the directory ~/meltwaterAdvection/data/PWPresults/ 

Descriptions of these data are available in the [observational data documentation](https://github.com/lauracrews/meltwaterAdvection/blob/main/docs/dataDocumentation.md). The processing routines for the raw observational data are described in the [observational data processing documentation](https://github.com/lauracrews/meltwater-advection-ice-freezeup/blob/main/code/process_raw_observational_data/README.md). **It is not necessary to rerun this code - instead, the processed data should be downloaded from the archive at [UW ResearchWorks](http://hdl.handle.net/1773/47135).** 

##
**Sea ice concentration** from AMSR2 will be downloaded from the University of Bremen [archive](https://seaice.uni-bremen.de/data/amsr2/asi_daygrid_swath/n3125/2018/)  by `batchAMSR2` within `run_meltwaterAdvection`  <br />
##
Download the MODIS-Terra **sea surface temperature** data from the Physical Oceanography Distributed Active Archive Center at NASA/JPL. You will need to make a free account. <br />

For 8-day files go to: 
https://podaac-tools.jpl.nasa.gov/drive/files/allData/modis/L3/terra/11um/v2019.0/4km/8day/2018 <br />

Download the following files to the directory ~/meltwaterAdvection/data/ModisTerra/ <br />
T20182572018264.L3m_8D_NSST_sst_4km.nc <br />
T20182732018280.L3m_8D_NSST_sst_4km.nc <br />
T20182652018272.L3m_8D_NSST_sst_4km.nc <br />
T20182812018288.L3m_8D_NSST_sst_4km.nc <br />

For daily files go to:
https://podaac-tools.jpl.nasa.gov/drive/files/allData/modis/L3/terra/11um/v2019.0/4km/daily/2018  <br />

Download the files for 19 September 2018 to 16 October 2018 to the directory ~/meltwaterAdvection/data/ModisTerra/daily/  <br />
TERRA_MODIS.20180919.L3m.DAY.NSST.sst.4km.nc  <br />
…  <br />
TERRA_MODIS.20181016.L3m.DAY.NSST.sst.4km.nc  <br />
##
Download the SMOS **sea surface salinity** data from https://www.seanoe.org/data/00607/71909/ <br />
Scroll down and click the Weekly SMOS Arctic SSS v1.1 link to download a large .zip file, from which you should extract the following files to the directory ~/meltwaterAdvection/data/SMOS_SSS/

SMOS-arctic-LOCEAN-SSS-2018-09-15-v1.1AT-7days.nc	<br />
SMOS-arctic-LOCEAN-SSS-2018-09-21-v1.1AT-7days.nc	<br />
SMOS-arctic-LOCEAN-SSS-2018-09-30-v1.1AT-7days.nc <br />
SMOS-arctic-LOCEAN-SSS-2018-10-07-v1.1AT-7days.nc <br />
##
Download the CryoSat-2 **dynamic ocean topography (DOT)** data from the Radar Altimeter Database System at http://rads.tudelft.nl/rads/data/authentication.cgi <br />
You will need to enter your email address to receive the data. Navigate through three pages of options and make the following selections, organized by page:
1. Use the default settings under "Options" <br />
1. Select the "sea level anomaly" variable <br />
1. The date range of interest is covered by Cycles 109 & 110. Select all passes. Update the geographic range to 70°N to 90°N, -180°E to -130°E <br />

You will then receive an email to download several hundred zipped .asc files. 

**Alternatively, the DOT data used in the study are available on my github as [rawDOT.zip](https://github.com/lauracrews/meltwaterAdvection/raw/main/rawDOT.zip)**

Unzip the files obtained by either method into the directory ~/meltwaterAdvection/data/DOT/raw/

## Run analysis and create figures

The script `run_meltwaterAdvection.m` will create all the figures in the paper and save them as .png and Matlab .fig files into their own subdirectories within ~/meltwaterAdvection/figures/ 

**Note:** Copies of the output figures are available in numbered subdirectories in the [docs](https://github.com/lauracrews/meltwaterAdvection/tree/main/docs) directory of this repository if you would like to preview the results. 

Switches determining if figures should be saved are provided within each plotting script (`plot_*.m`). If you do not want to save the figures, edit the plotting scripts directly and set `saveFigs = false`

Descriptions of each of the subroutines called by `run_meltwaterAdvection.m` are in the [code documentation](https://github.com/lauracrews/meltwaterAdvection/blob/main/docs/codeDocumentation.md)
