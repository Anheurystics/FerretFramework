package ferret;
import ferret.gl.Mesh;
import ferret.gl.MeshData;

typedef Shape = 
{
	
}

class ShapeBatch
{
	private var mesh: Mesh;
	private var meshData: MeshData;
	
	public function new() 
	{
		mesh = new Mesh(meshData = new MeshData([], ["position", "color"], [2, 3]), []);
	}
}