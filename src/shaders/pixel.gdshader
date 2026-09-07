shader_type spatial;
render_mode cull_back, unshaded;

uniform sampler2D albedo_texture : source_color, filter_nearest;
uniform float pixel_size : hint_range(1.0, 64.0) = 8.0;

void fragment() {
    vec2 uv = UV;
    vec2 pixelated_uv = floor(uv * pixel_size) / pixel_size;
    ALBEDO = texture(albedo_texture, pixelated_uv).rgb;
}