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
	
	private function new() {}
}