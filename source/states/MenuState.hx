package states;

import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;

class MenuState extends FlxState {

    var titleText:FlxText;
    var playBtn:FlxButton;
    var exitBtn:FlxButton;
    var background:FlxBackdrop;

    override public function create() {
		titleText = new FlxText(20, FlxG.height * 0.5 - 200, 0, "Shoot To Kill", 72);
        titleText.color = FlxColor.fromRGB(255, 255, 255, 255);
        titleText.alignment = CENTER;
        titleText.screenCenter(X);
        add(titleText);

		playBtn = new FlxButton(FlxG.width * 0.5 - 40, FlxG.height * 0.5, "Play", clickPlay);
        playBtn.setGraphicSize(150, 40);
        playBtn.label.size = 12;
		add(playBtn);

		#if desktop
		exitBtn = new FlxButton(playBtn.x, playBtn.y + 60, "Exit Game", exitGame);
		exitBtn.setGraphicSize(150, 40);
		exitBtn.label.size = 12;
		add(exitBtn);
		#end

        background = new FlxBackdrop(AssetPaths.sarah_lachise_88vFFj0xXxk_unsplash__jpg, 0, 0, false, false);
        background.alpha = 0.25;
        background.setGraphicSize(FlxG.width, FlxG.height);
        add(background);

        FlxG.sound.play(AssetPaths.menu_music__ogg, 0.5, true);

        super.create();
    }

    function clickPlay() {
        FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
			FlxG.switchState(new PlayState());
        });
    }

	#if desktop
	function exitGame()
	{
		Sys.exit(0);
	}
	#end
}