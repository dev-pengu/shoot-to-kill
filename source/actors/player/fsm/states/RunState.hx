package actors.player.fsm.states;

import flixel.FlxObject;

class RunState extends PlayerState {
    private var movementDirection:Int;

    public function new(player:Player) {
        super(player);
    }

    override public function handleInput(input:Input):Int {
        if (input.attackJustPressed) {
            return PlayerStates.ATTACKING.getIndex();
        }

		if ((input.reloadJustPressed && this.managedPlayer.roundsLeft < this.managedPlayer.rounds)) {
            return PlayerStates.RELOADING.getIndex();
        }

        if (input.jumpJustPressed) {
            return PlayerStates.JUMPING.getIndex();
        }

        if (input.downPressed) {
            return PlayerStates.CROUCHING.getIndex();
        }

        this.movementDirection = 0;
        if (input.leftPressed) {
            this.movementDirection = -1;
        }
        if (input.rightPressed) {
            this.movementDirection = 1;
        }

		if (movementDirection == 0)
		{
            managedPlayer.animation.play(Player.STAND_ANIMATION);
			return PlayerStates.STANDING.getIndex();
		} else {
            this.managedPlayer.facing = movementDirection == -1 ? FlxObject.LEFT : FlxObject.RIGHT;
            this.managedPlayer.flipX = this.managedPlayer.facing ==  FlxObject.LEFT;
        }

		if (!this.managedPlayer.isTouching(FlxObject.DOWN))
		{
			return PlayerStates.FALLING.getIndex();
		}

        return super.handleInput(input);
    }

	override public function update(elapsed:Float):Void {
        this.managedPlayer.velocity.x = Player.MAX_RUN_SPEED * movementDirection;
    }

    override public function transitionIn():Void {
        this.managedPlayer.animation.play(Player.RUN_ANIMATION);
    }
}