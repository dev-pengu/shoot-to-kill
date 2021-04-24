package actors.enemies.fsm;

import flixel.FlxObject;

class EnemyState implements State
{
	private var managedEntity:FlxObject;

	public function new(entity:FlxObject)
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