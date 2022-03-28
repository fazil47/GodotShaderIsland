shader_type spatial;
render_mode unshaded;

void vertex() {
}

void fragment() {
	ALBEDO = vec3(0, 0.5, 1);
	ALPHA = 0.5;
}