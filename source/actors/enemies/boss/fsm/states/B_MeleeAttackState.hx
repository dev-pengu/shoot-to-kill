package actors.enemies.boss.fsm.states;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;

class B_MeleeAttackState extends BossState {

    private var movementDirection:Int = 0;
    private var startPoint:FlxPoint;

    public function new(entity:Boss) {
        super(entity);
    }

    override public function getNextState():Int {

        if (Math.abs(startPoint.distanceTo(this.managedEntity.getMidpoint())) >= this.managedEntity.stats.aggroRange) {
            return BossStates.IDLE.getIndex();
        }
        return super.getNextState();
    }

    override public function transitionIn():Void {
        this.managedEntity.isInvincible = true;
        if (this.managedEntity.target.x > this.managedEntity.x) {
            movementDirection = 1;
        } else {
            movementDirection = -1;
        }
		this.managedEntity.facing = movementDirection == 1 ? FlxObject.RIGHT : FlxObject.LEFT;
		this.managedEntity.flipX = this.managedEntity.facing == FlxObject.LEFT;
        this.managedEntity.enemySfx[Boss.MELEE_ATTACK].play(true);
        this.managedEntity.animation.play(Boss.MELEE_ATTACK);
        startPoint = this.managedEntity.getMidpoint();
        FlxG.camera.shake(0.5, 1.5);
    }

    override public function transitionOut():Void {
        this.managedEntity.isInvincible = false;
        this.managedEntity.enemySfx[Boss.MELEE_ATTACK].stop();
        this.managedEntity.animation.stop();
    }

    override public function update(elapsed:Float):Void {
        this.managedEntity.velocity.x = Boss.CHARGE_SPEED * movementDirection;
    }
}