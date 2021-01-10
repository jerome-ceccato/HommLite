shader_type canvas_item;
render_mode unshaded;

uniform float outline_width : hint_range(0.0, 16) = 0.0;
uniform vec4 outline_color : hint_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float white_progress : hint_range(0, 1) = 0;

void fragment()
{
	bool is_smooth = true;
	int pixel_size = 4;
	vec4 pixel_color = texture(TEXTURE, UV);
	
	// Outline
	if (outline_width > 0.0) {
		vec2 unit = (1.0/float(pixel_size) ) / vec2(textureSize(TEXTURE, 0));
		if (pixel_color.a == 0.0) {
			pixel_color = outline_color;
			pixel_color.a = 0.0;
			for (float x = -ceil(outline_width); x <= ceil(outline_width); x++) {
				for (float y = -ceil(outline_width); y <= ceil(outline_width); y++) {
					if (texture(TEXTURE, UV + vec2(x*unit.x, y*unit.y)).a == 0.0 || (x==0.0 && y==0.0)) {
						continue;
					}
					if (is_smooth) {
						pixel_color.a += outline_color.a / (pow(x,2)+pow(y,2)) * (1.0-pow(2.0, -outline_width));
						if (pixel_color.a > 1.0) {
							pixel_color.a = 1.0;
						}
					} else {
						pixel_color.a = outline_color.a;
						return
					}
				}
			}
		}
	}
	
	// White flash
	if (white_progress > 0.0) {
		pixel_color.rgb = mix(pixel_color.rgb, vec3(1, 1, 1), white_progress)
	}
	
	COLOR = pixel_color;
}
