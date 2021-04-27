package actors.player;

import actors.player.fsm.states.ReloadState;
import actors.player.fsm.states.AttackState;
import items.Bullet;
import flixel.group.FlxGroup.FlxTypedGroup;
import ui.Hud;
import actors.player.fsm.states.CrouchState;
import actors.player.fsm.states.FallState;
import actors.player.fsm.states.JumpState;
import actors.player.fsm.states.RunState;
import actors.player.fsm.states.StandState;
import actors.player.fsm.PlayerStates;
import haxe.ds.Vector;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import actors.player.Input;
import actors.player.fsm.State;

class Player extends FlxSprite {
	public static var HIT_BOX_WIDTH(default, never):Int = 20;
	public static var HIT_BOX_HEIGHT(default, never):Int = 60;
    public static var SPRITE_SIZE(default, never):Int = 48;
	public static var CROUCH_HEIGHT(default, never):Float = 32;
    public static var OFFSET_X(default, never):Int = 14;
    public static var OFFSET_Y(default, never):Int = 12;

    public static var MAX_RUN_SPEED(default, never):Float = 150;
    public static var MAX_Y_SPEED(default, never):Float = 300;
    public static var STANDING_DECELERATION(default, never):Float = 700;
    public static var CROUCH_SPEED(default, never):Float = 60;

    public static var STAND_ANIMATION(default, never):String = "stand";
    public static var RUN_ANIMATION(default, never):String = "run";
    public static var START_CROUCH_ANIMATION(default, never):String = "startCrouch";
    public static var CROUCH_ANIMATION(default, never):String = "crouch";
    public static var CROUCH_MOVE_ANIMATION(default, never):String = "crouchMove";
    public static var JUMP_ANIMATION(default, never):String = "jump";
    public static var FALL_ANIMATION(default, never):String = "fall";
    public static var ATTACK_ANIMATION(default, never):String = "attack";
    public static var IDLE_RELOAD_ANIMATION(default, never):String = "reload";
    public static var WALK_RELOAD_ANIMATION(default, never):String = "walkReload";

    public static var JUMP_VELOCITY(default, never):Float = -200;
    public static var GRAVITY(default, never):Float = 400;

	public static var BULLETS(default, null):FlxTypedGroup<Bullet> = new FlxTypedGroup<Bullet>();
	public static var BULLET_SPAWN_OFFSET_X(default, never):Float = -5;
	public static var BULLET_SPAWN_OFFSET_Y(default, never):Float = 22;
	public static var BULLET_SPEED(default, never):Float = 150;

    private var input:Input;
    private var state:State;
    private var states:Vector<State> = new Vector<State>(8);
    private var playerHud:Hud;

    @:isVar public var maxHealth(get, null):Float = 100;
    @:isVar public var rounds(get, null):Int = 4;
    @:isVar public var roundsLeft(get, set):Int;
    @:isVar public var reloadTime(get, null):Float = 3;
    @:isVar public var attackSpeed(get, null):Float = 0.75;
    @:isVar public var attackDamage(get, null):Float = 10;
    @:isVar public var baseRange(get, null):Float = 400;
    @:isVar public var critChance(get, set):Float = 0;

    public function new(?X:Float=0, ?Y:Float=0) {
        super(X, Y);
        acceleration.y = GRAVITY;
        maxVelocity.set(MAX_RUN_SPEED, MAX_Y_SPEED);

		this.health = maxHealth;
        playerHud = new Hud(maxHealth, this);

		loadGraphic(AssetPaths.Outlaw_sprite_sheet__png, true, 48, 48);
        setGraphicSize(96, 96);
        updateHitbox();
        offset.set(OFFSET_X, OFFSET_Y);
        width = HIT_BOX_WIDTH;
        height = HIT_BOX_HEIGHT;

        animation.add(STAND_ANIMATION, [0], 1, false);
        animation.add(RUN_ANIMATION, [1, 2, 3, 1, 4, 5], 8);
        animation.add(START_CROUCH_ANIMATION, [7, 8], 6, false);
        animation.add(CROUCH_ANIMATION, [8], 1, false);
        animation.add(CROUCH_MOVE_ANIMATION, [8, 9], 2, false);
        animation.add(JUMP_ANIMATION, [10, 11], 8, false);
        animation.add(FALL_ANIMATION, [12, 13, 14], 6, false);
        animation.add(ATTACK_ANIMATION, [0, 15, 16, 17, 18], 10, false);
        animation.add(IDLE_RELOAD_ANIMATION, [19], 1, false);
        animation.add(WALK_RELOAD_ANIMATION, [20, 21, 22, 23, 24, 25], 8);


        states[PlayerStates.STANDING.getIndex()] = new StandState(this);
        states[PlayerStates.RUNNING.getIndex()] = new RunState(this);
        states[PlayerStates.JUMPING.getIndex()] = new JumpState(this);
        states[PlayerStates.FALLING.getIndex()] = new FallState(this);
        states[PlayerStates.CROUCHING.getIndex()] = new CrouchState(this);
        states[PlayerStates.ATTACKING.getIndex()] = new AttackState(this);
        states[PlayerStates.RELOADING.getIndex()] = new ReloadState(this);

		touching = FlxObject.DOWN;
		input = new Input();

        state = states[PlayerStates.STANDING.getIndex()];
        state.transitionIn();
    }

    private inline function updateInput():Void{

        input.leftJustPressed = FlxG.keys.justPressed.A;
        input.rightJustPressed = FlxG.keys.justPressed.D;
        input.upJustPressed = FlxG.keys.justPressed.W;
        input.downJustPressed = FlxG.keys.justPressed.S;
        input.jumpJustPressed = FlxG.keys.justPressed.SPACE;

        input.leftPressed = FlxG.keys.pressed.A;
		input.rightPressed = FlxG.keys.pressed.D;
		input.upPressed = FlxG.keys.pressed.W;
		input.downPressed = FlxG.keys.pressed.S;
		input.jumpPressed = FlxG.keys.pressed.SPACE;

        input.leftJustReleased = FlxG.keys.justReleased.A;
		input.rightJustReleased = FlxG.keys.justReleased.D;
		input.upJustReleased = FlxG.keys.justReleased.W;
		input.downJustReleased = FlxG.keys.justReleased.S;
		input.jumpJustReleased = FlxG.keys.justReleased.SPACE;

        input.attackJustPressed = FlxG.mouse.justPressed;
        input.attackPressed = FlxG.mouse.pressed;
        input.attackJustReleased = FlxG.mouse.justReleased;

        input.reloadJustPressed = FlxG.keys.justPressed.R;
    }

    private function applyInputAndTransition() {
        var nextState:Int;
        do {
            nextState = state.handleInput(input);
            if (nextState != PlayerStates.NO_CHANGE.getIndex()) {
                state.transitionOut();
                state = states[nextState];
                state.transitionIn();
            }
        } while (nextState != PlayerStates.NO_CHANGE.getIndex());
    }

    override public function update(elapsed:Float) {
        updateInput();
        applyInputAndTransition();
        state.update(elapsed);

        super.update(elapsed);
    }

    public function attack():Void {
        var bullet:Bullet = BULLETS.recycle(Bullet);
        if (this.facing == FlxObject.RIGHT) {
            bullet.setPosition(this.x + SPRITE_SIZE + BULLET_SPAWN_OFFSET_X, this.y + BULLET_SPAWN_OFFSET_Y);
            bullet.setParams(BULLET_SPEED, 1, baseRange, (isAttackCrit() ? attackDamage * 1.75 : attackDamage));
        } else {
            bullet.setPosition(this.x - BULLET_SPAWN_OFFSET_X, this.y + BULLET_SPAWN_OFFSET_Y);
			bullet.setParams(BULLET_SPEED, -1, baseRange, (isAttackCrit() ? attackDamage * 1.75 : attackDamage));
        }
        bullet.fire();
        roundsLeft--;
    }

    private function isAttackCrit():Bool {
        if (roundsLeft == 1) {
            return true;
        }
        return FlxG.random.float(0,1, [0]) <= critChance;
    }

    function get_maxHealth() return maxHealth;
    function get_rounds() return rounds;
    function get_roundsLeft() return roundsLeft;
    function set_roundsLeft(value:Int) return this.roundsLeft = value;
    function get_reloadTime() return reloadTime;
    function get_attackSpeed() return attackSpeed;
    function get_attackDamage() return attackDamage;
    function get_baseRange() return baseRange;
    function get_critChance() return critChance;
    function set_critChance(value:Float) return this.critChance = value;
}