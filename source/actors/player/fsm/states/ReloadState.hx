package actors.player.fsm.states;

import flixel.FlxObject;
import flixel.FlxG;

class ReloadState extends PlayerState {

    private var reloadTimer:Float;
    private var movementDirection:Int;

    public function new(player:Player) {
        super(player);
    }

    override public function handleInput(input:Input):Int {
        if (this.managedPlayer.roundsLeft == this.managedPlayer.rounds) {
            return PlayerStates.STANDING.getIndex();
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
            if (this.managedPlayer.animation.finished || this.managedPlayer.animation.name != Player.IDLE_RELOAD_ANIMATION) {
                this.managedPlayer.animation.play(Player.IDLE_RELOAD_ANIMATION);
            }
		}  else {
            if (this.managedPlayer.animation.name != Player.WALK_RELOAD_ANIMATION) {
				managedPlayer.animation.play(Player.WALK_RELOAD_ANIMATION);
            }
            this.managedPlayer.facing = movementDirection == -1 ? FlxObject.LEFT : FlxObject.RIGHT;
            this.managedPlayer.flipX = this.managedPlayer.facing ==  FlxObject.LEFT;
        }

        if (!this.managedPlayer.isTouching(FlxObject.DOWN)) {
			return PlayerStates.FALLING.getIndex();
		}

        return super.handleInput(input);
    }

    override public function transitionIn():Void {
		reloadTimer = this.managedPlayer.reloadTime / this.managedPlayer.rounds;
        this.managedPlayer.playerSfx[Player.RELOADING_SOUND].play(true);
		this.managedPlayer.playerSfx[Player.WALKING_SOUND].play(true);
		this.managedPlayer.playerSfx[Player.WALKING_SOUND].fadeIn(0.25, 0, 0.25);
    }

    override public function transitionOut():Void {
        this.managedPlayer.animation.stop();
		this.managedPlayer.playerSfx[Player.WALKING_SOUND].stop();
		if (this.managedPlayer.playerSfx[Player.RELOADING_SOUND].playing) {
			this.managedPlayer.playerSfx[Player.RELOADING_SOUND].stop();
        }
    }

    override public function update(elapsed:Float):Void {
        if (movementDirection != 0) {
			this.managedPlayer.velocity.x = (Player.MAX_RUN_SPEED / 2) * movementDirection;
        }
        if (reloadTimer <= 0) {
            this.managedPlayer.roundsLeft++;
			reloadTimer = this.managedPlayer.reloadTime / this.managedPlayer.rounds;
        } else {
            reloadTimer -= elapsed;
        }
    }
}