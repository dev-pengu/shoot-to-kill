package actors.player.fsm.states;

class JumpState extends AirState {

    public function new(player:Player) {
        super(player);
    }

    override public function handleInput(input:Input):Int {
        if (input.jumpJustReleased || managedPlayer.velocity.y >= 0) {
            return PlayerStates.FALLING.getIndex();
        }

        return super.handleInput(input);
    }

    override public function transitionIn():Void {
        this.managedPlayer.velocity.y = Player.JUMP_VELOCITY;
        this.managedPlayer.animation.play(Player.JUMP_ANIMATION);
    }

    override public function transitionOut():Void {
		if (this.managedPlayer.animation.name == Player.JUMP_ANIMATION)
		{
			this.managedPlayer.animation.stop();
		}
    }
}