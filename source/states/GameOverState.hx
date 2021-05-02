package states;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxAxes;

class GameOverState extends FlxState {

    var score:Int = 0;
    var win:Bool;
    var titleText:FlxText;
    var messageText:FlxText;
    var scoreIcon:FlxSprite;
    var scoreText:FlxText;
    var mainMenuButton:FlxButton;

    public function new(win:Bool, score:Int) {
        super();
        this.win = win;
        this.score = score;
    }

    override public function create() {
        #if FLX_MOUSE
        FlxG.mouse.visible = true;
        #end

        titleText = new FlxText(0, FlxG.height * 0.5 - 200, 0, win ? "You Win!" : "Game Over!", 56);
        titleText.alignment = CENTER;
        titleText.screenCenter(FlxAxes.X);
        add(titleText);

        messageText = new FlxText(0, FlxG.height * 0.5 - 18, 0, "Final Score:", 8);
        messageText.alignment = CENTER;
        messageText.screenCenter(FlxAxes.X);
        //add(messageText);

        scoreIcon = new FlxSprite(FlxG.width * 0.5 - 8, 0, null);
        scoreIcon.screenCenter(FlxAxes.Y);
        //add(scoreIcon);

        scoreText = new FlxText(FlxG.width * 0.5, 0, 0, Std.string(score), 12);
        scoreText.screenCenter(FlxAxes.Y);
        //add(scoreText);

        mainMenuButton = new FlxButton(0, FlxG.height * 0.5 + 60, "Main Menu", switchToMainMenu);
        mainMenuButton.screenCenter(FlxAxes.X);
        mainMenuButton.onUp.sound = FlxG.sound.load(AssetPaths.Video_Game_Unlock_Sound_A1_8bit_www__fesliyanstudios__com__ogg);
		mainMenuButton.setGraphicSize(180, 40);
        add(mainMenuButton);

        FlxG.camera.fade(FlxColor.BLACK, 0.33, true);

        if (win) {
			FlxG.sound.play(AssetPaths.menu_music__ogg, 0.5, true);
        } else {
            FlxG.sound.play(AssetPaths.game_over_music__ogg, 0.5, true);
        }

        super.create();
    }

    private function switchToMainMenu() {
        FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function() {
            FlxG.switchState(new MenuState());
        });
    }
}