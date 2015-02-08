#!/bin/bash
# Takes a Digital Elevation Model (DEM) and generates hillshades from 4 different light angles and a slope shade
# These may then be composited in QGIS, TileMill, Photoshop, etc. 
# Requires a color-slope.txt file containing the following: 0 255 255 255 \n 90 0 0 0
# Note: Process DEM prior to running this script (mosaic, clip, resample, reproject, etc)

GFLT=$1 #must be a raster DEM file type supported by GDAL
Z=1.3 # vertical exaggeration factor. apply greater value for smaller scale / larger areas

echo "Making color-slope.txt..."
touch color-slope.txt && printf '%s\n%s\n' '0 255 255 255' '90 0 0 0' >> color-slope.txt 

echo "Generating hillshade from $GFLT with sunlight angle at 45˚..."
gdaldem hillshade -of 'GTiff' -z $Z -az 45 $GFLT hillshade_az45.tif

echo "Generating hillshade from $GFLT -z $Z with sunlight angle at 135˚..."
gdaldem hillshade -of 'GTiff'  -z $Z -az 135 $GFLT hillshade_az135.tif

echo "Generating hillshade from $GFLT -z $Z with sunlight angle at 225˚..."
gdaldem hillshade -of 'GTiff'  -z $Z -az 225 $GFLT hillshade_az225.tif

echo "Generating hillshade from $GFLT -z $Z with sunlight angle at 315˚..."
gdaldem hillshade -of 'GTiff'  -z $Z -az 315 $GFLT hillshade_az315.tif

echo "Generating Slope from $GFLT..."
gdaldem slope $GFLT slope.tif

echo "Creating slope shade..."
gdaldem color-relief slope.tif color-slope.txt slopeshade.tif
