package actors.enemies;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import items.Bullet;
import actors.player.Player;
import actors.enemies.stats.EnemyStats;

class RangedVillager extends Enemy {

    public static var RANGED_VILLAGER_AGGRO_RANGE(default, never):Float = 400;
    public static var ATTACK_RANGE(default, never):Float = 400;
    public static var ROUNDS(default, never):Int = 3;
    public static var RELOAD_TIME(default, never):Float = 3;
    public static var ATTACK_SPEED(default, never):Float = 0.5; // attacks per second
    public static var MAX_HEALTH(default, never):Float = 50;

    public static var BULLETS(default, default):FlxTypedGroup<Bullet>;
	public static var BULLET_SPAWN_OFFSET_X(default, never):Float = -5;
	public static var BULLET_SPAWN_OFFSET_Y(default, never):Float = 21;
    public static var BULLET_SPEED(default, never):Float = 150;
    public static var BULLET_RANGE(default, never):Float = 400;
    public static var BULLET_DAMAGE(default, never):Float = 10;

    public function new(?X:Float=0, ?Y:Float=0, player:Player) {
		super(X, Y, AssetPaths.TownsPeople_sprite_sheet__png, player, "rangedVillager");

        if (BULLETS == null) {
            BULLETS = new FlxTypedGroup<Bullet>();
        }
        initAnimations();
        initStates();
		enemySfx[Enemy.ATTACK_SOUND] = FlxG.sound.load(AssetPaths.rifle_shooting__ogg, 0.25);
    }

    private function initAnimations():Void {
		var colorVariation:Int = FlxG.random.int(0, 2);
		animation.add(Enemy.IDLE_ANIMATION, [0 + 11 * colorVariation], 1, false);
		animation.add(Enemy.WALK_ANIMATION, [
			1 + 11 * colorVariation,
			2 + 11 * colorVariation,
			3 + 11 * colorVariation,
			1 + 11 * colorVariation,
			5 + 11 * colorVariation,
			6 + 11 * colorVariation
		], 8);
		animation.add(Enemy.ATTACK_ANIMATION, [
			7 + 11 * colorVariation,
			8 + 11 * colorVariation,
			9 + 11 * colorVariation,
			10 + 11 * colorVariation,
			9 + 11 * colorVariation
		], 8, false);
		animation.add(Enemy.HURT_ANIMATION, [11 * colorVariation, 33, 34, 33, 11 * colorVariation], 6, false);
    }

    public static function addBullets():Void {
		FlxG.state.add(BULLETS);
    }

    override public function attack():Void {
        var bullet:Bullet = BULLETS.recycle(Bullet);
        if (this.facing == FlxObject.RIGHT) {
            bullet.setPosition(this.x + Enemy.SPRITE_SIZE + BULLET_SPAWN_OFFSET_X, this.y + BULLET_SPAWN_OFFSET_Y);
			bullet.setParams(BULLET_SPEED, 1, BULLET_RANGE, BULLET_DAMAGE);
        } else {
            bullet.setPosition(this.x - BULLET_SPAWN_OFFSET_X, this.y + BULLET_SPAWN_OFFSET_Y);
			bullet.setParams(BULLET_SPEED, -1, BULLET_RANGE, BULLET_DAMAGE);
        }
        this.enemySfx[Enemy.ATTACK_SOUND].play(true);
        bullet.fire();
    }
}