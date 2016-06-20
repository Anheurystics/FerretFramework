package ferret.gl;

import ferret.gl.MeshData.DataLayout;
import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.utils.Float32Array;
import openfl.utils.Int16Array;

class Mesh
{	
	public var attribNames: Array<String> = [];
	public var attribSizes: Array<Int> = [];
	
	public var vertexBuffer: GLBuffer = GL.createBuffer();
	public var indexBuffer: GLBuffer = GL.createBuffer();
	
	public var nVertices: Int;
	public var nIndices: Int;
	
	public var totalAttribSize: Int = 0;

	public var data: MeshData;
	public var indices: Array<Int>;
	
	public var drawMode: Int = GL.TRIANGLES;
	
	public static function interleave(array: Array<Array<Float>>, sizes: Array<Int>): Array<Float>
	{
		var n: Int = Std.int(array[0].length / sizes[0]);
		var ret: Array<Float> = [];
		for (i in 0...n)
		{
			for (j in 0...array.length)
			{
				var i1: Int = Std.int(i * sizes[j]);
				var sz: Int = sizes[j];
				for (z in i1...(i1 + sz))
				{
					ret.push(array[j][z]);
				}				
			}
		}
		return ret;
	}
		
	public function new(meshData: MeshData, _indices: Array<Int>) 
	{		
		data = meshData;
		indices = _indices;
		
		updateBuffer();
		
		for (name in meshData.names)
		{
			var layout: DataLayout = meshData.layouts[name];
			
			attribNames.push(layout.name);
			attribSizes.push(layout.size);
		}
		
		for (size in attribSizes)
		{
			totalAttribSize += size;
		}
		
		nVertices = Std.int(meshData.array.length / totalAttribSize);
	}
	
	public function updateBuffer(): Void
	{
		nIndices = indices.length;
		
		GL.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
		GL.bufferData(GL.ARRAY_BUFFER, new Float32Array(data.array), GL.STATIC_DRAW);
		GL.bindBuffer(GL.ARRAY_BUFFER, null);
		
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer);
		GL.bufferData(GL.ELEMENT_ARRAY_BUFFER, new Int16Array(indices), GL.STATIC_DRAW);
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);		
	}
}