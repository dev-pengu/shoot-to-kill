package actors.enemies.fsm.states;

import flixel.FlxObject;
import flixel.FlxG;


class WalkState extends EnemyState {

	private var walkTimer:Float;
	private var direction:Int;
	private var walkingBack:Bool;
	private var prevWalkTimer:Float;

	public function new(entity:Enemy)
	{
		super(entity);
		walkTimer = 2 + FlxG.random.float(0.5, 1);
		direction = FlxG.random.int(-1,1, [0]);
		walkingBack = false;
	}

	override public function getNextState():Int {
		if (walkTimer < 0) {
			return EnemyStates.IDLE.getIndex();
		}
		return super.getNextState();
	}

	override public function transitionIn():Void {
		if (walkingBack) {
			direction *= -direction;
			walkTimer = prevWalkTimer;
		} else {
			prevWalkTimer = walkTimer = 2 + FlxG.random.float(0.5, 1);
		}

		this.managedEntity.facing = direction == -1 ? FlxObject.LEFT : FlxObject.RIGHT;
		this.managedEntity.flipX = this.managedEntity.facing == FlxObject.LEFT;

		this.managedEntity.animation.play(Enemy.WALK_ANIMATION);
	}

	override public function transitionOut():Void {
		walkTimer = 0;
		walkingBack = !walkingBack;
	}

	override public function update(elapsed:Float) {
		if (this.managedEntity.animation.finished && this.managedEntity.animation.name != Enemy.WALK_ANIMATION)
		{
			this.managedEntity.animation.play(Enemy.WALK_ANIMATION);
		}
		this.managedEntity.velocity.x = Enemy.SPEED * direction;

		walkTimer -= elapsed;
	}
}