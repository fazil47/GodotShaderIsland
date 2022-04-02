shader_type spatial;
render_mode blend_add;

void vertex() {

}

void fragment() {
	ALBEDO = COLOR.rgb;
	EMISSION = COLOR.rgb;
	ALPHA = COLOR.a;
}