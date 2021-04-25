package actors.player.fsm;

interface State {
    public function handleInput(input:Input):Int;
    public function update():Void;
    public function transitionIn():Void;
    public function transitionOut():Void;
}