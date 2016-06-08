package ferret;
import ferret.ParticleSystem.Particle;
import ferret.SpriteBatch.Sprite;

typedef Particle =  {
	var life: Float;
	var lifetime: Float;
	var vx: Float;
	var vy: Float;
}

class ParticleSystem extends SpriteBatch
{
	public var x: Float;
	public var y: Float;
	
	private var particleData: Array<Particle> = new Array();
	
	public function new(_x: Float = 0, _y: Float = 0, _sheet: TextureSheet) 
	{
		super(_sheet);
		
		x = _x;
		y = _y;
	}
	
	public function update(delta: Float): Void
	{
		for (i in 0...sprites.length)
		{
			var sprite = sprites[i];
			sprite.x += particleData[i].vx * delta;
			sprite.y += particleData[i].vy * delta;
					
			updateSprite(i);				
		}
	}
	
	public function emit(n: Int): Void
	{
		for (i in 0...n)
		{
			var angle = Math.random() * Math.PI;
			
			var newParticle: Particle = {
				life: 1.0, lifetime: 0.0, vx: 32.0 * Math.cos(angle), vy: 32.0 * Math.sin(angle)
			};
			
			var newSprite: Sprite = {
				name: "particle", x: x, y: y, scaleX: 1, scaleY: 1, rotation: 0
			}
			
			particleData.push(newParticle);
			sprites.push(newSprite);
		}
	}
}