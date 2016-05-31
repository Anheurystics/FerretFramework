attribute vec3 position;
attribute vec3 normal;
attribute vec3 color;

uniform mat4 model;
uniform mat4 normalModel;
uniform mat4 view;
uniform mat4 proj;

varying vec3 Color;
varying vec3 FragPos;
varying vec3 Normal;

void main() {
	gl_Position = proj * view * model * vec4(position, 1.0);
	
	Color = color;
	Normal = normalize(mat3(normalModel) * normal);
	FragPos = vec3(model * vec4(position, 1.0));
}