package actors.player;

import items.PowerUp;
import actors.player.fsm.states.DoubleJumpState;
import flixel.system.FlxSound;
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
import flixel.tile.FlxTilemap;

class Player extends FlxSprite {
	public static var HIT_BOX_WIDTH(default, never):Int = 20;
	public static var HIT_BOX_HEIGHT(default, never):Int = 60;
    public static var SPRITE_SIZE(default, never):Int = 48;
	public static var CROUCH_HEIGHT(default, never):Float = 32;
    public static var JUMP_HEIGHT(default, never):Float = 55;
    public static var OFFSET_X(default, never):Int = 14;
    public static var OFFSET_Y(default, never):Int = 12;
	public static var OBSTRUCTIONS(default, default):FlxTilemap;

    public static var RUNNING_SOUND(default, never):String = "run";
    public static var RELOADING_SOUND(default, never):String = "reload";
    public static var FIRING_GUN_SOUND(default, never):String = "gunshot";
    public static var LANDING_SOUND(default, never):String = "land";
    public static var JUMPING_SOUND(default, never):String = "jump";
    public static var WALKING_SOUND(default, never):String = "walk";

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
    public static var HURT_ANIMATION(default, never):String = "hurt";

    public static var JUMP_VELOCITY(default, never):Float = -275;
    public static var GRAVITY(default, never):Float = 400;
	private static var INVINCIBLE_TIME:Float = 1;

	public static var BULLETS(default, null):FlxTypedGroup<Bullet> = new FlxTypedGroup<Bullet>();
	public static var BULLET_SPAWN_OFFSET_X(default, never):Float = -5;
	public static var BULLET_SPAWN_OFFSET_Y(default, never):Float = 20;
	public static var BULLET_SPEED(default, never):Float = 150;

    private var input:Input;
    private var state:State;
    private var states:Vector<State> = new Vector<State>(9);
    private var invincibleTimer:Float = 0;

    @:isVar public var powerUps(default, null):Array<String>;
    @:isVar public var maxAirJumps(default, null):Int = 1;
    @:isVar public var playerSfx(default, null):Map<String, FlxSound>;
    @:isVar public var airJumps(default, default):Int;
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

		loadGraphic(AssetPaths.Outlaw_sprite_sheet__png, true, 48, 48);
        setGraphicSize(96, 96);
		this.offset.set(OFFSET_X, OFFSET_Y);
		this.width = HIT_BOX_WIDTH;
		this.height = HIT_BOX_HEIGHT;
        airJumps = 1;
        powerUps = new Array<String>();


        animation.add(STAND_ANIMATION, [0], 1, false);
        animation.add(RUN_ANIMATION, [1, 2, 3, 1, 4, 5], 8);
        animation.add(START_CROUCH_ANIMATION, [7, 8], 6, false);
        animation.add(CROUCH_ANIMATION, [8], 1, false);
        animation.add(CROUCH_MOVE_ANIMATION, [8, 9], 2, false);
        animation.add(JUMP_ANIMATION, [10, 11], 8, false);
        animation.add(FALL_ANIMATION, [12, 13, 14], 6, false);
        animation.add(ATTACK_ANIMATION, [0, 15, 16, 17, 18], 15, false);
        animation.add(IDLE_RELOAD_ANIMATION, [19], 1, false);
        animation.add(WALK_RELOAD_ANIMATION, [20, 21, 22, 23, 24, 25], 8);


        states[PlayerStates.STANDING.getIndex()] = new StandState(this);
        states[PlayerStates.RUNNING.getIndex()] = new RunState(this);
        states[PlayerStates.JUMPING.getIndex()] = new JumpState(this);
        states[PlayerStates.FALLING.getIndex()] = new FallState(this);
        states[PlayerStates.CROUCHING.getIndex()] = new CrouchState(this);
        states[PlayerStates.ATTACKING.getIndex()] = new AttackState(this);
        states[PlayerStates.RELOADING.getIndex()] = new ReloadState(this);
        states[PlayerStates.DOUBLE_JUMPING.getIndex()] = new DoubleJumpState(this);

		touching = FlxObject.DOWN;
		input = new Input();
        playerSfx = new Map<String, FlxSound>();

        buildSoundMap();

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

    private function buildSoundMap():Void {
        playerSfx[RUNNING_SOUND] = FlxG.sound.load(AssetPaths.Running_on_Gravel_www__fesliyanstudios__com__mp3, 0.25, true);
        playerSfx[RELOADING_SOUND] = FlxG.sound.load(AssetPaths.Loading_and_chambering_gun_www__fesliyanstudios__com__mp3, 0.5);
        playerSfx[WALKING_SOUND] = FlxG.sound.load(AssetPaths.Walking_on_Gravel__Slow__A2_www__fesliyanstudios__com__mp3, 0.25, true);
        playerSfx[FIRING_GUN_SOUND] = FlxG.sound.load(AssetPaths.Beefy_Desert_Eagle___50_AE_Close_Single_Gunshot_A_www__fesliyanstudios__com_www__fesliyanstudios__com__mp3, 0.35);
        playerSfx[JUMPING_SOUND] = FlxG.sound.load(AssetPaths.jump_start__wav, 0.35);
        playerSfx[LANDING_SOUND] = FlxG.sound.load(AssetPaths.jump_land__wav, 0.35);
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

        if (invincibleTimer > 0) {
            invincibleTimer -= elapsed;
        }
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
        playerSfx[FIRING_GUN_SOUND].play(true);
        bullet.fire();
        roundsLeft--;
    }

    private function isAttackCrit():Bool {
        if (roundsLeft == 1) {
            return true;
        }
        return FlxG.random.float(0,1, [0]) <= critChance;
    }

    public function resizeHitBox(?heightAdjustment:Float, ?moveY:Bool=true, ?sizeUp:Bool=false) {
		if (heightAdjustment == null) {
            heightAdjustment = HIT_BOX_HEIGHT;
        }
        this.height = heightAdjustment;
        if (moveY) {
            this.y += HIT_BOX_HEIGHT - heightAdjustment;
            this.offset.y += (HIT_BOX_HEIGHT - heightAdjustment);
        }
    }

    override public function hurt(damage:Float) {
        if (invincibleTimer <= 0) {
            super.hurt(damage);
            invincibleTimer = INVINCIBLE_TIME;
            //this.animation.play(HURT_ANIMATION);
        }
    }

    public function addPowerUp(powerUp:PowerUp):Bool {
        if (!powerUps.contains(powerUp.data.name)) {
            powerUps.push(powerUp.data.name);
            return true;
        }
        return false;
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