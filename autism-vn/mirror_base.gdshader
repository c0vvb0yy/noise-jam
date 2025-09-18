shader_type canvas_item;


uniform vec4 shine_color : source_color;
uniform float shine_progress : hint_range(-1.0, 2.5, 0.01) = 0.0;
uniform float shine_size : hint_range(0.01, 1.0, 0.01) = 0.1;
uniform float shine_angle : hint_range(0.0, 360., 0.1) = 45.0;
uniform vec2 grid_size = vec2(16.);
uniform int shine_numbers = 2;
uniform sampler2D screen_texture : hint_screen_texture;

float scale(float value, float inMin, float inMax, float outMin, float outMax) {
    return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
}
float T(float value){
	return 3.0 + mod(TIME/1000. * 60., value - 3.);
}
float rgrid(vec2 pix){
	 float b;
    // horizontal bars every 5 pixels
    b = mod(pix.x, T(5.))<1. ? 1.:0.;
    // delete every other pixel in each bar
    b = b * (mod(pix.y, sin(TIME)+1.5)<2.?1.:0.);
    // delete every other group of four pixels
    b = b * (mod(pix.y/T(4.), 2.)<1.?1.:0.);
    // delete every other group of six
    //b = b * (mod(pix.y/4.5, T(2.))<1.?1.:0.);
    // now delete alternating groups of four, but horizontally
    //b = b * (mod(pix.x/4.0, 2.)<1.?1.:0.);
    return b;
}
void fragment() {
	vec2 pos = FRAGCOORD.xy;
	vec2 pix = floor(pos/grid_size);
	float b = rgrid(pix);
    COLOR = vec4(0.,0.,0.,1.);
	for(int i = 1; i <= shine_numbers; i++){
		float slope = tan(radians(shine_angle));
		float progress = scale(shine_progress, 0.0, 1.0, -1.0 - shine_size - shine_size * slope, 1.0 * slope) - 0.2 * float(i);
	    float shine = step(slope * UV.x - UV.y, progress + (shine_size - 0.1 * float(i)) + shine_size * slope) - step(slope * UV.x - UV.y, progress);
    	COLOR.rgb = mix(COLOR.rgb, shine_color.rgb, shine * shine_color.a * b);
	}
}