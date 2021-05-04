package items;

import environment.HitBox;
import actors.player.Player;

interface I_UsableItem {
    public var data(default, null):ItemData;
    private var hitBox:HitBox;

    public function use():Void;
	public function pickup(player:Player):Void;
}

class ItemData {
	@:isVar public var name(default, null):String;
	@:isVar public var iconPath(default, null):String;
	@:isVar public var pickupMessage(default, null):String;

	public function new(name:String, iconPath:String, pickupMessage:String)
	{
		this.name = name;
		this.iconPath = iconPath;
		this.pickupMessage = pickupMessage;
	}
}