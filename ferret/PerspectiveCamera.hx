package ferret;

import ferret.gl.Mat4;
import flash.geom.Matrix3D;
import openfl.geom.Vector3D;

class PerspectiveCamera implements Camera
{
	public var transform: Transform3D;
	
	public var fov(default, set): Float = 54;
	public function set_fov(_fov: Float): Float
	{
		fov = _fov;
		projection.perspective(fov, aspect, near, far);
		return fov;
	}
	
	public var aspect(default, set): Float = 1;
	public function set_aspect(_aspect: Float): Float
	{
		aspect = _aspect;
		projection.perspective(fov, aspect, near, far);
		return aspect;
	}
	
	public var near(default, set): Float = 0.1;
	public function set_near(_near: Float): Float
	{
		near = _near;
		projection.perspective(fov, aspect, near, far);
		return near;
	}
	
	public var far(default, set): Float = 100;
	public function set_far(_far: Float): Float
	{
		far = _far;
		projection.perspective(fov, aspect, near, far);
		return far;
	}
	
	public var front: Vector3D;
	public var right: Vector3D;
	public var up: Vector3D;

	var view: Mat4;
	var projection: Mat4;	
	
	public function new(_fov: Float, _aspect: Float, _near: Float, _far: Float) 
	{
		transform = new Transform3D();
		
		up = new Vector3D(0, 1, 0);
		front = new Vector3D(0, 0, 1);
		right = new Vector3D(1, 0, 0);
		
		view = new Mat4();
		projection = new Mat4();
		
		fov = _fov;
		aspect = _aspect;
		near = _near;
		far = _far;
	}

	public function update(): Void
	{
		var pitch: Float = Utils.toRad(transform.rotation.x);
		var yaw: Float = Utils.toRad(transform.rotation.y);
		var roll: Float = Utils.toRad(transform.rotation.z);
		
		var matx: Matrix3D = new Matrix3D();
		matx.appendRotation(transform.rotation.x, Vector3D.X_AXIS);
		
		var maty: Matrix3D = new Matrix3D();
		maty.appendRotation(transform.rotation.y, Vector3D.Y_AXIS);
		
		var matz: Matrix3D = new Matrix3D();
		matz.appendRotation(transform.rotation.z, Vector3D.Z_AXIS);
		
		matx.append(maty);
		matx.append(matz);
		
		front = matx.transformVector(new Vector3D(0, 0, 1, 0));
		right = matx.transformVector(new Vector3D(1, 0, 0, 0));
		up = matx.transformVector(new Vector3D(0, 1, 0, 0));
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
}