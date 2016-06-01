package ferret;

class Color
{
	public var r: Float;
	public var g: Float;
	public var b: Float;
	public var a: Float;
	
	public static function fromFloat(r: Float, g: Float, b: Float, a: Float = 1.0): Color
	{
		var c = new Color();
		c.r = r; c.g = g; c.b = b; c.a = a;
		return c;
	}
	
	public static function fromInt(r: Int, g: Int, b: Int, a: Int = 255): Color
	{
		return fromFloat(r / 255.0, g / 255.0, b / 255.0, a / 255.0);
	}
	
	public static function fromHexInt32(rgba: Int): Color
	{
		var a: Int = a & 0xFF;
		var b: Int = (a >> 8) & 0xFF;
		var g: Int = (a >> 16) & 0xFF;
		var r: Int = (a >> 24) & 0xFF;
		
		return fromInt(r, g, b, a);
	}
	
	public static function fromHexInt24(rgb: Int): Color
	{
		var b: Int = a & 0xFF;
		var g: Int = (a >> 8) & 0xFF;
		var r: Int = (a >> 16) & 0xFF;
		
		return fromInt(r, g, b, 255);
	}
	
	public static function fromHexString(hexString: String): Color
	{
		if (hexString.indexOf("0x") != 0)
			return null;
		if (hexString.length == 8)
			return fromHexInt24(Std.parseInt(hexString));
		if (hexString.length == 10)
			return fromHexInt32(Std.parseInt(hexString));
		
		return null;
	}
	
	private function new() {}
}