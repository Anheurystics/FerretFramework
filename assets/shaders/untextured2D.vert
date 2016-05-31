attribute vec2 position;
attribute vec3 color;

uniform mat4 model;
uniform mat4 view;
uniform mat4 proj;

varying vec3 Color;

void main()
{
	gl_Position = proj * view * model * vec4(position, 0.0, 1.0);
	
	Color = color;
}