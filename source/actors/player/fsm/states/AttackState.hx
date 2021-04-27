package actors.player.fsm.states;

import flixel.FlxObject;

class AttackState extends PlayerState {

    private var attackTimer:Float;

	public function new(player:Player) {
		super(player);
        attackTimer = 0;
        this.managedPlayer.roundsLeft = this.managedPlayer.rounds;
	}

    // The player will not be able to cancel their attack once it has started
    override public function handleInput(input:Input):Int {
        if (input.attackPressed && this.managedPlayer.roundsLeft > 0) {
            return PlayerStates.NO_CHANGE.getIndex();
        }

        if (((input.reloadJustPressed && this.managedPlayer.roundsLeft < this.managedPlayer.rounds) || this.managedPlayer.roundsLeft == 0) && this.managedPlayer.animation.finished) {
            return PlayerStates.RELOADING.getIndex();
        }

        if (this.managedPlayer.animation.finished && this.managedPlayer.animation.name == Player.ATTACK_ANIMATION && !input.attackPressed) {
            return PlayerStates.STANDING.getIndex();
        }
        return super.handleInput(input);
    }

    override public function transitionIn():Void {
        this.managedPlayer.drag.x = Player.STANDING_DECELERATION;

		if (this.managedPlayer.animation.finished || this.managedPlayer.animation.name == Player.RUN_ANIMATION) {
			this.managedPlayer.animation.play(Player.STAND_ANIMATION);
		}
    }

    override public function transitionOut():Void {
        this.managedPlayer.drag.x = 0;
    }

    override public function update(elapsed:Float):Void {
        if (this.managedPlayer.roundsLeft > 0) {
            if (attackTimer <= 0) {
				this.managedPlayer.flipX = this.managedPlayer.facing == FlxObject.LEFT;
                this.managedPlayer.animation.play(Player.ATTACK_ANIMATION);
                this.managedPlayer.attack();

                attackTimer = (60 / this.managedPlayer.attackSpeed) / 60;
            } else {
                attackTimer -= elapsed;
            }
        }
    }
}