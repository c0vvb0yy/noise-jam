shader_type canvas_item;
//By ericalfaro on godotshaders.com

// Animate from 0 to 1
uniform float progress: hint_range(0.0, 1.0) = 0.0;

// How jagged each band of melting pixels are
uniform float meltiness: hint_range(0.0, 16.0) = 1.0;

uniform sampler2D screen_texture: hint_screen_texture;

float psuedo_rand(float x) {
	return mod(x * 2048103.0 + cos(x * 1912.0), 1.0);
}

void fragment() {
	vec2 uv = UV;

	// Move pixels near the top faster
	uv.y -= progress / UV.y;

	// Created jagged edges for each pixel on the x-axis
	uv.y -= progress * meltiness * psuedo_rand(mod(UV.x, (SCREEN_PIXEL_SIZE.x*20.) + psuedo_rand(UV.y*20.) * 7.));

	COLOR = texture(screen_texture, uv);

	// "delete" pixels out of range
	if (uv.y <= 0.0) {
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	}
}
