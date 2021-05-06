package actors.enemies.boss.fsm.states;

import flixel.FlxG;

class B_IdleState extends BossState {
    private var idleTimer:Float;

    public function new(entity:Boss) {
        super(entity);
        idleTimer = FlxG.random.float(1, 1.5);
    }

    override public function getNextState():Int {

        if (idleTimer <= 0) {
            return BossStates.WALK.getIndex();
        }

        return super.getNextState();
    }

    override public function transitionIn():Void {
        idleTimer = FlxG.random.float(1, 1.5);
        this.managedEntity.velocity.set(0, 0);

        if (this.managedEntity.animation.finished || this.managedEntity.animation.curAnim.looped) {
            this.managedEntity.animation.play(Boss.IDLE);
        }
    }

    override public function transitionOut():Void {
        idleTimer = 0;
        this.managedEntity.setNextWayPoint();
    }

    override public function update(elapsed:Float) {
        if (this.managedEntity.animation.finished && this.managedEntity.animation.name != Boss.IDLE) {
            this.managedEntity.animation.play(Boss.IDLE);
        }

        idleTimer -= elapsed;
    }
}