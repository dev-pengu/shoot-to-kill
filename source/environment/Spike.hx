package environment;

import flixel.FlxObject;
import flixel.FlxSprite;

class Spike extends FlxSprite {

	private static var SPRITE_SIZE:Int = 32;
    private static var DAMAGE:Int = 20;

    public function new(?x:Float=0, ?y:Float=0) {
        super(x,y);

		loadGraphic(AssetPaths.spikes__png, false, SPRITE_SIZE, SPRITE_SIZE);
		immovable = true;
    }

    public function doDamage(object:FlxObject) {
        object.hurt(DAMAGE);
    }
}