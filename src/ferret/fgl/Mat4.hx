package ferret.fgl;

import ferret.fgl.Mat;
import openfl.geom.Matrix3D;
import openfl.geom.Vector3D;
import openfl.utils.Float32Array;

class Mat4 implements Mat
{
	private var _matrix: Matrix3D = new Matrix3D();
	private var _array: Float32Array = new Float32Array(16);

	public function new() {}

	public function identity(): Mat4
	{
		_matrix.identity();
		return this;
	}
	
	public function inverse(): Mat4
	{
		_matrix.invert();
		return this;
	}
	
	public function transpose(): Mat4
	{
		_matrix.transpose();
		return this;
	}
	
	public function multiply(mat: Mat): Mat4
	{
		_matrix.append(mat.internal());
		return this;
	}
	

	public function translate(x: Float = 0, y: Float = 0, z: Float = 0): Mat4
	{
		_matrix.appendTranslation(x, y, z);
		return this;
	}

	public function rotate(degrees: Float, axis: Vector3D, pivotPoint: Vector3D = null): Mat4
	{
		_matrix.appendRotation(degrees, axis, pivotPoint);
		return this;
	}

	public function scale(x: Float = 1, y: Float = 1, z: Float = 1): Mat4
	{
		_matrix.appendScale(x, y, z);
		return this;
	}

	public function array(): Float32Array
	{
		for (i in 0...16)
		{
			_array[i] = _matrix.rawData[i];
		}
		return _array;
	}

	public function perspective(fov: Float, aspect: Float, near: Float, far: Float): Mat4
	{
		var f: Float = 1.0 / Math.tan(Utils.toRad(fov) / 2);
		var nf: Float = 1 / (near - far);

		_matrix.rawData = [
			f / aspect, 0, 0, 0,
			0, f, 0, 0,
			0, 0, (far + near) * nf, -1,
			0, 0, (2 * far * near) * nf, 0
		];

		return this;
	}

	public function ortho(left: Float, right: Float, top: Float, bottom: Float, zNear: Float, zFar: Float): Mat4
	{
		var sx = 1.0 / (right - left);
		var sy = 1.0 / (top - bottom);
		var sz = 1.0 / (zFar - zNear);

		_matrix.rawData = [
			2 * sx, 	0, 			0, 				0, 
			0, 			2 * sy,		0, 				0, 
			0, 			0, 			-2 * sz, 		0, 
			-(right + left) * sx, -(top + bottom) * sy, -(zNear + zFar) * sz, 1 ];

		return this;
	}

	static var X: Vector3D = new Vector3D();
	static var Y: Vector3D = new Vector3D();
	static var Z: Vector3D = new Vector3D();
	public function lookAt(position: Vector3D, target: Vector3D, up: Vector3D): Mat4
	{
		Z = target.subtract(position);
		Z.normalize();
		
		X = up.crossProduct(Z);
		X.normalize();
		
		Y = Z.crossProduct(X);
		Y.normalize();
		
		_matrix.rawData =
			[
				X.x, Y.x, -Z.x, 0,
				X.y, Y.y, -Z.y, 0,
				X.z, Y.z, -Z.z, 0,
				-X.dotProduct(position), -Y.dotProduct(position), Z.dotProduct(position), 1
			];
		
		return this;
	}
	
	public function clone(): Mat4
	{
		var c: Mat4 = new Mat4();
		for (i in 0...16)
		{
			c._matrix.rawData[i] = _matrix.rawData[i];
		}
		return c;
	}
	
	public function type(): Int
	{
		return 4;
	}
	
	public function internal(): Matrix3D
	{
		return _matrix;
	}
}