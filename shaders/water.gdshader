shader_type spatial;

uniform vec4 water_color: hint_color = vec4(0.2, 0.6, 0.95, 1);
uniform vec2 amplitude = vec2(0.015, 0.015);
uniform vec2 time_factor = vec2(0.12, 0.12);

float hash(vec2 p) {
  return fract(sin(dot(p * 17.17, vec2(14.91, 67.31))) * 4791.9511);
}

float noise(vec2 x) {
  vec2 p = floor(x);
  vec2 f = fract(x);
  f = f * f * (3.0 - 2.0 * f);
  vec2 a = vec2(1.0, 0.0);
  return mix(mix(hash(p + a.yy), hash(p + a.xy), f.x),
         mix(hash(p + a.yx), hash(p + a.xx), f.x), f.y);
}

float fbm(vec2 x) {
  float height = 0.0;
  float noise_amplitude = 0.5;
  float noise_frequency = 3.0;
  for (int i = 0; i < 6; i++){
    height += noise(x * noise_frequency) * noise_amplitude;
    noise_amplitude *= 0.5;
    noise_frequency *= 2.0;
  }
  return height;
}

float height(vec2 pos, float time) {
	return fbm(pos * sin(time * time_factor / 10.0)) * (  amplitude.x * sin(pos.x * time * time_factor.x) ) + ( amplitude.y * cos(pos.y * time * time_factor.y) );
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