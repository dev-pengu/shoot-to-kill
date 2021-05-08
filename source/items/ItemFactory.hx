package items;

import items.UsableItem.ItemData;

class ItemFactory {
    private static var ITEMS:Map<String, ItemData> = new Map<String, ItemData>();

    public static function getItemData(name:String):ItemData {
        var data:ItemData = ITEMS.get(name);

        if (data == null) {
            switch(name) {
                case "tnt":
                    data = new ItemData("tnt", AssetPaths.tnt_sprite_sheet__png, " pack(s) of TNT found.");
                    ITEMS.set(name, data);
                case "steak":
                    data = new ItemData("steak", AssetPaths.steak_drop__png, "Steak restored some health.");
                    ITEMS.set(name, data);
            }
        }

        return data;
    }
}