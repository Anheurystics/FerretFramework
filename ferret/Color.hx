package ferret;

import openfl.utils.Float32Array;

class Color
{
	public var r(get, set): Float;
	public function get_r(): Float { return floatArray[0]; }
	public function set_r(_r: Float): Float { return floatArray[0] = _r; }
	
	public var g(get, set): Float;
	public function get_g(): Float { return floatArray[1]; }
	public function set_g(_g: Float): Float { return floatArray[1] = _g; }
	
	public var b(get, set): Float;
	public function get_b(): Float { return floatArray[2]; }
	public function set_b(_b: Float): Float { return floatArray[2] = _b; }
	
	public var a(get, set): Float;
	public function get_a(): Float { return floatArray[3]; }
	public function set_a(_a: Float): Float { return floatArray[3] = _a; }	
	
	private var floatArray: Float32Array;
	
	private function new()
	{
		floatArray = new Float32Array(4);
	}
	
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
		var a: Int = rgba & 0xFF;
		var b: Int = (rgba >> 8) & 0xFF;
		var g: Int = (rgba >> 16) & 0xFF;
		var r: Int = (rgba >> 24) & 0xFF;
		
		return fromInt(r, g, b, a);
	}
	
	public static function fromHexInt24(rgb: Int): Color
	{
		var b: Int = rgb & 0xFF;
		var g: Int = (rgb >> 8) & 0xFF;
		var r: Int = (rgb >> 16) & 0xFF;
	
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
	
	public function toHex24(): Int
	{
		var ir: Int = Std.int(r * 255);
		var ig: Int = Std.int(g * 255);
		var ib: Int = Std.int(b * 255);

		return (ir << 16) | (ig << 8) | ib;
	}
	
	public function toHex32(): Int
	{
		var ir: Int = Std.int(r * 255);
		var ig: Int = Std.int(g * 255);
		var ib: Int = Std.int(b * 255);
		var ia: Int = Std.int(a * 255);
		
		return (ir << 24) | (ig << 16) | (ib << 8) | ia;
	}
	
	public function toRGBArray(): Float32Array
	{
		return floatArray.subarray(0, 3);
	}
	
	public function toRGBAArray(): Float32Array
	{
		return floatArray;
	}
}