varying vec3 Color;
varying vec3 FragPos;
varying vec3 Normal;
varying vec2 UV;

struct PointLight
{
	bool enabled;
	vec3 position;
	vec3 color;
	vec2 attenuationFactor;
	float intensity;
};
#define MAX_POINT_LIGHTS 16
uniform PointLight pointLights[MAX_POINT_LIGHTS];
uniform int numPointLights;

struct DirLight
{
	bool enabled;
	vec3 position;
	vec3 color;
	float intensity;
};
#define MAX_DIR_LIGHTS 16
uniform DirLight dirLights[MAX_DIR_LIGHTS];
uniform int numDirLights;

uniform vec3 ambient;
uniform sampler2D tex;

void main()
{
	vec3 totalLighting = ambient;
	
	vec3 diffuseLighting = vec3(0, 0, 0);
	for(int i = 0; i < MAX_POINT_LIGHTS; i++)
	{
		if(i == numPointLights) break;
		vec3 surfaceToLight = pointLights[i].position.xyz - FragPos;
		float dist = length(surfaceToLight);
		float attenuation = 1.0 / ((0.1 * dist * pointLights[i].attenuationFactor.x) + (0.01 * dist * dist * pointLights[i].attenuationFactor.y));
		if(attenuation < 0.001)
		{
			attenuation = 0.0;
		}
		
		float brightness = max(dot(Normal, surfaceToLight) * pointLights[i].intensity * attenuation, 0.0);
		
		diffuseLighting += pointLights[i].color * brightness;
	}
	
	for(int i = 0; i < MAX_DIR_LIGHTS; i++)
	{
		if(i == numDirLights) break;
		vec3 diff = dirLights[i].position.xyz;
		float brightness = max(dot(Normal, normalize(diff)) * dirLights[i].intensity, 0.0);
		
		diffuseLighting += dirLights[i].color * brightness;		
	}
	
	vec4 texColor = texture(tex, UV * uvScale + uvOffset).bgra;
	if(texColor.a == 0.0)
	{
		discard;
	}
	
	gl_FragColor = vec4(texColor.rgb * vec3((diffuseLighting + totalLighting * Color)), texColor.a).rgba;
}