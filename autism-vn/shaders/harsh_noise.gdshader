shader_type canvas_item;
#include "fractal_include.gdshaderinc"

uniform float steps :hint_range(0.0, 1.0, 0.0001); 
uniform float grid_size : hint_range(0.0, 10.0, 0.1); 
uniform float debug : hint_range(0.0, 10.0, 0.1);

float T(float value){
	return 3.0 + mod(TIME/1000. * 60., value - 3.);
}

float rgrid(vec2 pix){
	 float b;

    // horizontal bars every 5 pixels
    b = mod(pix.x, T(8.2))<1. ? 1.:0.;

    // delete every other pixel in each bar
    b = b * (mod(pix.y, sin(TIME)+1.5)<2.?1.:0.);

    // delete every other group of four pixels
    b = b * (mod(pix.y/T(8.), 2.)<1.?1.:0.);

    // delete every other group of six
    b = b * (mod(pix.y/4.5, T(2.))<1.?1.:0.);

    // now delete alternating groups of four, but horizontally
    b = b * (mod(pix.x/debug, 2.)<1.?1.:0.);

    return b;
}

float rrgrid(vec2 pix)
{
    // generate random grid of pixels
    float b = rgrid(pix);
    // add another pass with an offset
    b += rgrid(vec2(pix.x-6.,pix.y-3.));
    b += rgrid(vec2(pix.x+3.,pix.y-8.));
    // add pass with rotation
    float a = 3.3;
    float c = cos(a);
    float s = sin(a);
    b += rgrid(vec2(pix.x * c - pix.y * s,pix.x * s + pix.y * c));
    // pass with rotation and offset
    a = T(-7.7);
    c = cos(a);
    s = sin(a);
    b += rgrid(vec2(pix.x * c - pix.y * s-T(.4),pix.x * s + pix.y * c-3.));
    return min(1.,max(b,0.));
  }

void fragment() {
	
	vec2 pos = FRAGCOORD.xy;
	vec2 pix = floor(pos/grid_size);
	
	float b = rrgrid(pix);
    b += rrgrid(vec2(pix.x+4., pix.y+10.));
    b += rrgrid(vec2(pix.x+T(69.), pix.y+11.));
    b += rrgrid(vec2(pix.x+2., pix.y+86.));
    b += rrgrid(vec2(pix.x+2., pix.y+T(81.)));

	COLOR = vec4(vec3(b), 1.0);
	
	/*vec3 color = vec3(0.0);
	float modulo_y = mod((UV.y + random(UV / TIME)) / tan(TIME / steps), 2.0) * (sin(TIME / 1.8974));// * random(vec2(UV / TIME)));
	float modulo_x = mod((UV.x + random(UV / TIME)) / sin(TIME / steps), 2.0) * (tan(TIME / 3.507) / random(vec2(UV / TIME)));
	//modulo_y = clamp(modulo_y, 0.1, 1.);
	//modulo_x = clamp(modulo_x, 0.1, 1.);
	
	if(modulo_x >= 0.1 || modulo_x <= 0.001){
		color = vec3(1.0, 0.0,0.0);
	}
	if(modulo_y >= 0.1 || modulo_y <= 0.00001){
		//color = vec3(1.0);
		color = vec3(0.0, 0.0, 1.0);
	}
	
	/*if(modulo_y <= 0.0000001){
		color = vec3(0.0, 1.0, 0.0);
	}*/
	
	/*if(modulo_x >= 0.1 || modulo_y >= 0.1){
		color = vec3(1.0);
	}*/
		
	/*if(modulo_x >= random(UV / TIME)){
		color = vec3(0.);
	}*/
	/*COLOR = vec4(color, 1.0);*/
}
