package actors.enemies.fsm.states;

import flixel.math.FlxPoint;
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
		direction = 1;
		walkingBack = false;
	}

	override public function getNextState():Int {
		for (i in 0...Enemy.TARGETS.length)
		{
			if (this.managedEntity.checkAggro(Enemy.TARGETS[i]))
			{
				return EnemyStates.ATTACK.getIndex();
			}
		}

		if (walkTimer < 0) {
			return EnemyStates.IDLE.getIndex();
		}
		this.managedEntity.facing = direction == -1 ? FlxObject.LEFT : FlxObject.RIGHT;
		this.managedEntity.flipX = this.managedEntity.facing == FlxObject.LEFT;
		return super.getNextState();
	}

	override public function transitionIn():Void {
		if (walkingBack) {
			direction = -direction;
			walkTimer = prevWalkTimer;
		} else {
			prevWalkTimer = walkTimer = 2 + FlxG.random.float(0.5, 1);
			direction = FlxG.random.int(-1, 1, [0]);
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

		if (detectEdge()) {
			this.managedEntity.drag.x = Enemy.DECELERATION;
			this.managedEntity.velocity.x = 0;
			this.prevWalkTimer = prevWalkTimer - walkTimer;
			walkTimer = 0;
		} else {
			this.managedEntity.drag.x = 0;
			this.managedEntity.velocity.x = Enemy.SPEED * direction;
		}

		walkTimer -= elapsed;
	}

	private function detectEdge():Bool {
		var startPoint:FlxPoint = FlxPoint.weak(0, this.managedEntity.y + this.managedEntity.height - 3);
		var endPoint:FlxPoint = FlxPoint.weak(0, this.managedEntity.y + this.managedEntity.height + 35);
		if (this.managedEntity.facing == FlxObject.RIGHT) {
			endPoint.x = startPoint.x = this.managedEntity.x + this.managedEntity.width + 15;
		} else {
			endPoint.x = startPoint.x = this.managedEntity.x - 15;
		}

		if (Enemy.OBSTRUCTIONS.ray(startPoint, endPoint)) {
			return true;
		}
		return false;
	}
}