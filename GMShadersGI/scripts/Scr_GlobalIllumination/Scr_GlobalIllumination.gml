function draw_sprite_emitter(spr,subimg,xpos,ypos,xscale,yscale,rot,col) {
	draw_sprite_ext(spr, subimg, xpos, ypos, xscale, yscale, rot, col, 1.0);
}

function draw_surface_emitter(surf,xpos,ypos,xscale,yscale,rot, col) {
	draw_surface_ext(surf, xpos, ypos, xscale, yscale, rot, col, 1.0);
}

function gilight_defaultshaders() {
	global.gi_jfaseeding = Shd_JfaSeeding;
	global.gi_jumpfloodalgorithm = Shd_JumpFloodAlgorithm;
	global.gi_distancefield = Shd_DistanceField;
	global.gi_radialbluenoise = Shd_RadialBlueNoise;
	global.gi_bluenoisetexture = Spr_BlueNoise512;
	global.gi_gilight = Shd_GILight;
	global.gi_temporalfilter = Shd_TemporalFilter;
}

function gilight_initialize() {
	global.gi_resolution = power(2, ceil(log2(real(global.gi_resolution))));
	global.gi_raysperpixel = clamp(real(global.gi_raysperpixel), 8, 256);
	global.gi_stepsperray = clamp(real(global.gi_stepsperray), 8, 256);
	
	global.gi_jumpfloodalgorithm_uResolution = shader_get_uniform(global.gi_jumpfloodalgorithm, "in_Resolution");
	global.gi_jumpfloodalgorithm_uJumpDistance = shader_get_uniform(global.gi_jumpfloodalgorithm, "in_JumpDistance");
	global.gi_radialbluenoise_uWorldTime = shader_get_uniform(global.gi_radialbluenoise, "in_WorldTime");
	global.gi_gilight_uResolution = shader_get_uniform(global.gi_gilight, "in_Resolution");
	global.gi_gilight_uRaysPerPixel = shader_get_uniform(global.gi_gilight, "in_RaysPerPixel");
	global.gi_gilight_uStepsPerRay = shader_get_uniform(global.gi_gilight, "in_StepsPerRay");
	global.gi_gilight_uDistanceField = shader_get_sampler_index(global.gi_gilight, "in_DistanceField");
	global.gi_gilight_uBlueNoise = shader_get_sampler_index(global.gi_gilight, "in_BlueNoise");
	global.gi_temporalfilter_uTemporalFactor = shader_get_uniform(global.gi_temporalfilter, "in_TemporalFactor");
	global.gi_temporalfilter_uPreviousFrame = shader_get_sampler_index(global.gi_temporalfilter, "in_PreviousFrame");
}

function gilight_clear(surface) {
    surface_set_target(surface);
    draw_clear_alpha(c_black, 0);
    surface_reset_target();
}

function gilight_jfaseeding(init, jfaA, jfaB) {
    surface_set_target(jfaB);
    draw_clear_alpha(c_black, 0);
    shader_set(global.gi_jfaseeding);
    draw_surface(init,0,0);
    shader_reset();
    surface_reset_target();
    
    surface_set_target(jfaA);
    draw_clear_alpha(c_black, 0);
    surface_reset_target();
}

function gilight_jfarender(source, destination) {
    var passes = ceil(log2(global.gi_resolution));
    
    shader_set(global.gi_jumpfloodalgorithm);
    shader_set_uniform_f(global.gi_jumpfloodalgorithm_uResolution, global.gi_resolution);
	
	var tempA = source, tempB = destination, tempC = source;
    var i = 0; repeat(passes) {
        var offset = power(2, passes - i - 1);
        shader_set_uniform_f(global.gi_jumpfloodalgorithm_uJumpDistance, offset);
        surface_set_target(tempA);
			draw_surface(tempB,0,0);
        surface_reset_target();
		
		tempC = tempA;
		tempA = tempB;
		tempB = tempC;
        i++;
    }
    
    shader_reset();
	if (destination != tempC) {
		surface_set_target(destination);
			draw_surface(tempC,0,0);
        surface_reset_target();
	}
}

function gilight_distancefield(jfa, surface) {
    surface_set_target(surface);
    draw_clear_alpha(c_black, 0);
    shader_set(global.gi_distancefield);
    draw_surface(jfa, 0, 0);
    shader_reset();
    surface_reset_target();
}

function gilight_radialbluenoise(surface, time) {
    surface_set_target(surface);
	shader_set(global.gi_radialbluenoise);
	shader_set_uniform_f(global.gi_radialbluenoise_uWorldTime, time);
    draw_sprite_tiled(global.gi_bluenoisetexture, 0, 0, 0);
	shader_reset();
    surface_reset_target();
}

function gilight_temporalfilter(temporalframe, currentframe, transferframe) {
	surface_set_target(transferframe);
	draw_surface(temporalframe, 0, 0);
	surface_reset_target();
	
	surface_set_target(temporalframe);
	shader_set(global.gi_temporalfilter);
	shader_set_uniform_f(global.gi_temporalfilter_uTemporalFactor, global.gi_temporalfactor);
	texture_set_stage(global.gi_temporalfilter_uPreviousFrame, surface_get_texture(transferframe));
	draw_surface(currentframe, 0, 0);
	shader_reset();
	surface_reset_target();
}