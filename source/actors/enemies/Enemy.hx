package actors.enemies;


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
	public static var TARGETS(default, null):Array<FlxObject> = new Array<FlxObject>();

	public static var IDLE_ANIMATION(default, never):String = "idle";
	public static var WALK_ANIMATION(default, never):String = "walk";
	public static var HURT_ANIMATION(default, never):String = "hurt";
	public static var ATTACK_ANIMATION(default, never):String = "attack";

	private var state:State;
	private var states:Vector<State> = new Vector<State>(4);
	private var healthBar:FlxBar;
	private var maxHealth:Float;
	private var aggroRange:Float;
	private var attackSpeed:Float;
	private var reloadTime:Float;
	private var rounds:Int;
	private var targetPosition:FlxPoint;
	private var attackRange:Float;

	public function new(?X:Float = 0, ?Y:Float = 0, ?maxHealth:Float=100, graphic:FlxGraphicAsset, attackRange:Float, attackSpeed:Float, aggroRange:Float, ?rounds:Int = 0, ?reloadTime:Float = 0)
	{
		super(X, Y);
		acceleration.y = GRAVITY;
		maxVelocity.set(SPEED, 0);

		this.maxHealth = maxHealth;
		this.health = maxHealth;
		this.attackRange = attackRange;
		this.attackSpeed = attackSpeed;
		this.aggroRange = aggroRange;
		this.rounds = rounds;
		this.reloadTime = reloadTime;
		healthBar = new FlxBar(X, Y - 20, FlxBarFillDirection.LEFT_TO_RIGHT, Math.floor(maxHealth / 2), 10, this, "health", 0, maxHealth);
		healthBar.createColoredFilledBar(FlxColor.RED);
		FlxG.state.add(this.healthBar);

		loadGraphic(graphic, true, SPRITE_SIZE, SPRITE_SIZE);
		setGraphicSize(SPRITE_SIZE * 2, SPRITE_SIZE * 2);
		updateHitbox();
		offset.set(OFFSET_X, OFFSET_Y);
		width = WIDTH;
		height = HEIGHT;

		touching = FlxObject.DOWN;

		states[EnemyStates.IDLE.getIndex()] = new IdleState(this);
		states[EnemyStates.WALK.getIndex()] = new WalkState(this);
		states[EnemyStates.ATTACK.getIndex()] = attackRange > 50 ? new RangedAttackState(this) : new MeleeAttackState(this);

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
		healthBar.x = this.x;
		healthBar.y = this.y - 20;
        super.update(elapsed);
    }

	override public function hurt(damage:Float) {
		this.animation.play(HURT_ANIMATION);
		super.hurt(damage);
	}

	public function checkAggro(target:FlxObject):Bool {
		var targetMid:FlxPoint = target.getMidpoint();
		var enemyMid:FlxPoint = this.getMidpoint();
		var distance:Float = Math.sqrt(Math.pow(targetMid.x - enemyMid.x, 2) + Math.pow(targetMid.y - enemyMid.y, 2));
		if (distance <= aggroRange) {
			if (OBSTRUCTIONS.ray(enemyMid, targetMid)) {
				targetPosition = targetMid;
				return true;
			}
		}
		return false;
	}

	public function getAttackSpeed():Float { return attackSpeed; }
	public function getReloadTime():Float { return reloadTime; }
	public function getRounds():Int { return rounds; }
	public function getTargetPosition():FlxPoint { return targetPosition; }

	public static function addTarget(object:FlxObject):Void {
		TARGETS.push(object);
	}

	public function attack():Void { throw new Exception("attack function not implemented");}
}