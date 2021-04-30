package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.tile.FlxTilemap;
import flixel.system.FlxSound;
import flixel.FlxSprite;

import ui.Hud;

class LevelGlobals {

    public static var ambienceTrack:FlxSound;
    public static var hudReference:Hud;

    public static var currentState:FlxState;
    public static var tileMap:FlxTilemap;

    public static var deltaTime:Float = 0;
    public static var totalElapsed:Float = 0;

	public static  function init() {
        FlxG.sound.music = null;
        ambienceTrack = new FlxSound();
        hudReference = new Hud(null);
        currentState = new FlxState();
        tileMap = new FlxTilemap();
        deltaTime = 0;
        totalElapsed = 0;
    }

	public static  function screenOptimization(object:FlxSprite) {
        #if debug
        object.ignoreDrawDebug = object.isOnScreen();
        #end

        if (totalElapsed > 2000) {
            var outsideX = object.getScreenPosition().x < (-96) || object.getScreenPosition().x > (FlxG.camera.width + 96);
            var outsideY = object.getScreenPosition().y < (-96) || object.getScreenPosition().y > (FlxG.camera.height + 96);

            object.exists = !(outsideX || outsideY);
        }
    }
}