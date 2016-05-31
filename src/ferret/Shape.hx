package ferret;
import ferret.Color;
import ferret.fgl.Mesh;
import ferret.fgl.MeshData;
import openfl.gl.GL;

class Shape
{
	public static function polygon(sides: Int, color: Color): Mesh
	{
		var arr: Array<Float> = [0.0, 0.0, color.r, color.g, color.b];
		var interval: Float = Math.PI * 2 / sides;
		for (i in 0...sides+1)
		{
			arr.push(Math.cos(i * interval));
			arr.push(Math.sin(i * interval));
			arr.push(color.r); arr.push(color.g); arr.push(color.b);
		}
		
		var mesh = new Mesh(new MeshData(
			arr, ["position", "color"], [2, 3]
		), []);
		
		mesh.drawMode = GL.TRIANGLE_FAN;
		
		return mesh;		
	}
	
	public static function circle(color: Color): Mesh
	{
		return polygon(180, color);
	}
}