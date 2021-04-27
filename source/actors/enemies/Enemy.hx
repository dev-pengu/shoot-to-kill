package actors.enemies;


import actors.enemies.stats.StatFactory;
import actors.player.Player;
import haxe.Exception;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.ui.FlxBar;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import flixel.FlxSprite;
import haxe.ds.Vector;
import actors.enemies.fsm.EnemyStates;
import actors.enemies.fsm.State;
import actors.enemies.fsm.states.IdleState;
import actors.enemies.fsm.states.WalkState;
import actors.enemies.fsm.states.RangedAttackState;
import actors.enemies.fsm.states.MeleeAttackState;
import actors.enemies.stats.EnemyStats;

class Enemy extends FlxSprite
{
	public static var SPEED(default, never):Float = 40;
	public static var DECELERATION(default, never):Float = 700;
	public static var OBSTRUCTIONS(default, default):FlxTilemap;
	public static var GRAVITY(default, never):Float = 400;
	public static var OFFSET_X(default, never):Int = 14;
	public static var OFFSET_Y(default, never):Int = 12;
	public static var WIDTH(default, never):Int = 20;
	public static var HEIGHT(default, never):Int = 60;
	public static var SPRITE_SIZE(default, never):Int = 48;
	public static var HEALTH_BAR_OFFSET_X(default, never):Int = 0;
	public static var HEALTH_BAR_OFFSET_Y(default, never):Int = -20;

	public static var TARGETS(default, null):Array<FlxObject> = new Array<FlxObject>();

	public static var IDLE_ANIMATION(default, never):String = "idle";
	public static var WALK_ANIMATION(default, never):String = "walk";
	public static var HURT_ANIMATION(default, never):String = "hurt";
	public static var ATTACK_ANIMATION(default, never):String = "attack";

	private var state:State;
	private var states:Vector<State> = new Vector<State>(4);
	private var healthBar:FlxBar;

	@:isVar public var stats(get, null):EnemyStats;
	@:isVar public var targetPosition(get, null):FlxPoint;

	function get_stats() return stats;
	function get_targetPosition() return targetPosition;

	public function new(?X:Float = 0, ?Y:Float = 0,  graphic:FlxGraphicAsset, player:Player, statsString:String)
	{
		super(X, Y);
		acceleration.y = GRAVITY;
		maxVelocity.set(SPEED, 0);

		this.stats = StatFactory.getStats(statsString);
		this.health = stats.maxHealth;

		if (!TARGETS.contains(player)) {
			TARGETS.push(player);
		}

		healthBar = new FlxBar(X, Y - 20, FlxBarFillDirection.LEFT_TO_RIGHT, Math.floor(stats.maxHealth / 2), 10, this, "health", 0, stats.maxHealth);
		healthBar.createColoredFilledBar(FlxColor.RED);
		healthBar.trackParent(HEALTH_BAR_OFFSET_X, HEALTH_BAR_OFFSET_Y);
		FlxG.state.add(this.healthBar);

		loadGraphic(graphic, true, SPRITE_SIZE, SPRITE_SIZE);
		setGraphicSize(SPRITE_SIZE * 2, SPRITE_SIZE * 2);
		updateHitbox();
		offset.set(OFFSET_X, OFFSET_Y);
		width = WIDTH;
		height = HEIGHT;

		touching = FlxObject.DOWN;
	}

	private function initStates():Void {
		states[EnemyStates.IDLE.getIndex()] = new IdleState(this);
		states[EnemyStates.WALK.getIndex()] = new WalkState(this);
		states[EnemyStates.ATTACK.getIndex()] = stats.attackRange > 50 ? new RangedAttackState(this) : new MeleeAttackState(this);

		state = states[EnemyStates.IDLE.getIndex()];
		state.transitionIn();
	}

	private function handleStateTransitions():Void
	{
		var nextState:Int;
		do
		{
			nextState = state.getNextState();
			if (nextState != EnemyStates.NO_CHANGE.getIndex())
			{
				state.transitionOut();
				state = states[nextState];
				state.transitionIn();
			}
		}
		while (nextState != EnemyStates.NO_CHANGE.getIndex());
    }

    override public function update(elapsed:Float)
    {
        handleStateTransitions();
        state.update(elapsed);
        super.update(elapsed);
    }

	override public function hurt(damage:Float) {
		this.animation.play(HURT_ANIMATION);
		super.hurt(damage);
	}

	override public function kill() {
		super.kill();
		healthBar.kill();
	}

	public function checkAggro(target:FlxObject):Bool {
		var targetMid:FlxPoint = target.getMidpoint();
		var enemyMid:FlxPoint = this.getMidpoint();
		var distance:Float = Math.sqrt(Math.pow(targetMid.x - enemyMid.x, 2) + Math.pow(targetMid.y - enemyMid.y, 2));
		if (distance <= stats.aggroRange) {
			if (OBSTRUCTIONS.ray(enemyMid, targetMid)) {
				targetPosition = targetMid;
				return true;
			}
		}
		return false;
	}

	public static function addTarget(object:FlxObject):Void {
		if (!TARGETS.contains(object)) {
			TARGETS.push(object);
		}
	}

	public function attack():Void { throw new Exception("attack function not implemented");}
}