package actors.player.fsm;

import actors.player.Player;
import actors.player.fsm.State;

class PlayerState implements State {
    private var managedPlayer:Player;

    public function new(player:Player) {
        this.managedPlayer = player;
    }

    public function handleInput(input:Input):Int {
        return PlayerStates.NO_CHANGE.getIndex();
    }

    public function update(elapsed:Float):Void {}
    public function transitionIn():Void {}
    public function transitionOut():Void {}
}