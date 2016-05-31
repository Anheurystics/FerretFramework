attribute vec3 position;
attribute vec2 uv;
attribute vec3 color;

uniform mat4 view;
uniform mat4 proj;

varying vec2 UV;
varying vec3 Color;

void main()
{
	gl_Position = proj * view * vec4(position, 1.0);
	
	UV = uv;
	Color = color;
}