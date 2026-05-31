shader_type canvas_item;

uniform float threshold : hint_range(0.0, 1.0) = 0.9;

void fragment() {
	vec4 c = texture(TEXTURE, UV);
	if (c.r > threshold && c.g > threshold && c.b > threshold) {
		c.a = 0.0;
	}
	COLOR = c;
}
