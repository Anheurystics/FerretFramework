package;

import ferret.input.*;
import openfl.*;
import openfl.display.*;
import openfl.text.*;
import scenes.*;

class Main extends Sprite
{
	public function new()
	{
		super();
		#if !mobile
		KeyboardInput.init();
		#end
		
		addChild(new ForestScene());
		
		var fps: FPS = new FPS();
		fps.defaultTextFormat = new TextFormat(Assets.getFont("fonts/INPUTMONO-REGULAR_0.TTF").fontName, 32, 0xFFFFFF);
		fps.width = Lib.current.stage.stageWidth;
		addChild(fps);
	}
}