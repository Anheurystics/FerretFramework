package ferret;

import ferret.gl.Camera;
import ferret.gl.Program;
import ferret.gl.Renderer;
import openfl.Lib;
import openfl.display.OpenGLView;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.gl.GL;

class Scene extends OpenGLView
{	
	private var renderer: Renderer;
	private var program: Program;
	private var camera: Camera;
	private var clearColor: Color = Color.fromFloat(0, 0, 0);
	private var transparent: Bool = false;
	
	public function new() 
	{
		super();
		
		renderer = new Renderer();
		if (program != null)
		{
			renderer.uploadProgram(program);
		}
		lastUpdate = Lib.getTimer();
		render = glRender;
		
		Lib.current.stage.addEventListener(Event.RESIZE, resize);
	}

	public function resize(_) {}
	
	var lastUpdate: Int;
	public function glRender(rect: Rectangle)
	{
		var delta: Float = (Lib.getTimer() - lastUpdate) / 1000;
		lastUpdate = Lib.getTimer();
		update(delta);
	}

	public function update(delta: Float)
	{
		if (!transparent)
		{
			renderer.clear(clearColor.r, clearColor.g, clearColor.b);
		}
		renderer.depthTest(GL.LEQUAL);
		
		if (program != null)
		{	
			renderer.uploadProgram(program);
			if (camera != null)
			{
				camera.update();
				renderer.uniformMatrix("view", camera.getView());
				renderer.uniformMatrix("proj", camera.getProjection());
			}
		}
	}
}