package actors.enemies.fsm.states;

import flixel.FlxG;


class IdleState extends EnemyState {

	private var idleTimer:Float;

	public function new(entity:Enemy)
	{
		super(entity);
		idleTimer = FlxG.random.float(0.5, 1);
	}

	override public function getNextState():Int {
		if (idleTimer < 0) {
			return EnemyStates.WALK.getIndex();
		}

		return super.getNextState();
	}

	override public function transitionIn():Void {
		idleTimer = FlxG.random.float(0.5, 1);
		this.managedEntity.drag.x = Enemy.DECELERATION;

		if (this.managedEntity.animation.finished) {
			this.managedEntity.animation.play(Enemy.IDLE_ANIMATION);
		}
	}

	override public function transitionOut():Void {
		idleTimer = 0;
		this.managedEntity.drag.x = 0;
	}

	override public function update(elapsed:Float) {
		if (this.managedEntity.animation.finished && this.managedEntity.animation.name != Enemy.IDLE_ANIMATION) {
			this.managedEntity.animation.play(Enemy.IDLE_ANIMATION);
		}

		idleTimer -= elapsed;
	}
}