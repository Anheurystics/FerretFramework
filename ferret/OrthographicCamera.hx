package ferret;

import ferret.gl.Camera;
import ferret.gl.Mat4;
import ferret.gl.Utils;
import openfl.geom.Matrix3D;
import openfl.geom.Vector3D;

class OrthographicCamera implements Camera
{
	private static var MIN_ZOOM: Float = 0.1;
	private static var MAX_ZOOM: Float = 10;
	
	public var transform: Transform2D = new Transform2D();
	
	public var front: Vector3D = new Vector3D(0, 0, 1);
	public var right: Vector3D = new Vector3D(1, 0, 0);
	public var up: Vector3D = new Vector3D(0, 1, 0);
	
	var view = new Mat4();
	var projection = new Mat4();

	public var width(default, set): Int = 0;
	public function set_width(_width: Int): Int
	{ 
		width = _width; 
		projection.ortho( -width / 2, width / 2, height / 2, -height / 2, near, far); 
		return width;
	}
	
	public var height(default, set): Int = 0;
	public function set_height(_height: Int): Int
	{ 
		height = _height; 
		projection.ortho( -width / 2, width / 2, height / 2, -height / 2, near, far); 
		return height;
	}	
	
	public var near(default, set): Float = -1;
	public function set_near(_near: Float): Float
	{
		near = _near;
		projection.ortho( -width / 2, width / 2, height / 2, -height / 2, near, far); 
		return near;
	}
	
	public var far(default, set): Float = 1;
	public function set_far(_far: Float): Float
	{
		far = _far;
		projection.ortho( -width / 2, width / 2, height / 2, -height / 2, near, far); 
		return far;
	}
	
	public var zoom(default, set): Float = 1;
	public function set_zoom(_zoom: Float): Float
	{
		zoom = Math.min(MAX_ZOOM, Math.max(MIN_ZOOM, _zoom));
		var w: Float = width / zoom;
		var h: Float = height / zoom;
		projection.ortho( -w / 2, w / 2, h / 2, -h / 2, near, far); 
		return zoom;
	}
	
	public function new(_width: Int, _height: Int, _near: Float, _far: Float) 
	{
		width = _width;
		height = _height;
		near = _near;
		far = _far;
		
		update();
	}

	public function update(): Void
	{
		var mat: Matrix3D = new Matrix3D();
		mat.appendRotation(Utils.toRad(transform.rotation), Vector3D.Z_AXIS);
		
		front = mat.transformVector(new Vector3D(0, 0, 1, 0));
		right = mat.transformVector(new Vector3D(1, 0, 0, 0));
		up = mat.transformVector(new Vector3D(0, 1, 0, 0));
	}
	
	public function getProjection(): Mat4
	{
		return projection;
	}

	public function getView(): Mat4
	{
		view.lookAt(transform.position, transform.position.add(front), up);
		return view;
	}	
	
	private function updateOrthographic(width: Float, height: Float, near: Float = -1, far: Float = 1) : Void
	{
		projection.ortho(-width/2, width/2, height/2, -height/2, near, far);
	}
}