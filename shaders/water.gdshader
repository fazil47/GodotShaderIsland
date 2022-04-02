shader_type spatial;

uniform vec4 water_color: hint_color = vec4(0.2, 0.6, 0.95, 1);
uniform vec2 amplitude = vec2(0.015, 0.015);
uniform vec2 time_factor = vec2(0.12, 0.12);

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453);
}

float height(vec2 pos, float time) {
	return  (  amplitude.x * sin(pos.x * time * time_factor.x) ) + ( amplitude.y * cos(pos.y * time * time_factor.y) );
}

void vertex() {
	VERTEX.y += height(VERTEX.xz, TIME);

	TANGENT = normalize(vec3(0, height(VERTEX.xz + vec2(0, 0.4), TIME) - height(VERTEX.xz - vec2(0, 0.4), TIME), 0.4));
	BINORMAL = normalize(vec3(0.4, height(VERTEX.xz + vec2(0.4, 0), TIME) - height(VERTEX.xz - vec2(0.4, 0), TIME), 0));;
	NORMAL = normalize(cross(TANGENT, BINORMAL));
}

void fragment() {
	ALBEDO = water_color.rgb;
	METALLIC = 0.0;
	ROUGHNESS = 0.4;
	float depth = texture(DEPTH_TEXTURE, SCREEN_UV).r;
	depth = depth * 50.0 - 49.0;
	ALBEDO *= vec3(1, 1, 1) * depth;
}