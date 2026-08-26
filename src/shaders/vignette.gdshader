shader_type canvas_item;

uniform float intensity : hint_range(0.0, 5.0) = 1.0;
uniform float softness : hint_range(0.0, 1.0) = 0.4;
uniform vec4 vignette_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    // Get distance from center of the screen (0.5, 0.5)
    vec2 uv = UV - 0.5;
    float len = length(uv);
    
    // Smooth step to create the vignette gradient
    float vignette = smoothstep(0.5, 0.5 - softness, len * intensity);
    
    // Apply color and transparency
    COLOR = vignette_color;
    COLOR.a = 1.0 - vignette;
}
