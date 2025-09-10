shader_type canvas_item;
#include "fractal_include.gdshaderinc"
uniform float shader_time;
group_uniforms kaleidoscope;
uniform bool enable_kaleidoscope = true;
uniform vec2 resolution = vec2(1600, 1200);
uniform sampler2D tex: repeat_enable;
uniform float slices: hint_range(2.0, 100.0, 1.0) = 12;
uniform float speed: hint_range(0.0, 10.0, 0.01) = 0.5;

group_uniforms fractal;
uniform float zoom = 4.0;
uniform float center_X: hint_range(-10.0, 10.0, 0.00001) = 0.26;
uniform float center_Y: hint_range(-10.0, 10.0, 0.00001) = 0.00181;
uniform vec2 center = vec2(0.26, 0.00181);

uniform int max_iterations = 2000;

uniform float debug: hint_range(-5.0, 10.0, 0.01);
uniform float _debug_fun: hint_range(-5.0, 10.0, 0.01);
uniform float _Threshold : hint_range(0.0, 10.0, 0.1);

group_uniforms palette;
uniform bool enable_palette_cycling = true;
uniform sampler2D gradient: repeat_enable, filter_nearest;
uniform float color_speed: hint_range(0.0, 10.0, 0.01) = 0.5;

mat2 rotate(float angle){
	float sine_of_angle = sin(angle);
	float cosine_of_angle = cos(angle);
	return mat2(vec2(cosine_of_angle, sine_of_angle), vec2(-sine_of_angle, cosine_of_angle));
}

vec2 fold(vec2 uv){
	float theta = atan(uv.x, uv.y);
	float slice = TAU / slices;
	float slice_id = floor(theta / slice);
	float angle = slice * slice_id;
	if(mod(slice_id, 2.0) >= 1.0){
		uv.y = -uv.y;
		angle = -(slice * (slice_id + slices / 2.0 +1.0));
	}
	uv = rotate(angle) * uv;
	return uv;
}

float fractal(vec2 uv){
	vec2 z = vec2(0.0);
	vec2 c = uv * zoom + center;
	float iterations = 0.0;
	
	for(int i = 0; i < max_iterations; i++){
		z = vec2(z.x * z.x - z.y * z.y, debug * z.x * z.y) + c;
		if(length(z) > 2.0){
			break;
		}
		iterations++;
	}
	return iterations / float(max_iterations);
}
vec4 palette_swap_cycle(float input, float cycle_speed){
	return texture(gradient, vec2(input + cycle_speed, 0.0));
}

void fragment() {
	vec2 uv = UV -0.5;

	if(enable_kaleidoscope){
		uv.x *= resolution.x / resolution.y;
		float angle = shader_time * speed;
		uv = rotate(angle) * fold(uv);
	}
	
	vec2 _center = vec2(center_X, center_Y);
	//float iteration_col = secant_sea(uv, zoom, _center, debug, max_iterations, resolution);
	float iteration_col = ship(uv, zoom, _center, max_iterations, debug, _Threshold);
	//float iteration_col = fractal(uv);//
	/*vec3 color = texture(tex,uv).rgb;
	color *= clamp(iteration_col * 10., -1.0, 1.5);*/
	vec4 color = vec4(1.0);
	if(enable_palette_cycling){
		color = palette_swap_cycle(iteration_col, shader_time*color_speed);
	} else {
		//color.rgb = texture(tex,uv).rgb;
		//color.rgb *= clamp(iteration_col * 10., -1.0, 1.5);
		color.rgb = vec3(iteration_col);
		color.a = 1.0;
	}
	COLOR = color;
}
