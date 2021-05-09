package items;

import actors.player.Player;
import flixel.FlxG;

class TntPickup extends ItemPickup {

	public function new(?X:Float = 0, ?Y:Float = 0, ?numItems:Int = 1) {
        super(X,Y, "tnt", numItems);
		animation.add(ItemPickup.IDLE_ANIMATION, numItems > 1 ? [5] : [0], 1, false);
        animation.play(ItemPickup.IDLE_ANIMATION);
    }

    override public function pickup(player:Player):Void {
		player.tntCount += numItems;
        FlxG.sound.play(AssetPaths.Video_Game_Unlock_Sound_A1_8bit_www__fesliyanstudios__com__ogg, 0.5);
        this.kill();
    }
}