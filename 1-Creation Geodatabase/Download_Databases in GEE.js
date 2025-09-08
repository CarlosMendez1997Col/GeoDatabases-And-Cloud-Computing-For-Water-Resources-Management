/*
                              					  												Water Resources Managemen using PostgreSQL and PgAdmin4
                                        																				Area of Interest (South America)
                                      															 					   Developed by MSc Carlos Mendez
																														 
*/
////////////////////////////////////////////////////////////////////////////// 1. SACB /////////////////////////////////////////////////////////////////////
// South America Countries and Boundary (SACB)

// Use a simple query by attributes and fields
var SA_countries = ee.FeatureCollection('USDOS/LSIB_SIMPLE/2017')
                     .filter(ee.Filter.eq('wld_rgn', 'South America'))

// Delete three rows with info (not belongs to SA)
var SA_countries_ = SA_countries.select('country_na')
                                .filter(ee.Filter.inList('country_na', ['Invernada Area', 'Isla Brasilera', 'Falkland Islands']).not());

//rename 'country_na' column to 'NAME' in featureCollection
var Sa_countries_name = SA_countries_.select(['country_na'],['Name'])

Export.table.toDrive({collection: Sa_countries_name, description: 'SACB_SA', fileFormat: 'SHP', folder: 'Geodatabase'});

////////////////////////////////////////////////////////////////////////////// Are of Interest (AOI) /////////////////////////////////////////////////////////////////////
//https://code.earthengine.google.com/?asset=projects/ee-carlosmendez1997/assets/SA_Countries
var AOI = ee.FeatureCollection("projects/ee-carlosmendez1997/assets/SA_Countries").geometry();

// Next Steps
// Clip the rasters in AOI
// Export the rasters to Google Drive.

////////////////////////////////////////////////////////////////////////////// 2. FLAU /////////////////////////////////////////////////////////////////////
//First Level Administrative Units South America (FLAU_SA) 
var Flau_SA = ee.FeatureCollection("FAO/GAUL_SIMPLIFIED_500m/2015/level1").select('ADM1_NAME').filterBounds(AOI);
Export.table.toDrive({collection: Flau_SA, description: "FLAU_SA", fileFormat: 'GeoJSON', folder: 'Geodatabase'});

////////////////////////////////////////////////////////////////////////////// 3. SLAU /////////////////////////////////////////////////////////////////////
//Second Level Administrative Units South America (SLAU_SA)
var Slau_SA = ee.FeatureCollection("FAO/GAUL_SIMPLIFIED_500m/2015/level2").select('ADM2_NAME').filterBounds(AOI);
Export.table.toDrive({collection: Slau_SA, description: "SLAU_SA", fileFormat: 'GeoJSON', folder: 'Geodatabase'});

////////////////////////////////////////////////////////////////////////////// 4. HydroSHEDS (Raster) /////////////////////////////////////////////////////////////////////

//Conditioned DEM 15 Arc seconds
var Hydrosheds_CondDem15Arc = ee.Image("WWF/HydroSHEDS/15CONDEM").clip(AOI);
Export.image.toDrive({image: Hydrosheds_CondDem15Arc, description: "HydroSHEDS_CondDem15Arc_SA", fileFormat: 'GeoTIFF', folder: 'Geodatabase'});
//Conditioned DEM 30 Arc seconds
var Hydrosheds_CondDem30Arc = ee.Image("WWF/HydroSHEDS/30CONDEM").clip(AOI);
Export.image.toDrive({image: Hydrosheds_CondDem30Arc, description: "HydroSHEDS_CondDem30Arc_SA", fileFormat: 'GeoTIFF', folder: 'Geodatabase'});


//Flow Accumulation 15 Arc seconds
var Hydrosheds_FloAccu15Arc = ee.Image("WWF/HydroSHEDS/15ACC").clip(AOI);
Export.image.toDrive({image: Hydrosheds_FloAccu15Arc, description: "HydroSHEDS_FloAccu15Arc_SA", fileFormat: 'GeoTIFF', folder: 'Geodatabase'});
//Flow Accumulation 30 Arc seconds
var Hydrosheds_FloAccu30Arc = ee.Image("WWF/HydroSHEDS/30ACC").clip(AOI);
Export.image.toDrive({image: Hydrosheds_FloAccu30Arc, description: "HydroSHEDS_FloAccu30Arc_SA", fileFormat: 'GeoTIFF', folder: 'Geodatabase'});


//Flow Drainage Direction 3 Arc seconds
var Hydrosheds_FloDire15Arc = ee.Image("WWF/HydroSHEDS/15DIR").clip(AOI);
Export.image.toDrive({image: Hydrosheds_FloDire15Arc, description: "HydroSHEDS_FloDire15Arc_SA", fileFormat: 'GeoTIFF', folder: 'Geodatabase'});
//Flow Drainage Direction 3 Arc seconds
var Hydrosheds_FloDire30Arc = ee.Image("WWF/HydroSHEDS/30DIR").clip(AOI);
Export.image.toDrive({image: Hydrosheds_FloDire30Arc, description: "HydroSHEDS_FloDire30Arc_SA", fileFormat: 'GeoTIFF', folder: 'Geodatabase'});


//Void DEM 3 Arc seconds
var Hydrosheds_VoidDem3Arc = ee.Image("WWF/HydroSHEDS/03VFDEM").clip(AOI);
Export.image.toDrive({image: Hydrosheds_VoidDem3Arc, description: "Hydrosheds_VoidDem3Arc_SA", fileFormat: 'GeoTIFF', folder: 'Geodatabase'});

////////////////////////////////////////////////////////////////////////////// 5. HydroBASINS /////////////////////////////////////////////////////////////////////
// Creation of a for looping to get the 12 hydroBASINS levels

for (var i = 1; i < 13; i++) 
{
  //Load all basins levels
  var basin = ee.FeatureCollection("WWF/HydroSHEDS/v1/Basins/hybas_" + [i]);
  var basin_level = basin.filterBounds(AOI);
  Export.table.toDrive({collection: basin_level, description: "HydroBASINS_lv"+ [i]+"_SA", fileFormat: 'SHP', folder: 'Geodatabase'});
}

////////////////////////////////////////////////////////////////////////////// 6. HydroRIVERS /////////////////////////////////////////////////////////////////////
// File downloaded from: https://www.hydrosheds.org/products/hydrorivers
//https://code.earthengine.google.com/?asset=projects/ee-carlosmendez1997/assets/SA_HydroRIVERS
var Hydrorivers = ee.FeatureCollection("projects/ee-carlosmendez1997/assets/SA_HydroRIVERS");
Export.table.toDrive({collection: Hydrorivers, description: "HydroRIVERS_SA", fileFormat: 'SHP', folder: 'Geodatabase'});

////////////////////////////////////////////////////////////////////////////// 7. HydroLAKES /////////////////////////////////////////////////////////////////////
// File downloaded from: https://www.hydrosheds.org/products/hydrolakes
//https://code.earthengine.google.com/?asset=projects/ee-carlosmendez1997/assets/SA_HydroLAKES
var Hydrolakes = ee.FeatureCollection("projects/ee-carlosmendez1997/assets/SA_HydroLAKES");
Export.table.toDrive({collection: Hydrolakes, description: "HydroLAKES_SA", fileFormat: 'SHP', folder: 'Geodatabase'});

////////////////////////////////////////////////////////////////////////////// 8. GLWD /////////////////////////////////////////////////////////////////////
// The Global Lakes and Wetlands Database (GLWD) exceed the maximum lenght file in GEE
// Download directly the file in: https://www.hydrosheds.org/products/glwd

////////////////////////////////////////////////////////////////////////////// 9. HydroWASTE /////////////////////////////////////////////////////////////////////
// File downloaded from: https://www.hydrosheds.org/products/hydrowaste
//https://code.earthengine.google.com/?asset=projects/ee-carlosmendez1997/assets/SA_HydroWASTE
var Hydrowaste = ee.FeatureCollection("projects/ee-carlosmendez1997/assets/SA_HydroWASTE");
Export.table.toDrive({collection: Hydrowaste, description: "HydroWASTE_SA", fileFormat: 'SHP', folder: 'Geodatabase'});

////////////////////////////////////////////////////////////////////////////// 10. GloRiC /////////////////////////////////////////////////////////////////////
// File downloaded from: https://www.hydrosheds.org/products/gloric
//https://code.earthengine.google.com/?asset=projects/ee-carlosmendez1997/assets/SA_GloRiC
var Gloric = ee.FeatureCollection("projects/ee-carlosmendez1997/assets/SA_GloRiC");
Export.table.toDrive({collection: Gloric, description: "GloRiC_SA", fileFormat: 'SHP', folder: 'Geodatabase'});

////////////////////////////////////////////////////////////////////////////// 11. LakeTEMP /////////////////////////////////////////////////////////////////////
// File downloaded from: https://www.hydrosheds.org/products/laketemp
//https://code.earthengine.google.com/?asset=projects/ee-carlosmendez1997/assets/SA_LakeTEMP
var Laketemp = ee.FeatureCollection("projects/ee-carlosmendez1997/assets/SA_LakeTEMP");
Export.table.toDrive({collection: Laketemp, description: "LakeTEMP_SA", fileFormat: 'SHP', folder: 'Geodatabase'});

////////////////////////////////////////////////////////////////////////////// 12. GPPD /////////////////////////////////////////////////////////////////////
// Global Power Plant Database
var GPPD_SA = ee.FeatureCollection('WRI/GPPD/power_plants').filterBounds(AOI);
Export.table.toDrive({collection: GPPD_SA, description: "GPPD_SA", fileFormat: 'SHP', folder: 'Geodatabase'});
