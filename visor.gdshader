shader_type canvas_item;

uniform sampler2D pantalla : hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform float desenfoque : hint_range(0.0, 5.0) = 2.5;
uniform vec4 tinte : source_color = vec4(0.10, 0.13, 0.21, 1.0);
uniform float oscuridad : hint_range(0.0, 1.0) = 0.35;

void fragment() {
	vec4 c = textureLod(pantalla, SCREEN_UV, desenfoque);
	COLOR = vec4(mix(c.rgb, tinte.rgb, oscuridad), 1.0);
}