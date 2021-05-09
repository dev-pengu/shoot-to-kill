package actors.enemies.stats;

import items.ItemPickup;
import items.Bullet;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;

class StatFactory {
    private static var STATS:Map<String, EnemyStats> = new Map<String, EnemyStats>();

    public static function getStats(statType:String):EnemyStats {
        var stats:EnemyStats = STATS.get(statType);

        if (stats == null) {
            switch (statType) {
                case "rangedVillager":
                    stats = new EnemyStats(RangedVillager.MAX_HEALTH, RangedVillager.RANGED_VILLAGER_AGGRO_RANGE, 
                        RangedVillager.ATTACK_SPEED, RangedVillager.ATTACK_RANGE, 4, 10, RangedVillager.RELOAD_TIME, 
                        RangedVillager.ROUNDS);
                case "boss01":
                    stats = new EnemyStats(200, 400, 0, 300, 8, 12, 0, 0);
            }
			STATS.set(statType, stats);
        }


        return stats;
    }

    public static var BULLETS:FlxTypedGroup<Bullet>;
    public static var DROPS:FlxTypedGroup<ItemPickup>;
}