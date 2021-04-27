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

    public static var BULLETS(default, null):FlxTypedGroup<Bullet> = new FlxTypedGroup<Bullet>();
    public static var BULLET_SPAWN_OFFSET_X(default, never):Float = 35;
    public static var BULLET_SPAWN_OFFSET_Y(default, never):Float = 14;
    public static var BULLET_SPEED(default, never):Float = 100;
    public static var BULLET_RANGE(default, never):Float = 400;
    public static var BULLET_DAMAGE(default, never):Float = 10;

    public function new(?X:Float=0, ?Y:Float=0, player:Player) {
		super(X, Y, AssetPaths.enemy__png, player, "rangedVillager");

        animation.add(Enemy.IDLE_ANIMATION, [0], 1, false);
		animation.add(Enemy.WALK_ANIMATION, [1, 2, 3, 1, 4, 5], 8);
        animation.add(Enemy.ATTACK_ANIMATION, [6,7,6], 4, false);
        initStates();
    }

    public static function addBullets():Void {
		FlxG.state.add(BULLETS);
    }

    override public function attack():Void {
        var bullet:Bullet = BULLETS.recycle(Bullet);
        if (this.facing == FlxObject.RIGHT) {
            bullet.setPosition(this.x + BULLET_SPAWN_OFFSET_X, this.y + BULLET_SPAWN_OFFSET_Y);
			bullet.setParams(BULLET_SPEED, 1, BULLET_RANGE, BULLET_DAMAGE);
        } else {
            bullet.setPosition(this.x + Enemy.SPRITE_SIZE - BULLET_SPAWN_OFFSET_X, this.y + BULLET_SPAWN_OFFSET_Y);
			bullet.setParams(BULLET_SPEED, -1, BULLET_RANGE, BULLET_DAMAGE);
        }
        bullet.fire();
    }
}