shader_type canvas_item;

uniform float _debug_fun :hint_range(-1.0, 2.0, 0.01); 
uniform float _power :hint_range(0.0, 10.0, 0.01); 
uniform float _dither_offset_x :hint_range(-100.0, 1000.0, 0.01);
uniform float _dither_offset_y :hint_range(-100.0, 1000.0, 0.01); 
uniform float _min_value :hint_range(0.0, 1.0, 0.01); //0.59
uniform float _max_value :hint_range(0.0, 1.0, 0.01); //0.63 <- both good values for a dither band
uniform float _sec_min_value :hint_range(0.0, .1, 0.01); 
uniform float _sec_max_value :hint_range(0.0, .1, 0.01); 
uniform float dither_threshold : hint_range(0.0, 1.0, 0.01);
uniform vec4 dither_color :source_color;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D dither_texture;

vec3 rgb2hsv(vec3 c){
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c){
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
	
    vec3 col = texture(screen_texture, SCREEN_UV).xyz;
	vec3 hsv = rgb2hsv(col);
	float dither_value = texture(dither_texture, SCREEN_UV).x;//vec3(0);
	if (hsv.z < _min_value){
		col = vec3(0);
	}
	if (hsv.z >= _max_value){
		col = vec3(1);
	}
	
	
    if (hsv.z < _max_value && hsv.z > _min_value){
		col = vec3(0.5);
		float _dither_threshold = dither_threshold;
		//less dithering for inner edge
		if(hsv.z > _max_value - _sec_max_value){
			_dither_threshold -= 0.3;
			//col = vec3(1.0, .0,.0);
			//COLOR.xyz = col;
		}
		//more dithering for outer edge
		if(hsv.z < _min_value + _sec_min_value){
			_dither_threshold += 1.3;
			//col = vec3(.0, 1.0,.0);
			//COLOR.xyz = col;
		}
			
		if (dither_value < _dither_threshold){
			//col = dither_color.rgb;
			vec2 col_offset = vec2(_dither_offset_x, _dither_offset_y);
			/*if(mod(POINT_COORD, vec2(2.))== vec2(0)){
				col_offset = -col_offset;
			}*/
			col += texture(screen_texture, SCREEN_UV + SCREEN_PIXEL_SIZE*col_offset).xyz * _power;
			col -= vec3(_debug_fun);
		}
	}
	/*else{
		col = vec3(0);
	}*/
	
	vec2 screen_pos = FRAGCOORD.zw / FRAGCOORD.xy;
	vec2 dither_coordinate = screen_pos * (1.0/TEXTURE_PIXEL_SIZE) * vec2(1./8., 1./8.);
	dither_value = texture(dither_texture, dither_coordinate).r;
    COLOR.xyz = col;
}