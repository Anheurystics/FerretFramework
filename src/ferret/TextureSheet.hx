package ferret;

import ferret.fgl.Texture;
import openfl.geom.Rectangle;

class TextureSheet
{
	var mappings: Map<String, Rectangle>;
	public var names: Array<String>;
	public var texture: Texture;
	
	public function new(_texture: Texture) 
	{
		mappings = new Map();
		names = new Array();
		texture = _texture;
	}
	
	public function map(name: String, area: Rectangle)
	{
		mappings.set(name, area);
		names.push(name);
	}
	
	public function getMapping(name: String): Rectangle
	{
		return mappings.get(name);
	}
	
	public function getMappingUV(name: String): Rectangle
	{
		var mapping: Rectangle = mappings.get(name);
		var uv: Rectangle = new Rectangle();
		
		uv.x = mapping.x / texture.width;
		uv.y = mapping.y / texture.height;
		uv.width = mapping.width / texture.width;
		uv.height = mapping.height / texture.height;
		
		return uv;
	}
}