package ferret;

import ferret.PerspectiveCamera;
import ferret.Scene3D.Instance3D;
import ferret.Transform3D;
import ferret.gl.Mesh;
import ferret.gl.Program;
import ferret.gl.Texture;
import openfl.Assets;
import openfl.Lib;

typedef Instance3D = 
{
	var meshIndex: Int;
	var mesh: Mesh;
	var transform: Transform3D;
	var texture: Texture;
}

class Scene3D extends Scene
{
	private static inline var UNTEXTURED: Int = 1;
	private static inline var TEXTURED: Int = 2;
	
	private var untextured3D: Program = new Program(Assets.getText("shaders/untextured3D.vert"), Assets.getText("shaders/untextured3D.frag"));
	private var textured3D: Program = new Program(Assets.getText("shaders/textured3D.vert"), Assets.getText("shaders/textured3D.frag"));	
	
	private var meshList: Array<Mesh> = new Array();
	private var modelInstances: Map<Int, Array<Instance3D>> = new Map();
	
	private var renderType: Int;
	
	private var perspCam: PerspectiveCamera;
	
	public function new() 
	{
		super();
		
		perspCam = new PerspectiveCamera(54, Lib.current.stage.stageWidth / Lib.current.stage.stageHeight, 0.1, 100.0);
		
		setRenderType(UNTEXTURED);
	}
	
	public function setRenderType(type: Int)
	{
		switch(type)
		{
			case UNTEXTURED:
				program = untextured3D;
			case TEXTURED:
				program = textured3D;
			default:
				program = textured3D;
				renderType = TEXTURED;
		}
		
		renderType = type;
		renderer.uploadProgram(program);
		
		switch(renderType)
		{
			case UNTEXTURED:
				renderer.uniformf("ambient", 0.8, 0.8, 0.8);
			case TEXTURED:
				renderer.uniformf("ambient", 0.8, 0.8, 0.8);
		}
	}	
	
	public function createModelInstance(mesh: Mesh): Instance3D
	{
		var index: Int = meshList.indexOf(mesh);
		if (index == -1)
		{
			index = meshList.push(mesh) - 1;
			modelInstances.set(index, new Array());
		}

		var instance: Instance3D = {
			meshIndex: index,
			mesh: mesh,
			transform: new Transform3D(),
			texture: null
		};
		
		modelInstances.get(index).push(instance);
		return instance;
	}
	
	public function cloneModelInstance(instance: Instance3D): Instance3D
	{
		var clone: Instance3D = {
			meshIndex: instance.meshIndex,
			mesh: instance.mesh,
			transform: new Transform3D(),
			texture: instance.texture
		};
		
		clone.transform.rotateToV(instance.transform.rotation).scaleToV(instance.transform.scale).moveToV(instance.transform.position);
		
		modelInstances.get(clone.meshIndex).push(clone);
		return clone;		
	}
	
	override public function update(delta:Float) 
	{
		camera = perspCam;
		super.update(delta);
		
		for (key in modelInstances.keys())
		{
			renderer.uploadMesh(meshList[key]);
			for (modelInstance in modelInstances.get(key))
			{
				if (renderType == TEXTURED)
				{
					renderer.uploadTexture(modelInstance.texture);
				}
				renderer.renderMesh(modelInstance.transform.getMatrix());
			}
		}
	}
}