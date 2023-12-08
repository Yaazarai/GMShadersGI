varying vec2 in_FragCoord;
uniform float in_WorldTime;
uniform float in_RaysPerPixel;

//#define PHI float(1.6180339887498948482045868343656)
#define TAU float(6.2831853071795864769252867665590)

void main() {
    vec4 sample = texture2D(gm_BaseTexture, in_FragCoord);
	//float bluenoise = fract(sample.r + (in_WorldTime * PHI));
    //gl_FragColor = vec4(vec3(bluenoise), 1.0);
	float bluenoise = mod((sample.r * TAU) + (in_WorldTime * (1.0/TAU)), TAU);
	gl_FragColor = vec4(vec3(bluenoise / TAU), 1.0);
}