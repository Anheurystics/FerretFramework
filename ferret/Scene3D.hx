package ferret;

import ferret.PerspectiveCamera;
import ferret.Scene.UVLayout;
import ferret.Scene3D.Instance3D;
import ferret.Transform3D;
import ferret.gl.Mesh;
import ferret.gl.Program;
import ferret.gl.Texture;
import openfl.Assets;

typedef Instance3D = 
{
	var meshIndex: Int;
	var transform: Transform3D;
	var texture: Texture;
	var uvLayout: UVLayout;
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
				renderer.uniformf("uvOffset", 0.0, 0.0);
				renderer.uniformf("uvScale", 1.0, 1.0);
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
			transform: new Transform3D(),
			texture: null,
			uvLayout: {offsetX: 0, offsetY: 0, scaleX: 1, scaleY: 1}
		};
		
		modelInstances.get(index).push(instance);
		return instance;
	}
	
	public function cloneModelInstance(instance: Instance3D): Instance3D
	{
		var clone: Instance3D = {
			meshIndex: instance.meshIndex,
			transform: new Transform3D(),
			texture: instance.texture,
			uvLayout: {
				offsetX: instance.uvLayout.offsetX, 
				offsetY: instance.uvLayout.offsetY, 
				scaleX: instance.uvLayout.scaleX, 
				scaleY: instance.uvLayout.scaleY
			}
		};
		
		clone.transform.rotateToV(instance.transform.rotation).scaleToV(instance.transform.scale).moveToV(instance.transform.position);
		
		modelInstances.get(instance.meshIndex).push(clone);
		return instance;		
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
					renderer.uniformf("uvOffset", modelInstance.uvLayout.offsetX, modelInstance.uvLayout.offsetY);
					renderer.uniformf("uvScale", modelInstance.uvLayout.scaleX, modelInstance.uvLayout.scaleY);
				}
				renderer.renderMesh(modelInstance.transform.getMatrix());
			}
		}
	}
}