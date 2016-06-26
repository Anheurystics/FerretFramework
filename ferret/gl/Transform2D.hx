package ferret.gl;

import ferret.gl.Mat3;
import openfl.geom.Vector3D;

class Transform2D
{
	public var matrix: Mat3 = new Mat3();
	
	public var position(default, null): Vector3D = new Vector3D();
	public var rotation(default, null): Float = 0;
	public var scale(default, null): Vector3D = new Vector3D(1, 1, 1, 1);
	
	public var parent: Transform2D;
	private var _dirty: Bool = true;

	public function new() {}
	
	public function reset(): Transform2D
	{
		matrix.identity();
		
		return this;
	}
	
	public function moveBy(x: Float, y: Float): Transform2D
	{
		position.x += x;
		position.y += y;
		
		_dirty = true;
		
		return this;
	}
	
	public function moveTo(x: Float, y: Float): Transform2D
	{
		position.x = x;
		position.y = y;
		
		_dirty = true;
		
		return this;
	}	
	
	public function rotateBy(degrees: Float): Transform2D
	{
		rotation += degrees;
		
		_dirty = true;
		
		return this;
	}	
	
	public function rotateTo(degrees: Float): Transform2D
	{
		rotation = degrees;
		
		_dirty = true;
		
		return this;
	}
	
	public function scaleBy(x: Float, y: Float): Transform2D
	{
		scale.x *= x;
		scale.y *= y;
		
		_dirty = true;
		
		return this;
	}
	
	public function scaleTo(x: Float, y: Float): Transform2D
	{
		scale.x = x;
		scale.y = y;
		
		_dirty = true;
		
		return this;
	}
	
	public function getMatrix(): Mat3
	{
		var m: Mat3;
		if (_dirty)
		{
			m = matrix.identity().scale(scale.x, scale.y)
			.rotate(rotation)
			.translate(position.x, position.y);
			
			_dirty = false;
		}
		else
		{
			m = matrix.clone();
		}
		
		if (parent != null)
		{
			m.multiply(parent.getMatrix());
		}
		
		return m;
	}
}