package ferret.gl;

import ferret.gl.Texture;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.gl.GL;
import openfl.text.TextField;
import openfl.text.TextFormat;

class TextureManager
{	
	static var textures: Map<String, Texture> = new Map();
	static var areas: Map<String, Map<String, Rectangle>> = new Map();
	
	public static function load(name: String, source: Dynamic, filter: Int = GL.NEAREST)
	{
		textures.set(name, new Texture(source, filter));
	}
	
	public static function setTextureArea(textureName: String, areaName: String, area: Rectangle)
	{
		if (areas.get(textureName) == null)
		{
			areas.set(textureName, new Map<String, Rectangle>());
		}
		
		areas.get(textureName).set(areaName, area);
	}
	
	public static function get(name: String): Texture
	{
		return textures.get(name);
	}
	
	public static function fromText(text: String, format: TextFormat, name: String, smooth: Bool = true): Texture
	{
		var field: TextField = new TextField();
		
		field.text = text;
		field.defaultTextFormat = format;
		field.embedFonts = true;
		field.width = field.textWidth * 1.1;
		field.height = field.textHeight * 1.1;
		
		var data: BitmapData = new BitmapData(Math.ceil(field.width), Math.ceil(field.height), true, 0);
		data.draw(field, null, null, null, null, smooth);
		
		TextureManager.load(name, data, GL.LINEAR);
		
		return TextureManager.get(name);
	}
}