package actors.enemies.boss.fsm;

import actors.enemies.fsm.State;

class BossState implements State
{
	private var managedEntity:Boss;

	public function new(entity:Boss)
	{
		this.managedEntity = entity;
	}

	public function getNextState():Int
	{
		return BossStates.NO_CHANGE.getIndex();
	}

	public function update(elapsed:Float):Void {}

	public function transitionIn():Void {}

	public function transitionOut():Void {}
}