extern float _r;
extern float _g;
extern float _b;

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{
	return vec4(_r, _g, _b, 1);
}