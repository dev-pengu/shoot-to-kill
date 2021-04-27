package actors.enemies.fsm;

interface State
{
	public function getNextState():Int;
	public function update(elapsed:Float):Void;
	public function transitionIn():Void;
	public function transitionOut():Void;
}