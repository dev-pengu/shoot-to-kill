package actors.enemies.stats;

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
                    STATS.set(statType, stats);
            }
        }

        return stats;
    }
}