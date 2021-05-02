package actors.enemies.stats;

import flixel.FlxG;

class StatFactory {
    private static var STATS:Map<String, EnemyStats> = new Map<String, EnemyStats>();

    public static function getStats(statType:String):EnemyStats {
        var stats:EnemyStats = STATS.get(statType);

        if (stats == null) {
            switch (statType) {
                case "rangedVillager":
                    stats = new EnemyStats(RangedVillager.MAX_HEALTH, RangedVillager.RANGED_VILLAGER_AGGRO_RANGE, 
                        RangedVillager.ATTACK_SPEED, RangedVillager.ATTACK_RANGE, RangedVillager.RELOAD_TIME, 
                        RangedVillager.ROUNDS);
					stats.enemySfx[Enemy.ATTACK_SOUND] = FlxG.sound.load(AssetPaths.rifle_shooting__ogg, 0.25);
            }
            stats.enemySfx[Enemy.HURT_SOUND] = FlxG.sound.load(AssetPaths.Male_Hurt_02__wav, 0.25);
            stats.enemySfx[Enemy.DEATH_SOUND] = FlxG.sound.load(AssetPaths.Male_Death_04__wav, 0.25);
			STATS.set(statType, stats);
        }


        return stats;
    }
}