package actors.enemies.fsm;

class EnemyState implements State
{
	private var managedEntity:Enemy;

	public function new(entity:Enemy)
	{
		this.managedEntity = entity;
	}

	public function getNextState():Int
	{
		return EnemyStates.NO_CHANGE.getIndex();
	}

	public function update(elapsed:Float):Void {}

	public function transitionIn():Void {}

	public function transitionOut():Void {}
}