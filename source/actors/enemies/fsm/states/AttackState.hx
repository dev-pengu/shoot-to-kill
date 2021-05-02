package actors.enemies.fsm.states;

import flixel.FlxObject;
import flixel.math.FlxPoint;

class AttackState extends EnemyState {

    private var attackTimer:Float;

	public function new(entity:Enemy)
	{
		super(entity);
        attackTimer = 0;
	}

    override public function getNextState():Int {
        var targetFound:Bool = false;

        for (i in 0...Enemy.TARGETS.length) {
            if (this.managedEntity.checkAggro(Enemy.TARGETS[i])) {
                targetFound = true;
                return EnemyStates.NO_CHANGE.getIndex();
            }
        }

        if (!targetFound) {
            return EnemyStates.IDLE.getIndex();
        }

        return super.getNextState();
    }

    override public function transitionIn():Void {
        this.managedEntity.drag.x = Enemy.DECELERATION;

        if (this.managedEntity.animation.finished || this.managedEntity.animation.name == Enemy.WALK_ANIMATION) {
            this.managedEntity.animation.play(Enemy.IDLE_ANIMATION);
        }
    }

    override public function transitionOut():Void {
        this.managedEntity.drag.x = 0;
    }

    override public function update(elapsed:Float) {
		this.managedEntity.facing = this.managedEntity.targetPosition.x > this.managedEntity.x ? FlxObject.RIGHT : FlxObject.LEFT;
		this.managedEntity.flipX = this.managedEntity.facing == FlxObject.LEFT;
    }
}