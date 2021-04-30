package items;

import flixel.FlxSprite;
import actors.player.Player;

interface I_PowerUp {

    public var data(default, null):PowerUpData;

    public function pickUp(player:Player):Void;
}

class PowerUpData {
	@:isVar public var name(default, null):String;
	@:isVar public var iconPath(default, null):String;

    public function new(name:String, iconPath:String) {
        this.name = name;
        this.iconPath = iconPath;
    }
}