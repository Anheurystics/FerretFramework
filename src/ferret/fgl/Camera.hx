package ferret.fgl;

interface Camera 
{
	public function update(): Void;
	public function getView(): Mat4;
	public function getProjection(): Mat4;
}