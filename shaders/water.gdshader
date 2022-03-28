shader_type spatial;

uniform vec4 water_color: hint_color = vec4(0, 0.3, 0.9, 1);

uniform vec2 amplitude = vec2(0.1, 0.1);
uniform vec2 time_factor = vec2(0.1, 0.1);

float height(vec2 pos, float time) {
	return ( amplitude.x * sin(pos.x * time * time_factor.x) ) + ( amplitude.y * cos(pos.y * time * time_factor.y) );
}

void vertex() {
	VERTEX.y += height(VERTEX.xz, TIME);
	
	TANGENT = normalize(vec3(0, height(VERTEX.xz + vec2(0, 0.2), TIME) - height(VERTEX.xz - vec2(0, 0.2), TIME), 0.2));
	BINORMAL = normalize(vec3(0.2, height(VERTEX.xz + vec2(0.2, 0), TIME) - height(VERTEX.xz - vec2(0.2, 0), TIME), 0));;
	NORMAL = normalize(cross(TANGENT, BINORMAL));
}

void fragment() {
	ALBEDO = water_color.rgb;
	ALPHA = water_color.a;
}