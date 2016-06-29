varying vec2 UV;
varying vec4 Color;

uniform sampler2D tex;

void main()
{
	gl_FragColor = Color * texture(tex, UV).rgba;
}