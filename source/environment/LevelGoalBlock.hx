package environment;

import flixel.FlxObject;
import flixel.FlxSprite;

class LevelGoalBlock extends BreakableBlock {

    public function new(?x:Float=0, ?y:Float=0) {
        super(x,y);
        this.visible = false;
        this.active = false;
        this.allowCollisions = FlxObject.NONE;
    }

    public function activate() {
        this.visible = true;
        this.active = true;
        this.allowCollisions = FlxObject.ANY;
    }

    override private function initGraphics():Void {
		loadGraphic(AssetPaths.Tilesheet__png, true, BreakableBlock.SPRITE_SIZE, BreakableBlock.SPRITE_SIZE);
		this.animation.add(BreakableBlock.IDLE_ANIMATION, [19], 1, false);
		this.animation.add(BreakableBlock.BREAKING_ANIMATION, [20, 21, 22], 6, false);
    }
}