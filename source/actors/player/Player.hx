package actors.player;

import actors.player.fsm.PlayerState;
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

    public static var JUMP_VELOCITY(default, never):Float = -200;
    public static var GRAVITY(default, never):Float = 400;

    private var input:Input;
    private var state:State;
    private var states:Vector<State> = new Vector<State>(5);

    public function new(?X:Float=0, ?Y:Float=0) {
        super(X, Y);
        acceleration.y = GRAVITY;
        maxVelocity.set(MAX_RUN_SPEED, MAX_Y_SPEED);

		loadGraphic(AssetPaths.Outlaw_sprite_sheet__png, true, 48, 48);
        setGraphicSize(96, 96);
        updateHitbox();
        offset.set(OFFSET_X, OFFSET_Y);
        width = HIT_BOX_WIDTH;
        height = HIT_BOX_HEIGHT;

        animation.add(STAND_ANIMATION, [0], 1, false);
        animation.add(RUN_ANIMATION, [1, 2, 3, 1, 4, 5], 10);
        animation.add(START_CROUCH_ANIMATION, [7, 8], 8, false);
        animation.add(CROUCH_ANIMATION, [8], 1, false);
        animation.add(CROUCH_MOVE_ANIMATION, [8, 9], 2, false);
        animation.add(JUMP_ANIMATION, [10, 11], 8, false);
        animation.add(FALL_ANIMATION, [12, 13, 14], 6, false);


        states[PlayerStates.STANDING.getIndex()] = new StandState(this);
        states[PlayerStates.RUNNING.getIndex()] = new RunState(this);
        states[PlayerStates.JUMPING.getIndex()] = new JumpState(this);
        states[PlayerStates.FALLING.getIndex()] = new FallState(this);
        states[PlayerStates.CROUCHING.getIndex()] = new CrouchState(this);

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

		input.rightJustReleased = FlxG.keys.justReleased.D;
		input.upJustReleased = FlxG.keys.justReleased.W;
		input.downJustReleased = FlxG.keys.justReleased.S;
		input.jumpJustReleased = FlxG.keys.justReleased.SPACE;
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
        state.update();

        super.update(elapsed);
    }
}