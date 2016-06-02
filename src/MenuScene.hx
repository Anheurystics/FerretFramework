package;

import ferret.*;
import ferret.f2d.*;
import ferret.fgl.*;
import openfl.*;

class MenuScene extends Scene2D
{
	var circle: Mesh;
	var circle2: Mesh;
	var model: Transform2D;
	var model2: Transform2D;

	public function new() 
	{
		super();
		orthoCam = new OrthographicCamera(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight, -1, 1);
		
		clearColor = Color.fromFloat(1, 1, 1);
		circle = Shape.circle(Color.fromFloat(1.0, 0.2, 0.2));
		circle2 = Shape.circle(Color.fromFloat(1.0, 0.0, 0.0));
		
		model = new Transform2D();
		model.moveTo( -100, 0);
		model.scaleTo(200, 200);
		
		model2 = new Transform2D();
		model2.moveTo(100, 0);
		model2.scaleTo(200, 200);
		
		renderType(Scene2D.SHAPES);
	}
	
	override public function resize(_): Void
	{
		var width: Int = Lib.current.stage.stageWidth;
		var height: Int = Lib.current.stage.stageHeight;
		var scale: Float = Math.min(width / 960, height / 540);
		
		orthoCam.width = Std.int(Lib.current.stage.stageWidth / scale);
		orthoCam.height = Std.int(Lib.current.stage.stageHeight / scale);
	}	
	
	override public function update(delta:Float) 
	{
		super.update(delta);
		
		renderer.uploadMesh(circle);
		renderer.renderMesh(model.getMatrix());
		
		//renderer.uploadMesh(circle2);
		//renderer.renderMesh(model2.getMatrix());
	}
}