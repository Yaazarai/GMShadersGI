varying vec2      in_FragCoord;
uniform float     in_Resolution, in_RaysPerPixel, in_StepsPerRay;
uniform sampler2D in_DistanceField, in_BlueNoise;

#define EPSILON  0.0001
#define TAU      float(6.2831853071795864769252867665590)
#define V2F16(v) ((v.y * float(0.0039215686274509803921568627451)) + v.x)

vec3 raymarch(vec2 pix, vec2 dir) {
	for(float dist = 0.0, i = 0.0; i < in_StepsPerRay; i += 1.0, pix += dir * dist) {
		vec2 sdf = texture2D(in_DistanceField, pix).rg;
		
		if ((dist = V2F16(sdf)) < EPSILON)
			return max(texture2D(gm_BaseTexture, pix).rgb, texture2D(gm_BaseTexture, pix - (dir * (1.0/in_Resolution))).rgb);
	}
	return vec3(0.0);
}

void main() {
    vec2 sdf = texture2D(in_DistanceField, in_FragCoord).rg;
	vec3 light = texture2D(gm_BaseTexture, in_FragCoord).rgb;
	
	if (V2F16(sdf) >= EPSILON) {
	    float brightness = max(light.r, max(light.g, light.b)),
			noise = TAU * texture2D(in_BlueNoise, in_FragCoord).r;
	    for(float ray = 0.0; ray < TAU; ray += TAU / in_RaysPerPixel) {
	        vec2 ray_angle = vec2(cos(noise + ray), -sin(noise + ray));
	        vec3 hit_color = raymarch(in_FragCoord, ray_angle);
			light += hit_color;
	        brightness += max(hit_color.r, max(hit_color.g, hit_color.b));
	    }
		
	    light = (light / brightness) * (brightness / in_RaysPerPixel);
	}

	gl_FragColor = vec4(light, 1.0);
}