shader_type spatial;

uniform vec4 water_color: hint_color = vec4(0.2, 0.6, 0.95, 1);
uniform vec2 amplitude = vec2(0.01, 0.01);
uniform vec2 time_factor = vec2(0.1, 0.1);

float rand(vec2 co) {
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float height(vec2 pos, float time) {
	return sin((rand(pos) * 2.0) - 1.0) * (  amplitude.x * sin(pos.x * time * time_factor.x) ) + ( amplitude.y * cos(pos.y * time * time_factor.y) );
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
	METALLIC = 0.0;
	ROUGHNESS = 0.1;
}