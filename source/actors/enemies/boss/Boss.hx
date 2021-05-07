package actors.enemies.boss;

import actors.enemies.boss.fsm.states.B_MeleeAttackState;
import actors.enemies.boss.fsm.states.B_RangedAttackState;
import actors.enemies.boss.fsm.BossStates;
import actors.enemies.boss.fsm.states.B_WalkState;
import actors.enemies.boss.fsm.states.B_IdleState;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import actors.player.Player;
import actors.enemies.Enemy;
import haxe.ds.Vector;
import actors.enemies.fsm.State;

class Boss extends Enemy {

	public static var WIDTH(default, never):Int = 20;
	public static var HEIGHT(default, never):Int = 60;
	public static var SPRITE_SIZE(default, never):Int = 48;

    public static var SPEED(default, never):Float = 80;
    public static var CHARGE_SPEED(default, never):Float = 170;

	public static var JUMP_VELOCITY(default, never):Float = -275;
	public static var MAX_Y_SPEED(default, never):Float = 300;
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

    public var target:FlxObject;
    public var isInvincible(default, default):Bool = false;
    public var inBattle(default, null):Bool = false;

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
		maxVelocity.set(CHARGE_SPEED, MAX_Y_SPEED);

        wayPoints = new Array<FlxPoint>();

        buildAnimations();
        buildSoundMap();
        initStates();
    }

    private function buildSoundMap():Void {
		enemySfx[RANGED_ATTACK] = FlxG.sound.load(AssetPaths.shotgun_shot__ogg, 0.25);
		enemySfx[MELEE_ATTACK] = FlxG.sound.load(AssetPaths.Running_on_Gravel_www__fesliyanstudios__com__ogg, 0.25);
    }

    private function buildAnimations():Void {
		animation.add(IDLE, [0], 1, false);
		animation.add(WALK, [1, 2, 3, 1, 4, 5], 8);
		animation.add(JUMP, [10, 11], 8, false);
		animation.add(FALL, [12, 13, 14], 6, false);
		animation.add(RANGED_ATTACK, [0, 15, 16, 17, 18], 15, false);
		animation.add(MELEE_ATTACK, [1, 2, 3, 1, 4, 5], 8);
    }

    public function activate():Void {
		this.inBattle = true;
    }

    public function addWayPoint(point:FlxPoint) {
        if (!wayPoints.contains(point)) {
            wayPoints.push(point);
        }
    }

    override private function initStates():Void {
		states = new Vector<State>(5);
        states[BossStates.IDLE.getIndex()] = new B_IdleState(this);
        states[BossStates.WALK.getIndex()] = new B_WalkState(this);
        states[BossStates.RANGED_ATTACK.getIndex()] = new B_RangedAttackState(this);
        states[BossStates.MELEE_ATTACK.getIndex()] = new B_MeleeAttackState(this);
		state = states[BossStates.IDLE.getIndex()];
		state.transitionIn();
    }

    override public function hurt(damage:Float) {
        if (!isInvincible) {
            super.hurt(damage);
        }
    }

    override public function attack():Void { }

    public function setNextWayPoint():Void {
		currentWayPointIndex = FlxG.random.int(0, wayPoints.length - 1, [currentWayPointIndex]);
    }

    public function getTargetWaypoint():FlxPoint {
        return wayPoints[currentWayPointIndex];
    }

	override private function handleStateTransitions():Void
	{
		var nextState:Int;
		do
		{
			nextState = state.getNextState();
			if (nextState != BossStates.NO_CHANGE.getIndex())
			{
				state.transitionOut();
				state = states[nextState];
				state.transitionIn();
			}
		}
		while (nextState != BossStates.NO_CHANGE.getIndex());
	}
}