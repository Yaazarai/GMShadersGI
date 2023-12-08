// SYSTEM FRAME ITERATORS:
global.gi_temporalframe = !global.gi_temporalframe;
global.gi_frametime += 2.0 * global.gi_usetimeoffsets;

// EXAMPLE SYSTEM CONTROLS:
global.gi_raysperpixel += 8 * (keyboard_check_pressed(ord("A")) - keyboard_check_pressed(ord("D")));
global.gi_temporalfactor += 0.05 * (keyboard_check_pressed(ord("W")) - keyboard_check_pressed(ord("S")));
global.gi_usetimeoffsets ^= keyboard_check_pressed(ord("Z"));
global.gi_usetemporalfilter ^= keyboard_check_pressed(ord("X"));
global.gi_usedebuginterface ^= keyboard_check_pressed(ord("C"));

if (keyboard_check_pressed((vk_space)))
	game_restart();

// SYSTEM CLAMPING RESTRICTIONS:
global.gi_resolution = power(2, ceil(log2(real(global.gi_resolution))));
global.gi_raysperpixel = clamp(real(global.gi_raysperpixel), 8, 256);
global.gi_temporalfactor = clamp(real(global.gi_temporalfactor), 0.05, 0.95);