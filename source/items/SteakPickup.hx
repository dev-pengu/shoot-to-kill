package items;

import actors.player.Player;
import flixel.FlxG;
import flixel.FlxObject;

class SteakPickup extends ItemPickup {

    public function new(?X:Float = 0, ?Y:Float = 0) {
        super(X, Y, "steak", 1);
        animation.add(ItemPickup.IDLE_ANIMATION, [0], 1, false);
    }

    override public function pickup(player:Player):Void {
        player.heal(FlxG.random.int(10, 30));
        FlxG.sound.play(AssetPaths.Video_Game_Unlock_Sound_A1_8bit_www__fesliyanstudios__com__ogg, 0.5);
        this.kill();
    }

    override public function update(elapsed:Float):Void {
        if (isTouching(FlxObject.DOWN)) {
            this.acceleration.y = 0;
        }
        super.update(elapsed);
    }
}