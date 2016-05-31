varying vec2 UV;
varying vec3 Color;

uniform sampler2D tex;
uniform vec2 tile;
uniform vec2 offset;

void main()
{
	gl_FragColor = texture(tex, offset + UV * tile).bgra;
}