package ferret;
import ferret.gl.OrthographicCamera;
import ferret.gl.Program;
import openfl.Assets;

class Scene2D extends Scene
{
	private static inline var SPRITE_INDIV: Int = 1;
	private static inline var SPRITE_BATCH: Int = 2;
	private static inline var SHAPES: Int = 3;

	private var batchTextured2D: Program = new Program(Assets.getText("shaders/batchTextured2D.vert"), Assets.getText("shaders/batchTextured2D.frag"));
	private var untextured2D: Program = new Program(Assets.getText("shaders/untextured2D.vert"), Assets.getText("shaders/untextured2D.frag"));
	private var textured2D: Program = new Program(Assets.getText("shaders/textured2D.vert"), Assets.getText("shaders/textured2D.frag"));

	private var renderType: Int;
	
	public var orthoCam: OrthographicCamera;
	
	public function new()
	{
		super();
		
		setRenderType(SPRITE_INDIV);
	}
	
	public function setRenderType(type: Int)
	{
		switch(type)
		{
			case SPRITE_INDIV:
				program = textured2D;
			case SPRITE_BATCH:
				program = batchTextured2D;
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