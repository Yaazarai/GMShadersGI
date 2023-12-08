if (!surface_exists(gameworld_worldscene)) gameworld_worldscene = surface_create(global.gi_resolution,global.gi_resolution);
if (!surface_exists(gameworld_transfer)) gameworld_transfer = surface_create(global.gi_resolution,global.gi_resolution);
if (!surface_exists(gameworld_jumpflood)) gameworld_jumpflood = surface_create(global.gi_resolution,global.gi_resolution);
if (!surface_exists(gameworld_worldsceneSDF)) gameworld_worldsceneSDF = surface_create(global.gi_resolution,global.gi_resolution);
if (!surface_exists(gameworld_radialbluenoise)) gameworld_radialbluenoise =  surface_create(global.gi_resolution,global.gi_resolution);
if (!surface_exists(gameworld_gisurface[0])) gameworld_gisurface[0] =  surface_create(global.gi_resolution,global.gi_resolution);
if (!surface_exists(gameworld_gisurface[1])) gameworld_gisurface[1] =  surface_create(global.gi_resolution,global.gi_resolution);
if (!surface_exists(gameworld_postprocessfilter)) gameworld_postprocessfilter =  surface_create(global.gi_resolution,global.gi_resolution);