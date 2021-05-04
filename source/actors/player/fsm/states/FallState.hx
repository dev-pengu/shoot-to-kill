package actors.player.fsm.states;

import flixel.FlxObject;

class FallState extends AirState {

    public function new(player:Player) {
        super(player);
    }

    override public function handleInput(input:Input):Int {
        if (input.attackJustPressed && this.managedPlayer.powerUps.contains("jumpShot")) {
            return PlayerStates.JUMP_ATTACKING.getIndex();
        }
        
        if (input.jumpJustPressed && this.managedPlayer.airJumps > 0 && this.managedPlayer.powerUps.contains("doubleJump")) {
            this.managedPlayer.airJumps--;
            return PlayerStates.DOUBLE_JUMPING.getIndex();
        }
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
		if (this.managedPlayer.isTouching(FlxObject.DOWN)) {
            this.managedPlayer.playerSfx[Player.LANDING_SOUND].play(true);
        }
    }
}