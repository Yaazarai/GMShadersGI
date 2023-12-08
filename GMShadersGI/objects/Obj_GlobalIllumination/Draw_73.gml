// Make sure blending is enabled when combining surfaces with existing data.
gpu_set_blendenable(true);

	// Draw and Seed the World Scene into the Global Illumination render surface.
	surface_set_target(gameworld_gisurface[1 - global.gi_temporalframe]);
		draw_surface_ext(gameworld_worldscene, 0, 0, 1, 1, 0, c_white, 1);
	surface_reset_target();

// Disable blending for all Global Illumination render processes (we don't care about alpha components here).
gpu_set_blendenable(false);

	// Generate the JFA + SDF of the world scene.
	gilight_jfaseeding(gameworld_worldscene, gameworld_transfer, gameworld_jumpflood);
	gilight_jfarender(gameworld_transfer, gameworld_jumpflood);
	gilight_distancefield(gameworld_jumpflood, gameworld_worldsceneSDF);
	
	// Generate the special radial blue noise.
	gilight_radialbluenoise(gameworld_radialbluenoise, (global.gi_usetimeoffsets)?global.gi_frametime:0.0);
	
	// Generate the final Global Illumination Scene.
	surface_set_target(gameworld_gisurface[global.gi_temporalframe]);
		shader_set(global.gi_gilight);
		shader_set_uniform_f(global.gi_gilight_uResolution, global.gi_resolution);
		shader_set_uniform_f(global.gi_gilight_uRaysPerPixel, global.gi_raysperpixel);
		shader_set_uniform_f(global.gi_gilight_uStepsPerRay, global.gi_stepsperray);
		texture_set_stage(global.gi_gilight_uDistanceField, surface_get_texture(gameworld_worldsceneSDF));
		texture_set_stage(global.gi_gilight_uBlueNoise, surface_get_texture(gameworld_radialbluenoise));
		draw_surface(gameworld_gisurface[1 - global.gi_temporalframe], 0, 0);
		shader_reset();
	surface_reset_target();

// Re-Enable Alpha Blending since the Global Illumination pass is complete.
gpu_set_blendenable(true);

if (global.gi_usetemporalfilter) {
	gpu_set_blendenable(false);
	gilight_temporalfilter(gameworld_postprocessfilter, gameworld_gisurface[global.gi_temporalframe], gameworld_transfer);
	gpu_set_blendenable(true);
} else {
	surface_set_target(gameworld_postprocessfilter);
	draw_clear(c_black);
	draw_surface(gameworld_gisurface[global.gi_temporalframe], 0, 0);
	surface_reset_target();
}

gpu_set_blendmode(bm_add);
draw_surface(gameworld_postprocessfilter, 0, 0);
draw_surface(gameworld_postprocessfilter, 0, 0);
gpu_set_blendmode(bm_normal);

if (global.gi_usedebuginterface) {
	draw_set_color(c_black);
	draw_set_font(Fnt_MonoSpace);
	draw_set_color(c_black);
	draw_set_alpha(0.25);
	draw_rectangle(0, 0, 270, 205, false);
	draw_set_alpha(0.5);
	draw_set_color(c_yellow);
	draw_text(5, 5,   "Frame Rate:          " + string(fps));
	draw_text(5, 25,  "Resolution:          " + string(global.gi_resolution));
	draw_text(5, 45,  "[A,D] Ray Count:     " + string(global.gi_raysperpixel));
	draw_text(5, 65,  "[W,S] Temporal:      " + string(global.gi_temporalfactor));
	draw_text(5, 85,  "[*,*] World Time:    " + string(global.gi_frametime));
	draw_text(5, 105, "[Z] Time Offsets:    " + string((global.gi_usetimeoffsets)?"TRUE":"FALSE"));
	draw_text(5, 125, "[X] Temporal Filter: " + string((global.gi_usetemporalfilter)?"TRUE":"FALSE"));
	draw_text(5, 145, "[C] Debug Interface: " + string((global.gi_usedebuginterface)?"TRUE":"FALSE"));
	draw_set_alpha(1.0);
	draw_set_color(c_white);
}