package actors.player.fsm.states;

import flixel.FlxObject;

class AirState extends PlayerState {

    private var movementDirection:Int = 0;

    public function new(player:Player) {
        super(player);
    }

    override public function handleInput(input:Input):Int {
        if (this.managedPlayer.isTouching(FlxObject.DOWN) && this.managedPlayer.velocity.y >= 0) {
            return PlayerStates.STANDING.getIndex();
        }
        this.movementDirection = 0;
        if (input.leftPressed) {
            this.movementDirection = -1;
        }
        if (input.rightPressed) {
            this.movementDirection = 1;
        }

        return super.handleInput(input);
    }

	override public function update(elapsed:Float):Void {
        this.managedPlayer.velocity.x = Player.MAX_RUN_SPEED * movementDirection;
    }
}