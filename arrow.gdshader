shader_type canvas_item;

uniform float outline_thickness : hint_range(0.0, 1.0) = 0.2;
uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);


void fragment() {
	vec2 uv = vec2(UV.x, 1.0 - UV.y);
	
	vec4 _color = vec4(0);
	if (abs(uv.x - 0.5)/0.5 + uv.y < 1.0)
	{
		_color = color;
		if(abs(uv.x - 0.5)/0.5 > 1.0 - uv.y - outline_thickness )
			_color = outline_color;
	}
	COLOR = _color;
}