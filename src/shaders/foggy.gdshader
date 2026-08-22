shader_type spatial;
render_mode blend_mix, cull_back, unshaded, depth_draw_never, shadows_disabled;

// ---- Tweak these in the Inspector ----
uniform vec4 fog_color : source_color = vec4(0.85, 0.88, 0.92, 1.0);
uniform float density : hint_range(0.0, 1.0) = 0.45;      // base thickness
uniform float noise_scale : hint_range(0.5, 20.0) = 3.0;  // size of the wisps
uniform float scroll_speed : hint_range(0.0, 1.0) = 0.06; // drift speed
uniform float brightness : hint_range(0.0, 3.0) = 0.3;    // self-emission

// --- blur / softness controls ---
uniform float edge_softness : hint_range(0.05, 3.0) = 1.2;   // width of the fresnel fade (bigger = blurrier silhouette)
uniform float edge_bias : hint_range(0.0, 1.0) = 0.15;       // where the fade starts (lower = fog reaches further toward face center)
uniform float depth_fade_distance : hint_range(0.01, 10.0) = 2.0; // how far into intersecting geometry the fade extends (bigger = blurrier where it meets other objects)

uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;

varying vec3 world_normal;
varying vec3 world_pos;

// --- cheap value noise, no texture needed ---
float hash(vec2 p) {
	p = fract(p * vec2(123.34, 456.21));
	p += dot(p, p + 45.32);
	return fract(p.x * p.y);
}

float value_noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	float a = hash(i);
	float b = hash(i + vec2(1.0, 0.0));
	float c = hash(i + vec2(0.0, 1.0));
	float d = hash(i + vec2(1.0, 1.0));
	vec2 u = f * f * (3.0 - 2.0 * f);
	return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 p) {
	float sum = 0.0;
	float amp = 0.5;
	for (int i = 0; i < 4; i++) {
		sum += amp * value_noise(p);
		p *= 2.02;
		amp *= 0.5;
	}
	return sum;
}

void vertex() {
	world_normal = normalize((MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz);
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	vec3 view_dir = normalize(CAMERA_POSITION_WORLD - world_pos);

	// Fresnel, but smoothstepped instead of pow()'d -> a wide, soft gradient instead of a sharp rim
	float facing = clamp(dot(world_normal, view_dir), 0.0, 1.0);
	float fresnel = 1.0 - smoothstep(edge_bias, edge_bias + edge_softness, facing);

	// Two drifting noise layers sampled from world position so it works on any face
	vec2 uv1 = world_pos.xz * (1.0 / noise_scale) + vec2(TIME * scroll_speed, TIME * scroll_speed * 0.6);
	vec2 uv2 = world_pos.xy * (1.0 / noise_scale) * 1.6 - vec2(TIME * scroll_speed * 0.5, TIME * scroll_speed * 0.3);

	float n = mix(fbm(uv1), fbm(uv2), 0.5);

	float alpha = density * (0.35 + 0.65 * n) + fresnel * 0.55;
	alpha = clamp(alpha, 0.0, 1.0);

	// Soft-particle fade: where the box's surface intersects other solid geometry
	// (floor, walls, characters walking through it) the seam is blurred out
	// instead of cutting off in a hard line.
	float scene_depth_raw = texture(DEPTH_TEXTURE, SCREEN_UV).x;
	vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, scene_depth_raw);
	vec4 view_pos = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	view_pos.xyz /= view_pos.w;
	float scene_depth = -view_pos.z;
	float pixel_depth = -VERTEX.z;
	float soft_fade = clamp((scene_depth - pixel_depth) / depth_fade_distance, 0.0, 1.0);
	alpha *= soft_fade;

	ALBEDO = fog_color.rgb;
	ALPHA = alpha;
	EMISSION = fog_color.rgb * brightness * n;
}