package;

import ferret.*;
import ferret.f2d.*;
import ferret.fgl.*;
import openfl.*;

class MenuScene extends Scene2D
{
	var circle: Mesh;
	var model: Transform2D;
	
	public function new() 
	{
		super();
		orthoCam = new OrthographicCamera(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight, -1, 1);
		
		circle = Shape.circle(Color.fromFloat(1.0, 0.2, 0.2));
		
		model = new Transform2D();
		model.scaleTo(50, 50);

		renderType(Scene2D.SHAPES);
	}
	
	override public function resize(_): Void
	{
		var width: Int = Lib.current.stage.stageWidth;
		var height: Int = Lib.current.stage.stageHeight;
		var scale: Float = Math.min(width / 800, height / 480);
		
		orthoCam.width = Std.int(Lib.current.stage.stageWidth / scale);
		orthoCam.height = Std.int(Lib.current.stage.stageHeight / scale);
	}	
	
	override public function update(delta:Float) 
	{
		super.update(delta);
		
		renderer.uploadMesh(circle);
		renderer.renderMesh(model.getMatrix());
	}
}