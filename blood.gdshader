shader_type spatial;
render_mode unshaded, cull_disabled, blend_mix;

uniform vec4 color : source_color = vec4(0.12, 0.58, 0.95, 1.0);
uniform float time = 0.0;

// xy = UV position (0..1), z = growth speed
uniform vec3 points[64];
uniform int point_count = 0;

void fragment() {
	ALBEDO = color.rgb;
	float final_alpha = color.a;

	for (int i = 0; i < point_count; i++) {
		vec2 p = points[i].xy;
		float r = time * points[i].z;
		float d = distance(UV, p);

		// Hard-edged hole (alpha = 0)
		if (d < r) {
			final_alpha = 0.0;
			break;
		}

		/* Soft-edged version (uncomment to use instead):
		float edge = 0.008;
		float hole = 1.0 - smoothstep(r - edge, r, d);
		final_alpha *= (1.0 - hole);
		*/
	}

	ALPHA = final_alpha;
}

uniform vec3 topRight = vec3(1, 0, 1);
uniform vec3 topLeft = vec3(1, 0, -1);
uniform vec3 bottomRight = vec3(-1, 0, 1);
uniform vec3 bottomLeft = vec3(-1, 0, -1);

void vertex() {
    vec2 uv = UV;
    
    if (uv.x < 0.5 && uv.y < 0.5) {
        VERTEX = topRight;
    } else if (uv.x >= 0.5 && uv.y < 0.5) {
        VERTEX = topLeft;
    } else if (uv.x < 0.5 && uv.y >= 0.5) {
        VERTEX = bottomRight;
    } else {
        VERTEX = bottomLeft;
    }
}