package ferret;

import ferret.gl.*;
import openfl.Assets;

typedef Instance3D = 
{
	var meshIndex: Int;
	var transform: Transform3D;
}

class Scene3D extends Scene
{
	private var untextured3D: Program = new Program(Assets.getText("shaders/untextured3D.vert"), Assets.getText("shaders/untextured3D.frag"));
	private var textured3D: Program= new Program(Assets.getText("shaders/textured3D.vert"), Assets.getText("shaders/textured3D.frag"));	
	
	private var meshList: Array<Mesh> = new Array();
	private var modelInstances: Map<Int, Array<Transform3D>> = new Map();
	
	private var perspCam: PerspectiveCamera;
	
	public function new() 
	{
		super();
	}
	
	public function createModelInstance(mesh: Mesh): Transform3D
	{
		var index: Int = meshList.indexOf(mesh);
		if (index == -1)
		{
			index = meshList.push(mesh) - 1;
			modelInstances.set(index, new Array());
		}
		
		var t: Transform3D = new Transform3D();
		modelInstances.get(index).push(t);
		return t;
	}
	
	override public function update(delta:Float) 
	{
		super.update(delta);
		for (key in modelInstances.keys())
		{
			renderer.uploadMesh(meshList[key]);
			for (modelInstance in modelInstances.get(key))
			{
				renderer.renderMesh(modelInstance.getMatrix());
			}
		}
	}
}