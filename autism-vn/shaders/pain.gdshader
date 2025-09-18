shader_type canvas_item;

uniform float speed = 5.0;
uniform float _frequency = 30.0;
uniform bool is_breath = false;
uniform float breath_speed = 0.368;
uniform float breath_freq = 0.021;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float frequency = _frequency;
	if (is_breath){
		frequency = breath_freq * tan(TIME*breath_speed);
	}
	
	
    vec2 base_uv = UV;
    vec4 albedo_tex = texture(TEXTURE,base_uv);
    albedo_tex *= COLOR;
    //ALBEDO = albedo.rgb * albedo_tex.rgb;
    float oh_no = cos(TIME*speed)+ sin(TIME*speed);
    float oh_god = sin(TIME*speed)+ cos(TIME*speed);
    float oh_feck = sin(TIME*speed)+ cos(TIME*speed);
    
    COLOR.rgb = vec3(sin(oh_no*frequency * TIME*speed),cos(oh_god*frequency * TIME*speed),tan(oh_feck*frequency * TIME*speed) );
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
