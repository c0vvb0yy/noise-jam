shader_type canvas_item;
#include "fractal_include.gdshaderinc"

uniform sampler2D screen_texture : hint_screen_texture;
uniform float strength : hint_range(0.0, 1.0, 0.001);
uniform vec2 block_size = vec2(16.0, 16.0);
uniform vec2 resolution = vec2(1920, 1080);
uniform sampler2D noise_map;

void fragment() {
	
	vec2 pixel_uv = UV * resolution;
	float rem_x = mod(pixel_uv.x, block_size.x);
	float rem_y = mod(pixel_uv.y, block_size.y);
	
	vec2 uv = vec2(pixel_uv - vec2(rem_x, rem_y)) / resolution;
	
	float r1 = random_time_based(uv, TIME * 0.000006);
	float r2 = random_time_based(uv.yx, TIME * 0.000006);
	vec2 centered_uv = UV * 2.0 - 1.0;
	vec2 noise = texture(noise_map, uv + vec2(r1, r2)).rg;
	COLOR = texture(screen_texture, vec2(SCREEN_UV.y, SCREEN_UV.y - noise.y *  strength));
}
