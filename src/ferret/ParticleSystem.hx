package ferret;

typedef Particle =  {
	> SpriteBatch.Sprite,
	
	var life: Float;
	var lifetime: Float;
	var vx: Float;
	var vy: Float;
}

class ParticleSystem extends SpriteBatch
{
	public function new(_sheet: TextureSheet) 
	{
		super(_sheet);
	}
	
	public function update(delta: Float): Void
	{
		for (sprite in sprites)
		{
			if (Std.is(sprite, Particle))
			{
				sprite.x += vx * 
			}
		}
	}
	
	public function emit(n: Int): Void
	{
		
	}
}