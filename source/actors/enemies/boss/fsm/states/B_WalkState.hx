package actors.enemies.boss.fsm.states;

import flixel.FlxObject;
import flixel.FlxG;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;

class B_WalkState extends BossState {

    private var hasReachedDestination:Bool = false;
    private var targetWayPoint:FlxPoint;
    private var direction:FlxVector;
    private var isJumping:Bool;

    public function new(entity:Boss) {
        super(entity);
    }

    override public function getNextState():Int {

        if (hasReachedDestination) {
            return (FlxG.random.int(-1, 1, [0]) == 1 ?
                BossStates.RANGED_ATTACK.getIndex() :
                BossStates.MELEE_ATTACK.getIndex());
        }

        return super.getNextState();
    }

    override public function transitionIn():Void {
        hasReachedDestination = false;
        targetWayPoint = this.managedEntity.getTargetWaypoint();
        if (targetWayPoint.x > this.managedEntity.x) {
            direction = FlxVector.weak(1, 0);
        } else {
            direction = FlxVector.weak(-1, 0);
        }
        isJumping = false;
    }

    override public function transitionOut():Void {
        this.managedEntity.animation.stop();
    }

    override public function update(elapsed:Float):Void {
        if (this.targetWayPoint.x == this.managedEntity.x) {
            hasReachedDestination = true;
        }

        if (this.targetWayPoint.y < this.managedEntity.y && !isJumping && 
            Math.abs(this.targetWayPoint.x - this.managedEntity.x) < 32) {
            this.managedEntity.velocity.y = Boss.JUMP_VELOCITY;
            this.managedEntity.animation.play(Boss.JUMP);
            isJumping = true;
        }

        if (detectEdge() && !isJumping) {
            this.managedEntity.velocity.y = Boss.JUMP_VELOCITY;
            this.managedEntity.animation.play(Boss.JUMP);
            isJumping = true;
        }
        this.managedEntity.velocity.x = Boss.SPEED * direction.x;

        if (this.managedEntity.velocity.y >= 0 && !this.managedEntity.isTouching(FlxObject.DOWN) && this.managedEntity.animation.name != Boss.FALL) {
            this.managedEntity.animation.play(Boss.FALL);
        }

        if (this.managedEntity.isTouching(FlxObject.DOWN) && this.managedEntity.animation.name != Boss.WALK) {
            this.managedEntity.animation.play(Boss.WALK);
            isJumping = false;
        }
    }

    private function detectEdge():Bool {
        var startPoint:FlxPoint = FlxPoint.weak(0, this.managedEntity.y + this.managedEntity.height - 3);
        var endPoint:FlxPoint = FlxPoint.weak(0, this.managedEntity.y + this.managedEntity.height + 35);
        if (this.managedEntity.facing == FlxObject.RIGHT) {
            endPoint.x = startPoint.x = this.managedEntity.x + this.managedEntity.width + 5;
        } else {
            endPoint.x = startPoint.x = this.managedEntity.x - 15;
        }

        if (Enemy.OBSTRUCTIONS.ray(startPoint, endPoint)) {
            return true;
        }

        return false;
    }
}