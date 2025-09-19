shader_type canvas_item;

uniform vec2 position;
uniform float radius;
uniform float borderWidth = 0.02;
uniform float burnMult = 0.135;
uniform sampler2D noiseTexture;
uniform vec4 burnColor : source_color;
uniform vec3 outline_color: source_color;
uniform float progress: hint_range(0.0, 1.0);
uniform float width: hint_range(0.0, 0.1, 0.001) = 0.001;

void fragment() {
	vec4 line_neg_y = vec4(outline_color.rgb, texture(TEXTURE, vec2(UV.x, UV.y - width)).a);
	vec4 line_pos_y = vec4(outline_color.rgb, texture(TEXTURE, vec2(UV.x, UV.y + width)).a);
	vec4 line_neg_x = vec4(outline_color.rgb, texture(TEXTURE, vec2(UV.x - width, UV.y)).a);
	vec4 line_pos_x = vec4(outline_color.rgb, texture(TEXTURE, vec2(UV.x + width, UV.y)).a);
	vec4 outline_y = mix(line_neg_y, line_pos_y, line_pos_y);
	vec4 outline_x = mix(line_neg_x, line_pos_x, line_pos_x);
	vec4 outline = mix(outline_y, outline_x, outline_x);
	float dist = length(position - UV) + (texture(noiseTexture, UV).b) * burnMult;
	COLOR.rgb = mix(COLOR.rgb, burnColor.rgb, float(dist<radius+borderWidth));
	COLOR.a *= 1.0-(float(dist<radius));
	COLOR = mix(COLOR, outline, progress * (1.0 - COLOR.a));
}