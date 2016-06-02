package;

import ferret.*;
import ferret.fgl.*;
import ferret.input.*;
import glhelp.*;
import openfl.*;
import openfl.events.*;
import openfl.geom.*;
import openfl.ui.*;

class ForestScene extends Scene3D
{
	var treeMesh: Mesh;
	var floorMesh: Mesh;
	
	var treeModel_0: Transform3D;
	var treeModel_1: Transform3D;
	
	var floorModel: Transform3D;
	
	var mouseFocus: Bool = false;
	
	var ambient: Color = Color.fromFloat(.2, .2, .2);
	
	public function new()
	{
		super();
		
		clearColor = Color.fromFloat(0.2, 0.2, 1.0);
		
		KeyboardInput.bind("forward", Keyboard.W);
		KeyboardInput.bind("backward", Keyboard.S);
		KeyboardInput.bind("left", Keyboard.A);
		KeyboardInput.bind("right", Keyboard.D);
		KeyboardInput.bind("unfocus", Keyboard.ESCAPE);		
		
		program = new Program(Assets.getText("shaders/untextured3D.vert"), Assets.getText("shaders/untextured3D.frag"));
		
		treeMesh = new Mesh(OBJLoader.load("models/drone.obj"), []);
		floorMesh = new Mesh(new MeshData(
			[
				-0.5,  0.0,  0.5, 0.0, 1.0, 0.0, 0.072248, 0.166333, 0.064153,	
				 0.5,  0.0,  0.5, 0.0, 1.0, 0.0, 0.072248, 0.166333, 0.064153,
				 0.5,  0.0, -0.5, 0.0, 1.0, 0.0, 0.072248, 0.166333, 0.064153,
				-0.5,  0.0, -0.5, 0.0, 1.0, 0.0, 0.072248, 0.166333, 0.064153
			], ["position", "normal", "color"], [3, 3, 3]
		), [0, 1, 2, 0, 2, 3]);

		treeModel_0 = createModelInstance(treeMesh);
		treeModel_0.moveBy(0, 5, 0);
		
		treeModel_1 = createModelInstance(treeMesh);
		treeModel_1.moveBy(3, 0, 3);		
		
		floorModel = createModelInstance(floorMesh);
		floorModel.scaleBy(50, 1, 50);
		
		camera = perspCam = new PerspectiveCamera(54, Lib.current.stage.stageWidth / Lib.current.stage.stageHeight, 0.1, 100);
		perspCam.transform.moveTo(0, 3, -10);
		
		MouseLook.init();
		MouseLook.lookAround = lookAround;
		
		Lib.current.stage.addEventListener(Event.RESIZE, resize);
		Lib.current.stage.addEventListener(MouseEvent.CLICK, mouseClick);
		
		renderer.uploadProgram(program);

		var angle: Float = 0;
		for (i in 0...16)
		{
			renderer.uniformf("pointLights["+i+"].enabled", 1);
			if (i % 2 == 0)
				renderer.uniformf("pointLights[" + i + "].color", 0, 0, 1);
			else
				renderer.uniformf("pointLights[" + i + "].color", 1, 0, 0);

			renderer.uniformf("pointLights[" + i + "].intensity", .1);
			renderer.uniformf("pointLights[" + i + "].attenuationFactor", 1, 1);
			renderer.uniformf("pointLights[" + i + "].position", Math.cos(angle) * 24, 3, Math.sin(angle) * 24);

			angle += (Math.PI * 2) / 16;
		}
		
		renderer.uniformi("numPointLights", 16);
		renderer.uniformi("numDirLights", 0);
		
		renderer.uniformf("ambient", ambient.r, ambient.g, ambient.b);
	}
	
	private function mouseClick(e: MouseEvent)
	{
		MouseLook.startMouseLook();
	}
	
	public function lookAround(dx: Int, dy: Int)
	{
		var hw: Int = Std.int(Lib.current.stage.stageWidth / 2);
		var hh: Int = Std.int(Lib.current.stage.stageHeight / 2);
		
		var pitch: Float = perspCam.transform.rotation.x;
		var yaw: Float = perspCam.transform.rotation.y;
		
		pitch += Utils.toDeg(dy / hh);
		yaw += Utils.toDeg(dx / hw);
		
		pitch = Utils.clamp(pitch, -45, 45);
		
		perspCam.transform.rotateTo(pitch, yaw, 0);
	}
	
	override public function resize(_): Void
	{
		perspCam.aspect = Lib.current.stage.stageWidth / Lib.current.stage.stageHeight;
	}
	
	override public function update(delta: Float): Void
	{
		super.update(delta);
		
		KeyboardInput.update(delta);
		
		var movement: Vector3D = new Vector3D();
		
		if (KeyboardInput.isPressed("unfocus"))
			MouseLook.endMouseLook();
		if (KeyboardInput.isDown("forward"))
			movement = movement.add(perspCam.front);
		if (KeyboardInput.isDown("backward"))
			movement = movement.subtract(perspCam.front);
		if (KeyboardInput.isDown("left"))
			movement = movement.subtract(perspCam.right);
		if (KeyboardInput.isDown("right"))
			movement = movement.add(perspCam.right);
		
		movement.y = 0;
		movement.normalize();
		movement.scaleBy(10 * delta);
		
		perspCam.transform.moveBy(movement.x, movement.y, movement.z);
	}
}