package;

import ferret.*;
import ferret.f2d.*;
import ferret.fgl.*;
import ferret.input.*;
import openfl.*;
import openfl.geom.*;
import openfl.gl.*;

class TwoDimScene extends Scene2D
{
	var tex: Texture;
	var sheet: TextureSheet;
	var batch: SpriteBatch;
	
	public function new()
	{
		super();	

		clearColor = Color.fromFloat(0, 0, 0);

		tex = new Texture("textures/icon.png", GL.LINEAR);
		sheet = new TextureSheet(tex);
		sheet.map("full", new Rectangle(0, 0, 64, 64));
		
		batch = new SpriteBatch(sheet);
		for (i in 0...5000)
			batch.addSprite("full", Std.random(2000) - 1000, Std.random(2000) - 1000);
		
		orthoCam = new OrthographicCamera(800, 480, -1, 1);
		
		renderType(Scene2D.SPRITE_BATCH);
	}

	override public function resize(_): Void
	{
		var width: Int = Lib.current.stage.stageWidth;
		var height: Int = Lib.current.stage.stageHeight;
		var scale: Float = Math.min(width / 800, height / 480);
		
		orthoCam.width = Std.int(Lib.current.stage.stageWidth / scale);
		orthoCam.height = Std.int(Lib.current.stage.stageHeight / scale);
	}
	
	override public function update(delta: Float): Void
	{
		super.update(delta);
	
		for (i in 0...batch.sprites.length)
		{
			batch.sprites[i].rotation += 180 * delta;
			batch.updateSprite(i);
		}

		batch.drawPrebatched(renderer);
	}
}