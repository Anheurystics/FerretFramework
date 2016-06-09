package ferret.gl;

import ferret.gl.Mesh;
import ferret.gl.MeshData;
import openfl.Assets;
import openfl.geom.Vector3D;

typedef Material = 
{
	@:optional var Kd: Vector3D;
	@:optional var map_Kd: String;
}

class OBJLoader
{	
	public static function load(filename: String): MeshData
	{
		var path: String = filename.substring(0, filename.lastIndexOf("/") + 1);
		
		var lines: Array<String> = Assets.getText(filename).split("\n");
		var tempPos: Array<Vector3D> = [];
		var tempUV: Array<Vector3D> = [];
		var tempNorm: Array<Vector3D> = [];
		
		var positions: Array<Vector3D> = [];
		var uvs: Array<Vector3D> = [];
		var normals: Array<Vector3D> = [];
		var colors: Array<Vector3D> = [];
		
		var white: Vector3D = new Vector3D(1, 1, 1);
		
		var indices: Array<Int> = [];
		
		var materials: Map<String, Material> = new Map();
		var currentMaterial: String = "";
		
		var min: Vector3D = new Vector3D(Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY);
		var max: Vector3D = new Vector3D(Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY);
		
		for (line in lines)
		{
			var split: Array<String> = line.split(" ");
			if (split[0] == "mtllib" && Assets.exists(path + split[1]))
			{
				var mtlLines: Array<String> = Assets.getText(path + split[1]).split("\n");
				var currentMaterial: String = "";
				for (mtlLine in mtlLines)
				{
					var mtlSplit: Array<String> = mtlLine.split(" ");
					if (mtlSplit[0] == "newmtl")
					{
						currentMaterial = mtlSplit[1];
						materials[currentMaterial] = {};
					}
					else
					if (mtlSplit[0] == "Kd")
					{
						materials[currentMaterial].Kd = new Vector3D(
							Std.parseFloat(mtlSplit[1]), Std.parseFloat(mtlSplit[2]), Std.parseFloat(mtlSplit[3])
						);
					}
					else
					if (mtlSplit[0] == "map_Kd")
					{
						materials[currentMaterial].map_Kd = mtlSplit[1];
					}
				}
			}
			else
			if (split[0] == "usemtl")
			{
				currentMaterial = split[1];
			}
			if(split[0] == "v")
			{
				var x: Float = Std.parseFloat(split[1]);
				var y: Float = Std.parseFloat(split[2]);
				var z: Float = Std.parseFloat(split[3]);
				
				if (x < min.x) min.x = x;
				if (y < min.y) min.y = y;
				if (z < min.z) min.z = z;
				
				if (x > max.x) max.x = x;
				if (y > max.y) max.y = y;
				if (z > max.z) max.z = z;
				
				tempPos.push(new Vector3D(x, y, z));
			}
			else
			if(split[0] == "vn")
			{
				tempNorm.push(new Vector3D(Std.parseFloat(split[1]), Std.parseFloat(split[2]), Std.parseFloat(split[3])));
			}
			else
			if (split[0] == "vt")
			{
				tempUV.push(new Vector3D(Std.parseFloat(split[1]), Std.parseFloat(split[2])));
			}
			else
			if(split[0] == "f")
			{
				for(i in 1...4)
				{
					var sl: Array<String> = split[i].split("/");
					if (tempPos.length > 0) positions.push( tempPos[Std.parseInt(sl[0]) - 1] );
					if (tempUV.length > 0) uvs.push( tempUV[Std.parseInt(sl[1]) - 1] );
					if (tempNorm.length > 0) normals.push( tempNorm[Std.parseInt(sl[2]) - 1] );
					colors.push( (materials[currentMaterial] != null)? materials[currentMaterial].Kd : white );
				}
			}
		}
		
		var interleave: Array<Array<Float>> = [];
		var names: Array<String> = [];
		var sizes: Array<Int> = [];
		
		if (positions.length > 0)
		{
			interleave.push(vToF(positions, 3));
			names.push("position");
			sizes.push(3);
		}
	
		if (uvs.length > 0)
		{
			interleave.push(vToF(uvs, 2));
			names.push("uv");
			sizes.push(2);
		}		
		
		if (normals.length > 0)
		{
			interleave.push(vToF(normals, 3));
			names.push("normal");
			sizes.push(3);
		}
		
		if (colors.length > 0)
		{
			interleave.push(vToF(colors, 3));
			names.push("color");
			sizes.push(3);
		}
		
		var meshData: MeshData = new MeshData(Mesh.interleave(interleave, sizes), names, sizes);
		meshData.min = min;
		meshData.max = max;
		
		return meshData;
	}
	
	static function vToF(vec3DArray: Array<Vector3D>, n: Int): Array<Float>
	{
		var floatArray: Array<Float> = [];
		for(vec in vec3DArray)
		{
			if(n > 0) floatArray.push(vec.x);
			if(n > 1) floatArray.push(vec.y);
			if(n > 2) floatArray.push(vec.z);
			if(n > 3) floatArray.push(vec.w);
		}
		return floatArray;
	}
}