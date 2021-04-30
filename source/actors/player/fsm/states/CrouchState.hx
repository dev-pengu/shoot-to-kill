package actors.player.fsm.states;

import flixel.FlxObject;
import flixel.math.FlxPoint;

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


        if (!input.downPressed && Player.OBSTRUCTIONS.ray(this.managedPlayer.getPosition(), FlxPoint.weak(this.managedPlayer.x, this.managedPlayer.y - 35))) {
            return PlayerStates.STANDING.getIndex();
		} else {
			if (movementDirection != 0) {
				this.managedPlayer.facing = movementDirection == -1 ? FlxObject.LEFT : FlxObject.RIGHT;
			}
			this.managedPlayer.flipX = this.managedPlayer.facing == FlxObject.LEFT;
		}

        return super.handleInput(input);
    }

	override public function update(elapsed:Float):Void {
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
        this.managedPlayer.resizeHitBox(Player.CROUCH_HEIGHT);

        this.managedPlayer.animation.play(Player.START_CROUCH_ANIMATION);
		this.managedPlayer.playerSfx[Player.WALKING_SOUND].play(true);
		this.managedPlayer.playerSfx[Player.WALKING_SOUND].fadeIn(0.25, 0, 0.25);
    }

    override public function transitionOut():Void {
        this.managedPlayer.height = Player.HIT_BOX_HEIGHT;
        this.managedPlayer.y -= Player.HIT_BOX_HEIGHT - Player.CROUCH_HEIGHT;
		this.managedPlayer.offset.y -= Player.HIT_BOX_HEIGHT - Player.CROUCH_HEIGHT;
		this.managedPlayer.playerSfx[Player.WALKING_SOUND].stop();
        if (this.managedPlayer.animation.name == Player.CROUCH_ANIMATION || this.managedPlayer.animation.name == Player.CROUCH_MOVE_ANIMATION) {
            this.managedPlayer.animation.stop();
        }
    }
}