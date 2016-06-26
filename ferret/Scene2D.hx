package ferret;

import ferret.OrthographicCamera;
import ferret.gl.Program;
import openfl.Assets;

class Scene2D extends Scene
{
	private static inline var SPRITES: Int = 1;
	private static inline var SHAPES: Int = 2;

	private var untextured2D: Program = new Program(Assets.getText("shaders/untextured2D.vert"), Assets.getText("shaders/untextured2D.frag"));
	private var textured2D: Program = new Program(Assets.getText("shaders/textured2D.vert"), Assets.getText("shaders/textured2D.frag"));

	private var renderType: Int;
	
	public var orthoCam: OrthographicCamera;
	
	public function new()
	{
		super();
		
		setRenderType(SPRITES);
	}
	
	public function setRenderType(type: Int)
	{
		switch(type)
		{
			case SPRITES:
				program = textured2D;
			case SHAPES:
				program = untextured2D;
			default:
				program = textured2D;
		}
		
		renderType = type;
		renderer.uploadProgram(program);
	}
	
	override public function update(delta:Float) 
	{
		camera = orthoCam;
		super.update(delta);
	}
}