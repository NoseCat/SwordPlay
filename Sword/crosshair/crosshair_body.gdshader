shader_type canvas_item;

uniform float radius = 0.5;

uniform float outline_thickness : hint_range(0.0, 0.5) = 0.05;

// Colors
uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    // Center the UV so (0,0) is the middle
    vec2 uv = UV - vec2(0.5);

    float dist = length(uv);
    float inner_radius = radius - outline_thickness;

    // Anti‑aliasing width based on pixel size
    float aa = fwidth(dist) * 1.5;

    // Mask for the filled area
    float fill_mask = 1.0 - smoothstep(inner_radius - aa, inner_radius + aa, dist);

    // Mask for the outline ring
    float outline_mask = smoothstep(inner_radius - aa, inner_radius + aa, dist) *
                         (1.0 - smoothstep(radius - aa, radius + aa, dist));

    // Combine colors (straight alpha blending)
    vec3 rgb = color.rgb * fill_mask + outline_color.rgb * outline_mask;
    float alpha = color.a * fill_mask + outline_color.a * outline_mask;

    COLOR = vec4(rgb, alpha);
}