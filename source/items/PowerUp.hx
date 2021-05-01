package items;

import flixel.FlxG;
import items.PowerUpAD.PowerUpData;
import actors.player.Player;
import items.PowerUpAD.I_PowerUp;
import flixel.FlxSprite;

class PowerUp extends FlxSprite implements I_PowerUp {

    public var data(default, null):PowerUpData;

    public function new(?x:Float=0, ?y:Float=0, name:String) {
        super(x,y);
		data = PowerUpFactory.getPowerUpData(name);
        loadGraphic(data.iconPath, false, 32, 32);
    }

    public function pickUp(player:Player):Void {
        player.addPowerUp(this);
        FlxG.sound.play(AssetPaths.Video_Game_Unlock_Sound_A1_8bit_www__fesliyanstudios__com__ogg, .25);
        this.kill();
    }

}