package actors.player.fsm.states;

class FallState extends AirState {

    public function new(player:Player) {
        super(player);
    }

    override public function handleInput(input:Input):Int {
        return super.handleInput(input);
    }

    override public function transitionIn():Void {
        if (managedPlayer.velocity.y < 0) {
            managedPlayer.velocity.y = 0;
        }

        this.managedPlayer.animation.play(Player.FALL_ANIMATION);
    }

    override public function transitionOut():Void {
        if (this.managedPlayer.animation.name == Player.FALL_ANIMATION) {
            this.managedPlayer.animation.stop();
        }
    }
}