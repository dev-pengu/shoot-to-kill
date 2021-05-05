package items;

import flixel.FlxSprite;
import items.UsableItem;
import actors.player.Player;
import haxe.Exception;

class ItemPickup extends FlxSprite {
	public var itemData(default, null):ItemData;
	private static var IDLE_ANIMATION:String = "idle";
	public var numItems(default, null):Int;

    public function new(?X:Float=0, ?Y:Float=0, itemType:String, numItems:Int) {
        super(X,Y);
        this.numItems = numItems;
        itemData = ItemFactory.getItemData(itemType);
        loadGraphic(itemData.iconPath,true, 32, 32);
    }

    public function pickup(player:Player):Void {
		throw new Exception("pickup function not implemented");
    }
}