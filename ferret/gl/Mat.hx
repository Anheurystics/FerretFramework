package ferret.gl;

import openfl.geom.Matrix3D;
import openfl.utils.Float32Array;

interface Mat 
{
	public function array(): Float32Array;
	public function type(): Int;
	public function inverse(): Mat;
	public function transpose(): Mat;
	public function clone(): Mat;
	public function internal(): Matrix3D;
}