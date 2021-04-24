package actors.enemies;

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

class Enemy extends FlxSprite
{
	public static var SPEED(default, never):Float = 50;
	public static var WALLS(default, null):FlxTilemap;
	public static var GRAVITY(default, never):Float = 400;
	public static var OFFSET_X(default, never):Int = 20;
	public static var OFFSET_Y(default, never):Int = 20;
	public static var WIDTH(default, never):Int = 8;
	public static var HEIGHT(default, never):Int = 28;

	public static var IDLE_ANIMATION(default, never):String = "idle";
	public static var WALK_ANIMATION(default, never):String = "walk";

	private var state:State;
	private var states:Vector<State> = new Vector<State>(3);

	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		super(X, Y);
		acceleration.y = GRAVITY;
		maxVelocity.set(SPEED, 0);

		makeGraphic(32, 16);
		offset.set(OFFSET_X, OFFSET_Y);
		width = WIDTH;
		height = HEIGHT;

		touching = FlxObject.DOWN;

		states[EnemyStates.IDLE.getIndex()] = new IdleState(this);
		states[EnemyStates.WALK.getIndex()] = new WalkState(this);

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
}