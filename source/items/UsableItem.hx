package items;

import environment.HitBox;

interface I_UsableItem {
    public var data(default, null):ItemData;
    public var hitBox(default, null):HitBox;

    public function use():Void;
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