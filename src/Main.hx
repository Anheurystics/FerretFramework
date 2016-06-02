package;

import ferret.input.*;
import openfl.*;
import ferret.fgl.TextureManager;
import openfl.display.*;
import openfl.text.*;
import scenes.*;
import openfl.events.Event;
import openfl.gl.GL;

class Main extends Sprite
{
	public static var textField: TextField;
	
	public function new()
	{
		super();
		#if !mobile
		KeyboardInput.init();
		#end
		
		addChild(new ForestScene());
		
		var format: TextFormat = new TextFormat(Assets.getFont("fonts/CalibriLight.ttf").fontName, 32, 0x555555);
		format.align = TextFormatAlign.CENTER;
		textField = new TextField();
		textField.defaultTextFormat = format;
		textField.text = "Hello World!";
		textField.autoSize = TextFieldAutoSize.CENTER;
		textField.selectable = false;
		
		addChild(textField);

		Lib.current.stage.addEventListener(Event.RESIZE, resize);
	}
	
	function resize(_): Void
	{
		var width: Int = Lib.current.stage.stageWidth;
		var height: Int = Lib.current.stage.stageHeight;
		var scale: Float = Math.min(width / 360, height / 540);
		
		scaleX = scaleY = scale;
	}
}
