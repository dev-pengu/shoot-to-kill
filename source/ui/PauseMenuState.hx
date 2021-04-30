package ui;

import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.FlxSubState;

class PauseMenuState extends FlxSubState {

    var closeBtn:FlxButton;
    var exitBtn:FlxButton;
    var restartBtn:FlxButton;

    public var isPersistent:Bool;

    override public function create():Void {
        super.create();

        closeBtn = new FlxButton(FlxG.width * 0.5 - 40, FlxG.height * 0.5, "Close", close);
        add(closeBtn);

        restartBtn = new FlxButton(closeBtn.x, closeBtn.y + 40, "Restart Level", restartLevel);
        add(restartBtn);

        #if desktop
		exitBtn = new FlxButton(restartBtn.x, restartBtn.y + 40, "Exit Game", exitGame);
        add(exitBtn);
        #end
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ESCAPE) {
            close();
        }
    }

    function restartLevel() {

    }

    #if desktop
    function exitGame() {
        Sys.exit(0);
    }
    #end
}