package actors.enemies.boss.fsm.states;


import flixel.FlxObject;
import flixel.FlxG;

class B_WalkState extends BossState {

    private var hasReachedDestination:Bool = false;
    private var direction:Int;
    private var isJumping:Bool;

    public function new(entity:Boss) {
        super(entity);
    }

    override public function getNextState():Int {

        if (hasReachedDestination) {
			return (FlxG.random.int(-1, 1, [0]) == 1 ? BossStates.RANGED_ATTACK.getIndex() : 
            BossStates.MELEE_ATTACK.getIndex());
        }

        return super.getNextState();
    }

    override public function transitionIn():Void {
        hasReachedDestination = false;
		if (this.managedEntity.getTargetWaypoint().x > this.managedEntity.x) {
            direction = 1;
        } else {
            direction = -1;
        }
        isJumping = false;
		this.managedEntity.facing = direction == 1 ? FlxObject.RIGHT : FlxObject.LEFT;
		this.managedEntity.flipX = this.managedEntity.facing == FlxObject.LEFT;
		this.managedEntity.animation.play(Boss.WALK);
    }

    override public function transitionOut():Void {
        if (this.managedEntity.animation.curAnim.looped) {
			this.managedEntity.animation.stop();
        }
    }

    override public function update(elapsed:Float):Void {
		if (this.managedEntity.x >= this.managedEntity.getTargetWaypoint().x - 30 && this.managedEntity.x <= this.managedEntity.getTargetWaypoint().x + 30) {
            hasReachedDestination = true;
            direction = 0;
            this.managedEntity.animation.play(Boss.IDLE);
        }
        this.managedEntity.velocity.x = Boss.SPEED * direction;
    }
}