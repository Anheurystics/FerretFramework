attribute vec2 position;
attribute vec2 uv;
attribute vec4 color;

uniform mat4 model;
uniform mat4 view;
uniform mat4 proj;

varying vec2 UV;
varying vec4 Color;

void main()
{
	gl_Position = proj * view * model * vec4(position, 0.0, 1.0);
	
	UV = uv;
	Color = color;
}