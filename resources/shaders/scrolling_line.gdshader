shader_type canvas_item;

void fragment() {
	vec2 updated_uv = vec2(UV.x - TIME, UV.y);
	vec4 in_tex = texture(TEXTURE, updated_uv);
	COLOR = in_tex;
}
