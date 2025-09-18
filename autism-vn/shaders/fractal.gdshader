shader_type canvas_item;
#include "fractal_include.gdshaderinc"

uniform vec2 resolution = vec2(1600, 1200);

uniform float zoom = 4.0;
uniform vec2 center = vec2(0.26, 0.00181);
uniform int max_iterations = 2000;
uniform float _Threshold : hint_range(0.0, 10.0, 0.1) = 2.0;
uniform float power : hint_range(0.0, 10.0, 0.1) = 2.0;

uniform float debug: hint_range(-5.0, 10.0, 0.01);


float burning_ship(vec2 uv){
	vec2 z = vec2(0.0);
	vec2 c = uv * zoom + center;
	float iterations = 0.0;

	for(int i = 0; i < max_iterations; i++){
		z = vec2(z.x * z.x - z.y * z.y, debug * z.x * z.y) + c;
		//z = mat2(z, vec2(z.x,-z.y)) * z;
		z.y = abs(z.y);
		//z -= .1*uv/resolution.y + vec2(1.66, -.02);
		if(length(z) > _Threshold){
			break;
		}
		iterations++;
	}
	return iterations / float(max_iterations);
}


void fragment() {
	vec2 uv = UV - 0.5;
	//uv = 0.5 * (2.0 * FRAGCOORD.xy-resolution)/resolution.y;
	//uv.y = -uv.y;
	//vec2 uv, float zoom, vec2 center, int max_iterations, float debug, float threshold)
	//float color = secant_sea(uv, zoom, center, debug, max_iterations, resolution);//ship(uv);//ship(uv) / float(max_iterations);
	float color = ship(uv, zoom, center, max_iterations, debug, _Threshold);
	color *= power;
	COLOR = vec4(color, color, color, 1.0);//vec4(sqrt(color), color*color*color, max(0., sin(6.283*color)), 1.0);
}