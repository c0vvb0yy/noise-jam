shader_type canvas_item;

uniform float speed :hint_range(0.0, 10.0, 0.1) = 3.;
uniform float strength : hint_range(0.0, 1.0, 0.01);
uniform float noise_strength : hint_range(0.0, 1.0, 0.01);
uniform float desaturation_power :hint_range(0.0, 2.0, 0.01);
uniform sampler2D noise;

void fragment() {
	float t = TIME / speed;
	vec3 col = vec3(0.0);
	vec2 pos = SCREEN_UV * 2.0 - 1.0;
	
	vec2 fragCoord = FRAGCOORD.xy;
	vec2 resolution = FRAGCOORD.xy;//SCREEN_PIXEL_SIZE;
	float noise_value = texture(noise, UV).r * noise_strength;
	pos.y *= resolution.x / resolution.y;
	
	pos = 4.0 * (vec2(0.5) - pos);
	for(float k = 1.0; k < 7.0; k+=1.0){ 
        pos.x += strength * sin(2.0*t+k*1.5 * pos.y)+t*0.5;// * texture(noise, UV).r;
        pos.y += strength * cos(2.0*t+k*1.5 * pos.x) -t * (texture(noise, UV).r * noise_strength);
		pos.y *= noise_value;
		//pos *= texture(noise, UV).rg;
    }
	
	col += 0.5 + 0.5*cos(TIME + pos.xyx + vec3(0.,2.,4.));
	
	col *= pow(col, vec3(0.4545));
	vec3 lum = vec3(0.799, 0.187, 0.114);
	vec3 gray = vec3(dot(lum, col));
	col = mix(col, gray, clamp(UV.x * desaturation_power, 0.0, 1.0));// mix(vec3(dot(col, vec3(0.1, 0.1, 0.1))), col, UV.x);
	
	//COLOR = vec4(UV.x * desaturation_power, UV.y, 0.0, 1.0);
	COLOR = vec4(col, 1.0);
}
