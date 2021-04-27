package actors.player.fsm.states;

class ReloadState extends PlayerState {

    private var reloadTimer:Float;

    public function new(player:Player) {
        super(player);
        reloadTimer = this.managedPlayer.reloadTime;
    }

    override public function handleInput(input:Input):Int {
        return super.handleInput(input);
    }

    override public function transitionIn():Void {

    }

    override public function transitionOut():Void {

    }

    override public function update(elapsed:Float):Void {
        
    }
}