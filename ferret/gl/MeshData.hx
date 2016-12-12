package ferret.gl;

import openfl.geom.Vector3D;

typedef DataLayout = 
{
	var name: String;
	var offset: Int;
	var size: Int;
}

class MeshData
{
	public var vertexCount(get, null): Int;
	function get_vertexCount(): Int
	{
		return Std.int(array.length / maxSize);
	}
	
	public var array: Array<Float>;
	public var layouts: Map<String, DataLayout>;
	public var names: Array<String>;
	public var markers: Map<String, Int>;
	
	var maxSize: Int = 0;
	
	public var min: Vector3D;
	public var max: Vector3D;
	
	public var dirty: Array<Int> = [];
	
	public function new(_data: Array<Float>, _names: Array<String>, sizes: Array<Int>) 
	{
		array = _data;
		names = _names;
		layouts = new Map();
		
		for (i in 0...names.length)
		{
			var layout: DataLayout = {
				name: names[i],
				size: sizes[i],
				offset: maxSize,
			};
			
			layouts[names[i]] = layout;
			
			maxSize += sizes[i];
		}
	}
	
	public function setData(name: String, vertexNum: Int, offset: Int, value: Float): Void
	{
		array[layouts[name].offset + (maxSize * vertexNum) + offset] = value;
		dirty.push(layouts[name].offset + (maxSize * vertexNum) + offset); dirty.push(1);
	}
	
	public function setDataAsArray(name: String, vertexNum: Int, arr: Array<Float>): Void
	{
		for (i in 0...layouts[name].size)
		{
			array[layouts[name].offset + (maxSize * vertexNum) + i] = arr[i];
		}
		dirty.push(layouts[name].offset + (maxSize * vertexNum)); dirty.push(layouts[name].size);
	}	
	
	public function getData(name: String, vertexNum: Int, offset: Int = 0): Float
	{
		return array[layouts[name].offset + (maxSize * vertexNum) + offset];
	}
	
	public function getDataAsArray(name: String, vertexNum: Int): Array<Float>
	{
		var arr: Array<Float> = [];
		for (i in 0...layouts[name].size)
		{
			arr[i] = array[layouts[name].offset + (maxSize * vertexNum) + i];
		}
		return arr;
	}
}