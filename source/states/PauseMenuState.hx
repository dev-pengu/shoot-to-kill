package states;

import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.util.FlxColor;

class PauseMenuState extends FlxSubState {

    var closeBtn:FlxButton;
    var exitBtn:FlxButton;
    var restartBtn:FlxButton;
    var exitToMenuBtn:FlxButton;

    public var isPersistent:Bool;

    override public function create():Void {
		#if FLX_MOUSE
		FlxG.mouse.visible = true;
		#end

		_bgSprite.makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(0, 0, 0, 200));

		closeBtn = new FlxButton(FlxG.width * 0.5 - 40, FlxG.height * 0.5, "Close", close);
		closeBtn.setGraphicSize(150, 40);
		add(closeBtn);

		restartBtn = new FlxButton(closeBtn.x, closeBtn.y + 60, "Restart Level", restartLevel);
		restartBtn.setGraphicSize(150, 40);
		add(restartBtn);

        exitToMenuBtn = new FlxButton(restartBtn.x, restartBtn.y + 60, "Exit to Menu", switchToMainMenu);
		exitToMenuBtn.setGraphicSize(150, 40);
        add(exitToMenuBtn);

		#if desktop
		exitBtn = new FlxButton(exitToMenuBtn.x, exitToMenuBtn.y + 60, "Exit Game", exitGame);
		exitBtn.setGraphicSize(150, 40);
		add(exitBtn);
		#end

        super.create();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ESCAPE) {
            close();
        }
    }

    function restartLevel() {
        FlxG.resetState();
    }

    function switchToMainMenu() {
        FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
            FlxG.switchState(new MenuState());
        });
    }

    #if desktop
    function exitGame() {
        Sys.exit(0);
    }
    #end
}