package actors.player.fsm.states;

import flixel.FlxObject;

class CrouchState extends PlayerState {
	private var movementDirection:Int;

    public function new(player:Player) {
        super(player);
    }

    override public function handleInput(input:Input):Int {
        movementDirection = 0;

		if (input.leftPressed)
		{
			this.movementDirection = -1;
		}
		if (input.rightPressed)
		{
			this.movementDirection = 1;
		}


        if (!input.downPressed) {
            return PlayerStates.STANDING.getIndex();
		} else {
			this.managedPlayer.facing = movementDirection == -1 ? FlxObject.LEFT : FlxObject.RIGHT;
			this.managedPlayer.flipX = this.managedPlayer.facing == FlxObject.LEFT;
		}

        return super.handleInput(input);
    }

    override public function update():Void {
		this.managedPlayer.velocity.x = Player.CROUCH_SPEED * movementDirection;
		if (movementDirection == 0)
		{
			this.managedPlayer.animation.play(Player.CROUCH_ANIMATION);
		}
		else
		{
			this.managedPlayer.animation.play(Player.CROUCH_MOVE_ANIMATION);
		}
    }

    override public function transitionIn():Void {
        this.managedPlayer.height = Player.CROUCH_HEIGHT;
        this.managedPlayer.y += Player.HIT_BOX_HEIGHT - Player.CROUCH_HEIGHT;
        this.managedPlayer.offset.y += Player.HIT_BOX_HEIGHT - Player.CROUCH_HEIGHT;

        this.managedPlayer.animation.play(Player.START_CROUCH_ANIMATION);
    }

    override public function transitionOut():Void {
        this.managedPlayer.height = Player.HIT_BOX_HEIGHT;
        this.managedPlayer.y -= Player.HIT_BOX_HEIGHT - Player.CROUCH_HEIGHT;
		this.managedPlayer.offset.y -= Player.HIT_BOX_HEIGHT - Player.CROUCH_HEIGHT;

        if (this.managedPlayer.animation.name == Player.CROUCH_ANIMATION || this.managedPlayer.animation.name == Player.CROUCH_MOVE_ANIMATION) {
            this.managedPlayer.animation.stop();
        }
    }
}