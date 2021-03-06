package ferret.gl;

import openfl.Assets;
import openfl.display.BitmapData;
import openfl.gl.GL;
import openfl.gl.GLTexture;

class Texture
{
	public var unit: GLTexture = GL.createTexture();
	
	public var width: Int;
	public var height: Int;

	public function new(source: Dynamic, filter: Int = GL.NEAREST)
	{
		var bitmapData: BitmapData = null;
		if(Std.is(source, BitmapData))
			bitmapData = cast(source, BitmapData);
		if (Std.is(source, String))
			bitmapData = Assets.getBitmapData(cast(source, String));
			
		width = bitmapData.width;
		height = bitmapData.height;
		
		var wrap: Int = GL.REPEAT;
		#if html5
		if (!isPowerOfTwo(bitmapData.width) || !isPowerOfTwo(bitmapData.height))
		{
			wrap = GL.CLAMP_TO_EDGE;
		}
		#end
		
		var pixels = bitmapData.image.data;
		GL.bindTexture(GL.TEXTURE_2D, unit);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, wrap);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, wrap);
		GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, bitmapData.width, bitmapData.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, pixels);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, filter);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, filter);
		GL.bindTexture (GL.TEXTURE_2D, null);
	}
	
	function isPowerOfTwo(n: Int): Bool
	{
		while (n & 1 == 0 && n != 1)
		{
			n = n >> 1;
		}
		return n == 1;
	}
}