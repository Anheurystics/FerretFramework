varying vec2 UV;
varying vec3 Color;

uniform sampler2D tex;

void main()
{
	gl_FragColor = texture(tex, UV).bgra;
}