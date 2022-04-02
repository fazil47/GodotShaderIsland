shader_type spatial;
render_mode blend_mix;

void vertex() {

}

void fragment() {
	ALBEDO = COLOR.rgb;
	EMISSION = COLOR.rgb;
	ALPHA = COLOR.a;
}