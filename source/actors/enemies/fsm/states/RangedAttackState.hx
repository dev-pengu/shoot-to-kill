package actors.enemies.fsm.states;

class RangedAttackState extends AttackState {

    private var shotsToReload:Int;
    private var reloadTimer:Float;
    private var isReloading:Bool;

	public function new(entity:Enemy)
	{
		super(entity);
        isReloading = false;
        shotsToReload = this.managedEntity.stats.rounds;
	}

    override public function update(elapsed:Float):Void {
		super.update(elapsed);
        if (!isReloading) {
			if (attackTimer <= 0) {
				this.managedEntity.animation.play(Enemy.ATTACK_ANIMATION);
                this.managedEntity.attack();
                shotsToReload -= 1;
                if (shotsToReload == 0) {
                    isReloading = true;
                    reloadTimer = this.managedEntity.stats.reloadTime;
                }

                attackTimer = (60 / this.managedEntity.stats.attackSpeed) / 60;
            } else {
                attackTimer -= elapsed;
            }
        } else {
            if (reloadTimer <= 0) {
                isReloading = false;
				shotsToReload = this.managedEntity.stats.rounds;
            } else {
                reloadTimer -= elapsed;
            }
        }
		if (this.managedEntity.animation.finished)
		{
			this.managedEntity.animation.play(Enemy.IDLE_ANIMATION);
		}
    }
}