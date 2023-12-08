/// LIGHTING SETTINGS:
game_set_speed(60, gamespeed_fps);
global.gi_resolution = 1024.0;
global.gi_raysperpixel = 32.0;
global.gi_stepsperray = 32.0;

global.gi_usedebuginterface = true;
global.gi_usetimeoffsets = true;
global.gi_usetemporalfilter = false;
global.gi_usesmartdenoisefilter = false;
global.gi_temporalfactor = 0.5;

// STEP ITERATOR VARIABLES:
global.gi_temporalframe = 0.0;
global.gi_frametime = 0.0;

/// LIGHTING SHADERS & INITIALIZATION:
gilight_defaultshaders();
gilight_initialize();

/// USER GAME WORLD SURFACES:
#macro INVALID_SURFACE -1

/// UTILITY SURFACES:
gameworld_transfer = INVALID_SURFACE;
gameworld_jumpflood = INVALID_SURFACE;

/// RENDER SURFACES
gameworld_worldscene = INVALID_SURFACE;
gameworld_worldsceneSDF = INVALID_SURFACE;
gameworld_radialbluenoise = INVALID_SURFACE;
gameworld_gisurface[0] = INVALID_SURFACE;
gameworld_gisurface[1] = INVALID_SURFACE;

// FILTER SURFACES:
gameworld_postprocessfilter = INVALID_SURFACE;