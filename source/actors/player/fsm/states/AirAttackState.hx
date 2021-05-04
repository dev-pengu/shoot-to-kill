package actors.player.fsm.states;

import flixel.FlxObject;

class AirAttackState extends AirState {

    public function new(player:Player) {
        super(player);
    }

    override public function handleInput(input:Input):Int {
        if (this.managedPlayer.animation.name == Player.JUMP_ATTACK_ANIMATION && !this.managedPlayer.animation.finished) {
            return PlayerStates.NO_CHANGE.getIndex();
        }

        if (input.attackJustPressed && this.managedPlayer.roundsLeft > 0 && !this.managedPlayer.isTouching(FlxObject.DOWN)) {
            return PlayerStates.NO_CHANGE.getIndex();
        }

        if (this.managedPlayer.animation.name == Player.JUMP_ATTACK_ANIMATION && this.managedPlayer.animation.finished) {
            return PlayerStates.FALLING.getIndex();
        }
        return super.handleInput(input);
    }

    override public function update(elapsed:Float):Void {
		super.update(elapsed);
        if (this.managedPlayer.roundsLeft > 0) {
            if (this.managedPlayer.attackTimer <= 0) {
                this.managedPlayer.flipX = this.managedPlayer.facing == FlxObject.LEFT;
                this.managedPlayer.animation.play(Player.JUMP_ATTACK_ANIMATION);
                this.managedPlayer.attack();

				this.managedPlayer.attackTimer = (60 / this.managedPlayer.attackSpeed) / 60;
            }
        }

    }
}