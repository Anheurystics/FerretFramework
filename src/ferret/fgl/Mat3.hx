package ferret.fgl;

import openfl.geom.Matrix3D;
import openfl.geom.Vector3D;
import openfl.utils.Float32Array;

class Mat3 implements Mat
{
	public var _matrix: Matrix3D = new Matrix3D();
	private var _array: Float32Array = new Float32Array(16);

	public function new() {}

	public function identity(): Mat3
	{
		_matrix.identity();
		return this;
	}
	
	public function inverse(): Mat3
	{
		_matrix.invert();
		return this;
	}
	
	public function multiply(mat: Mat): Mat3
	{
		_matrix.append(mat.internal());
		return this;
	}	
	
	public function transpose(): Mat3
	{
		_matrix.transpose();
		return this;
	}

	public function translate(x: Float = 0, y: Float = 0): Mat3
	{
		_matrix.appendTranslation(x, y, 0);
		return this;
	}

	public function rotate(degrees: Float): Mat3
	{
		_matrix.appendRotation(degrees, Vector3D.Z_AXIS);
		return this;
	}

	public function scale(x: Float = 1, y: Float = 1): Mat3
	{
		_matrix.appendScale(x, y, 1);
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
	
	public function clone(): Mat3
	{
		var c: Mat3 = new Mat3();
		for (i in 0...16)
		{
			c._matrix.rawData[i] = _matrix.rawData[i];
		}
		return c;
	}
	
	public function type(): Int
	{
		return 3;
	}
	
	public function internal(): Matrix3D
	{
		return _matrix;
	}
}