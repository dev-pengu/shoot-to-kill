package actors.player.fsm.states;

class DoubleJumpState extends AirState {

    public function new(player:Player) {
        super(player);
    }

    override public function handleInput(input:Input):Int {
        if (input.attackJustPressed && this.managedPlayer.powerUps.contains("jumpShot")) {
            return PlayerStates.JUMP_ATTACKING.getIndex();
        }
        
        if (input.jumpJustReleased || managedPlayer.velocity.y >= 0) {
            return PlayerStates.FALLING.getIndex();
        }

        return super.handleInput(input);
    }

    override public function transitionIn():Void {
        this.managedPlayer.velocity.y = Player.JUMP_VELOCITY * .75;
        this.managedPlayer.animation.play(Player.JUMP_ANIMATION);
        this.managedPlayer.playerSfx[Player.JUMPING_SOUND].play(true);
    }

    override public function transitionOut():Void {
        if (this.managedPlayer.animation.name == Player.JUMP_ANIMATION) {
            this.managedPlayer.animation.stop();
        }
    }
}