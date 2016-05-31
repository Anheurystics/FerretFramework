package ferret;

import openfl.Lib;
import openfl.geom.Rectangle;
import openfl.geom.Vector3D;
import ferret.fgl.Mat4;
import ferret.fgl.Mesh;
import ferret.fgl.MeshData;
import ferret.fgl.Renderer;
import ferret.fgl.Utils;
import ferret.TextureSheet;

typedef Sprite = 
{
	var name: String;
	var x: Float;
	var y: Float;
	var scaleX: Float;
	var scaleY: Float;
	var rotation: Float;
};

class SpriteBatch
{
	private var sheet: TextureSheet;
	private var mesh: Mesh;
	private var meshData: MeshData;

	public var sprites: Array<Sprite> = [];
	private var spriteVertices: Array<Float> = [];
	private var spriteIndices: Array<Int> = [];
	private var dirty: Bool = false;
	
	private var quad: Array<Vector3D> = [
		new Vector3D( -0.5,  0.5, 0),
		new Vector3D(  0.5,  0.5, 0),
		new Vector3D(  0.5, -0.5, 0),
		new Vector3D( -0.5, -0.5, 0)
	];
	
	private var uvs: Array<Vector3D> = [
		new Vector3D(0, 0, 0),
		new Vector3D(1, 0, 0),
		new Vector3D(1, 1, 0),
		new Vector3D(0, 1, 0)
	];	

	public function new(_sheet: TextureSheet) 
	{
		sheet = _sheet;
		mesh = new Mesh(meshData = new MeshData([], ["position", "uv", "color"], [3, 2, 3]), []);
	}

	public function addSprite(name: String, x: Float, y: Float, sx: Float = 1, sy: Float = 1, rotation: Float = 0): Void
	{
		var newSprite: Sprite = {
			name: name, x: x, y: y, scaleX: sx, scaleY: sy, rotation: rotation
		};
		
		sprites.push(newSprite);
		updateSprite(sprites.length - 1);
	}
	
	public function updateSprite(index: Int)
	{
		var start: Int = Lib.getTimer();
		
		var sprite: Sprite = sprites[index];
		var name: String = sprite.name;
		var x: Float = sprite.x;
		var y: Float = sprite.y;
		var sx: Float = sprite.scaleX;
		var sy: Float = sprite.scaleY;
		var r: Float = sprite.rotation;
		
		var mapping: Rectangle = sheet.getMapping(name);
		var mappingUV: Rectangle = sheet.getMappingUV(name);
		
		var theta: Float = Utils.toRad(r);
		var cosTheta: Float = Math.cos(theta);
		var sinTheta: Float = Math.sin(theta);
		
		var spriteOff: Int = index * 32;
		
		for (i in 0...4)
		{
			var vertOff: Int = i * 8;
			
			var position: Vector3D = quad[i];
			var uv: Vector3D = uvs[i];		
			
			spriteVertices[spriteOff + vertOff] = ((position.x * cosTheta) - (position.y * sinTheta)) * sx * mapping.width + x;
			spriteVertices[spriteOff + vertOff + 1] = ((position.x * sinTheta) + (position.y * cosTheta)) * sy * mapping.height + y;
			spriteVertices[spriteOff + vertOff + 2] = position.z;
			spriteVertices[spriteOff + vertOff + 3] = (uv.x * mappingUV.width) + mappingUV.x;
			spriteVertices[spriteOff + vertOff + 4] = (uv.y * mappingUV.height) + mappingUV.y;
			spriteVertices[spriteOff + vertOff + 5] = 1;
			spriteVertices[spriteOff + vertOff + 6] = 1;
			spriteVertices[spriteOff + vertOff + 7] = 1;
		}
		
		var indexOff: Int = index * 6;
		var offset: Int = index * 4;
		
		spriteIndices[indexOff] = offset;
		spriteIndices[indexOff + 1] = offset + 1;
		spriteIndices[indexOff + 2] = offset + 2;
		spriteIndices[indexOff + 3] = offset;
		spriteIndices[indexOff + 4] = offset + 2;
		spriteIndices[indexOff + 5] = offset + 3;
		
		dirty = true;
	}
	
	public function drawPrebatched(_renderer: Renderer): Void
	{
		_renderer.uploadTexture(sheet.texture);
		
		if (dirty)
		{
			meshData.array = spriteVertices;
			mesh.indices = spriteIndices;
			mesh.updateBuffer();	
		}
		
		_renderer.uploadMesh(mesh);
		_renderer.renderMesh();
		_renderer = null;
	}	
}