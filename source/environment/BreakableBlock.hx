package environment;

import flixel.FlxSprite;

class BreakableBlock extends Explodable {

    private static var SPRITE_SIZE:Int = 32;
    private static var BREAKING_ANIMATION:String = "break";
    private static var IDLE_ANIMATION:String = "idle";

    public function new(?x:Float=0, ?y:Float=0) {
        super(x,y);

		loadGraphic(AssetPaths.Tilesheet__png, true, SPRITE_SIZE, SPRITE_SIZE);
		this.animation.add(IDLE_ANIMATION, [15], 1, false);
        this.animation.add(BREAKING_ANIMATION, [16, 17, 18], 6, false);
        immovable = true;
        this.animation.play(IDLE_ANIMATION);
    }

    public function explode() {
		this.animation.play(BREAKING_ANIMATION);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        if (this.animation.name == BREAKING_ANIMATION && this.animation.finished) {
            this.kill();
        }
    }
}