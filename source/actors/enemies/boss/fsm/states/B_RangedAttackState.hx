package actors.enemies.boss.fsm.states;

import items.Bullet;
import actors.enemies.stats.StatFactory;
import flixel.FlxObject;

class B_RangedAttackState extends BossState {
    private var attacksLeft:Int = 3;
    private var attackTimer:Float = 0;

    public function new(entity:Boss) {
        super(entity);
    }

    override public function getNextState():Int {

        if (attacksLeft == 0) {
            return BossStates.IDLE.getIndex();
        }

        return super.getNextState();
    }

    override public function transitionIn():Void {
        attacksLeft = 3;
        attackTimer = 0;
		this.managedEntity.velocity.x = 0;
        this.managedEntity.isInvincible = true;
		this.managedEntity.facing = this.managedEntity.target.x > this.managedEntity.x ? FlxObject.RIGHT : FlxObject.LEFT;
		this.managedEntity.flipX = this.managedEntity.facing == FlxObject.LEFT;
    }

    override public function transitionOut():Void {
        this.managedEntity.isInvincible = false;
    }

    override public function update(elapsed:Float):Void {
        if (attackTimer <= 0) {
            fireShots();
            attacksLeft--;
            attackTimer = 1.75;
        } else {
            attackTimer -= elapsed;
        }
    }

    private function fireShots():Void {
		this.managedEntity.animation.play(Boss.RANGED_ATTACK);
		var bullet1:Bullet = StatFactory.BULLETS.recycle(Bullet);
		var bullet2:Bullet = StatFactory.BULLETS.recycle(Bullet);
		var bullet3:Bullet = StatFactory.BULLETS.recycle(Bullet);

		var angle1:Float = 15;
		var angle2:Float = 345;

		if (this.managedEntity.facing == FlxObject.RIGHT)
		{
			bullet1.setPosition(this.managedEntity.x + Boss.SPRITE_SIZE + Boss.BULLET_SPAWN_OFFSET_X, this.managedEntity.y + Boss.BULLET_SPAWN_OFFSET_Y);
			bullet2.setPosition(this.managedEntity.x + Boss.SPRITE_SIZE + Boss.BULLET_SPAWN_OFFSET_X, this.managedEntity.y + Boss.BULLET_SPAWN_OFFSET_Y);
			bullet3.setPosition(this.managedEntity.x + Boss.SPRITE_SIZE + Boss.BULLET_SPAWN_OFFSET_X, this.managedEntity.y + Boss.BULLET_SPAWN_OFFSET_Y);

			bullet1.setParams(Boss.BULLET_SPEED, 1, this.managedEntity.stats.attackRange, this.managedEntity.stats.rangedAttackDamage);
			bullet2.setParams(Boss.BULLET_SPEED, 1, this.managedEntity.stats.attackRange, this.managedEntity.stats.rangedAttackDamage);
			bullet3.setParams(Boss.BULLET_SPEED, 1, this.managedEntity.stats.attackRange, this.managedEntity.stats.rangedAttackDamage);
		}
		else
		{
			bullet1.setPosition(this.managedEntity.x - Boss.BULLET_SPAWN_OFFSET_X, this.managedEntity.y + Boss.BULLET_SPAWN_OFFSET_Y);
			bullet2.setPosition(this.managedEntity.x - Boss.BULLET_SPAWN_OFFSET_X, this.managedEntity.y + Boss.BULLET_SPAWN_OFFSET_Y);
			bullet3.setPosition(this.managedEntity.x - Boss.BULLET_SPAWN_OFFSET_X, this.managedEntity.y + Boss.BULLET_SPAWN_OFFSET_Y);

			bullet1.setParams(Boss.BULLET_SPEED, -1, this.managedEntity.stats.attackRange, this.managedEntity.stats.rangedAttackDamage);
			bullet2.setParams(Boss.BULLET_SPEED, -1, this.managedEntity.stats.attackRange, this.managedEntity.stats.rangedAttackDamage);
			bullet3.setParams(Boss.BULLET_SPEED, -1, this.managedEntity.stats.attackRange, this.managedEntity.stats.rangedAttackDamage);

			//angle1 = 165;
			//angle2 = 195;
		}
		this.managedEntity.enemySfx[Boss.RANGED_ATTACK].play(true);
		bullet1.fireAngle(angle1);
		bullet2.fire();
		bullet3.fireAngle(angle2);
    }
}