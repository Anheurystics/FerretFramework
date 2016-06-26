package ferret;

import ferret.gl.Mat4;
import ferret.gl.Utils;
import openfl.geom.Vector3D;

class Transform3D
{
	public var matrix: Mat4 = new Mat4();
	
	public var position(default, null): Vector3D = new Vector3D();
	public var rotation(default, null): Vector3D = new Vector3D();
	public var scale(default, null): Vector3D = new Vector3D(1, 1, 1, 1);
	
	public var parent: Transform3D;
	private var _dirty: Bool = true;

	public function new() {}
	
	public function reset(): Transform3D
	{
		matrix.identity();
		
		return this;
	}	
	
	public function moveBy(x: Float, y: Float, z: Float): Transform3D
	{
		position.x += x;
		position.y += y;
		position.z += z;
		
		_dirty = true;
		
		return this;
	}
	
	public function moveTo(x: Float, y: Float, z: Float): Transform3D
	{
		position.x = x;
		position.y = y;
		position.z = z;
		
		_dirty = true;
		
		return this;
	}	
	
	public function rotateBy(x: Float, y: Float, z: Float): Transform3D
	{
		rotation.x += x;
		rotation.y += y;
		rotation.z += z;
		
		_dirty = true;
		
		return this;
	}	
	
	public function rotateTo(x: Float, y: Float, z: Float): Transform3D
	{
		rotation.x = x;
		rotation.y = y;
		rotation.z = z;
		
		_dirty = true;
		
		return this;
	}
	
	public function scaleBy(x: Float, y: Float, z: Float): Transform3D
	{
		scale.x *= x;
		scale.y *= y;
		scale.z *= z;
		
		_dirty = true;
		
		return this;
	}
	
	public function scaleTo(x: Float, y: Float, z: Float): Transform3D
	{
		scale.x = x;
		scale.y = y;
		scale.z = z;
		
		_dirty = true;
		
		return this;
	}
	
	public function lookAt(target: Vector3D): Transform3D
	{
		var diff: Vector3D = target.subtract(position);
		var yaw: Float = Math.atan2(diff.x, diff.z);
		var pitch: Float = Math.atan2(diff.y * -1, diff.length);
		
		rotateTo(Utils.toDeg(pitch), Utils.toDeg(yaw), 0);
		
		_dirty = true;
		
		return this;
	}
	
	public function getMatrix(): Mat4
	{
		var m: Mat4;
		if (_dirty)
		{
			m = matrix.identity().scale(scale.x, scale.y, scale.z)
			.rotate(rotation.x, Vector3D.X_AXIS)
			.rotate(rotation.y, Vector3D.Y_AXIS)
			.rotate(rotation.z, Vector3D.Z_AXIS)
			.translate(position.x, position.y, position.z);
			
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