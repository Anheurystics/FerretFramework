package ferret.input;

import lime.ui.Mouse;
import openfl.Lib;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;

#if (html5 && js)
import js.Browser;
import js.html.Element;
#end

#if mobile
class MouseLook
{
	public static var lookAround: Int->Int->Void;
	public static function init() {}
	public static function startMouseLook() {}
	public static function endMouseLook() {}
}
#else
class MouseLook
{
	static var isMouseLookOn: Bool = false;
	public static var lookAround: Int->Int->Void;
	
	#if html5
	static var canvas: Element;
	#end
	
	public static function init()
	{
		#if !html5
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		#else
		canvas = Browser.document.getElementById("openfl-content").getElementsByTagName("canvas").item(0);
		
		canvas.addEventListener("mousemove", function(e)
		{	
			if (isMouseLookOn && lookAround != null)
			{
				var sw: Float = canvas.clientWidth / 800;
				var sh: Float = canvas.clientHeight / 480;
				
				var x = e.movementX;
				var y = e.movementY;
				
				var mx = untyped e["mozMovementX"];
				var my = untyped e["mozMovementY"];
				
				var dx: Int;
				var dy: Int;
				
				if (x == null && y == null)
				{
					dx = Std.int(mx * sw);
					dy = Std.int(my * sh);
				}
				else
				{
					dx = Std.int(x * sw);
					dy = Std.int(y * sh);
				}
				
				lookAround(dx, dy);	
			}	
		}); 
		
		var pointerChange = function(e)
		{
			if (Browser.document.pointerLockElement == null && untyped Browser.document["mozPointerLockElement"] == null)
			{
				isMouseLookOn = false;
				Mouse.show();
			}
			else
			{
				isMouseLookOn = true;
				Mouse.hide();
			}
		};
		
		Browser.document.addEventListener("pointerlockchange", pointerChange);
		Browser.document.addEventListener("mozpointerlockchange", pointerChange);
		#end
	}
	
	#if !html5
	static function mouseMove(e: MouseEvent)
	{
		if (isMouseLookOn)
		{
			var hw: Int = Std.int(Lib.current.stage.stageWidth / 2);
			var hh: Int = Std.int(Lib.current.stage.stageHeight / 2);
			
			var dx: Int = Std.int(e.stageX - hw);
			var dy: Int = Std.int(e.stageY - hh);
			
			if (lookAround != null)
			{
				lookAround(dx, dy);
			}
			
			Mouse.warp(hw, hh, Lib.current.stage.window);
		}
	}
	#end
	
	public static function startMouseLook(): Void
	{
		if (!isMouseLookOn)
		{
			#if !html5
			isMouseLookOn = true;
			Mouse.hide();
			Mouse.warp(Std.int(Lib.current.stage.stageWidth / 2), Std.int(Lib.current.stage.stageHeight / 2), Lib.current.stage.window);
			#else
			if (canvas.requestPointerLock != null) canvas.requestPointerLock();
			else untyped canvas["mozRequestPointerLock"]();
			#end			
		}
	}
	
	public static function endMouseLook(): Void
	{
		isMouseLookOn = false;
		Mouse.show();
		#if html5
		Browser.document.exitPointerLock();
		#end
	}
}
#end