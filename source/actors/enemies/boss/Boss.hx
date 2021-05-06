package actors.enemies.boss;

import actors.enemies.stats.StatFactory;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import actors.player.Player;
import flixel.group.FlxGroup;
import items.Bullet;
import actors.enemies.fsm.EnemyStates;
import actors.enemies.Enemy;

class Boss extends Enemy {

	public static var WIDTH(default, never):Int = 20;
	public static var HEIGHT(default, never):Int = 60;
	public static var SPRITE_SIZE(default, never):Int = 48;

    public static var SPEED(default, never):Float = 80;
    public static var CHARGE_SPEED(default, never):Float = 160;

	public static var JUMP_VELOCITY(default, never):Float = -275;
	public static var GRAVITY(default, never):Float = 450;
	private static var INVINCIBLE_TIME:Float = 1;

	public static var BULLET_SPAWN_OFFSET_X(default, never):Float = -5;
	public static var BULLET_SPAWN_OFFSET_Y(default, never):Float = 21;
	public static var BULLET_SPEED(default, never):Float = 150;
	public static var BULLET_RANGE(default, never):Float = 400;
	public static var BULLET_DAMAGE(default, never):Float = 10;

    public static var RANGED_ATTACK(default, never):String = "rangedAttack";
    public static var MELEE_ATTACK(default, never):String = "meleeAttack";
    public static var IDLE(default, never):String = "idle";
    public static var WALK(default, never):String = "walk";
    public static var JUMP(default, never):String = "jump";
    public static var FALL(default, never):String = "fall";

    private var wayPoints:Array<FlxPoint>;
    private var currentWayPointIndex:Int = 0;

    private var damageToInvincible:Float = 50;

    public var target:FlxObject;
    public var isInvincible(default, null):Bool = false;

	public function new(?X:Float = 0, ?Y:Float = 0, graphicPath:String, player:Player, statsString:String, ?width:Int, ?height:Int, ?graphicSize:Int) {
        if (graphicSize == null) {
			graphicSize = SPRITE_SIZE;
		}
		if (width == null) {
			width = WIDTH;
		}
		if (height == null) {
			height = HEIGHT;
		}
		super(X, Y, graphicPath, player, statsString, width, height, graphicSize);

        wayPoints = new Array<FlxPoint>();
        enemySfx[RANGED_ATTACK] = FlxG.sound.load(AssetPaths.shotgun_shot__ogg, 0.25);
        enemySfx[MELEE_ATTACK] = FlxG.sound.load(AssetPaths.Running_on_Gravel_www__fesliyanstudios__com__ogg, 0.25);
        this.active = false;
    }

    public function activate():Void {
        this.active = true;
    }

    public function addWayPoint(point:FlxPoint) {
        if (!wayPoints.contains(point)) {
            wayPoints.push(point);
        }
    }

    override private function initStates():Void {

        state = states[EnemyStates.IDLE.getIndex()];
        state.transitionIn();
    }

    override public function hurt(damage:Float) {
        if (!isInvincible) {
            super.hurt(damage);
            damageToInvincible -= damage;
            if (damageToInvincible <= 0) {
                isInvincible = true;
            }
        }
    }

    override public function attack():Void {
        if (this.getMidpoint().distanceTo(target.getMidpoint()) <= stats.aggroRange) {
            this.animation.play(MELEE_ATTACK);
            chargeAttack();
        } else {
            this.animation.play(RANGED_ATTACK);
            rangedAttack();
        }
    }

    private function chargeAttack():Void {
        isInvincible = true;
        var movementDirection:Int = 0;
        if (target.x > this.x) {
            movementDirection = 1;
        } else {
            movementDirection = -1;
        }
        this.velocity.x = Boss.CHARGE_SPEED * movementDirection;
		this.enemySfx[MELEE_ATTACK].play(true);
    }

    private function rangedAttack():Void {
        var bullet1:Bullet = StatFactory.BULLETS.recycle(Bullet);
		var bullet2:Bullet = StatFactory.BULLETS.recycle(Bullet);
		var bullet3:Bullet = StatFactory.BULLETS.recycle(Bullet);

        var angle1:Float = 15;
        var angle2:Float = 345;

        if (this.facing == FlxObject.RIGHT) {
            bullet1.setPosition(this.x + Boss.SPRITE_SIZE + BULLET_SPAWN_OFFSET_X, this.y + BULLET_SPAWN_OFFSET_Y);
			bullet2.setPosition(this.x + Boss.SPRITE_SIZE + BULLET_SPAWN_OFFSET_X, this.y + BULLET_SPAWN_OFFSET_Y);
			bullet3.setPosition(this.x + Boss.SPRITE_SIZE + BULLET_SPAWN_OFFSET_X, this.y + BULLET_SPAWN_OFFSET_Y);

            bullet1.setParams(BULLET_SPEED, 1, BULLET_RANGE, BULLET_DAMAGE);
			bullet3.setParams(BULLET_SPEED, 1, BULLET_RANGE, BULLET_DAMAGE);
			bullet3.setParams(BULLET_SPEED, 1, BULLET_RANGE, BULLET_DAMAGE);
        } else {
			bullet1.setPosition(this.x - BULLET_SPAWN_OFFSET_X, this.y + BULLET_SPAWN_OFFSET_Y);
			bullet2.setPosition(this.x - BULLET_SPAWN_OFFSET_X, this.y + BULLET_SPAWN_OFFSET_Y);
			bullet3.setPosition(this.x - BULLET_SPAWN_OFFSET_X, this.y + BULLET_SPAWN_OFFSET_Y);

			bullet1.setParams(BULLET_SPEED, -1, BULLET_RANGE, BULLET_DAMAGE);
			bullet3.setParams(BULLET_SPEED, -1, BULLET_RANGE, BULLET_DAMAGE);
			bullet3.setParams(BULLET_SPEED, -1, BULLET_RANGE, BULLET_DAMAGE);

            angle1 = 165;
            angle2 = 195;
        }
        this.enemySfx[RANGED_ATTACK].play(true);
        bullet1.fireAngle(angle1);
        bullet2.fire();
        bullet3.fireAngle(angle2);
    }

    public function setNextWayPoint():Void {

    }

    public function getTargetWaypoint():FlxPoint {
        return wayPoints[currentWayPointIndex];
    }
}