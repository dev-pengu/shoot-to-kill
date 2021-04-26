package actors.enemies;

import flixel.util.FlxColor;

class RangedVillager extends Enemy {

    public static var RANGED_VILLAGER_AGGRO_RANGE(default, never):Float = 200;

    public function new(?X:Float=0, ?Y:Float=0, ?maxHealth:Float=50) {
        super(X, Y, maxHealth, AssetPaths.enemy__png);
		
        animation.add(Enemy.IDLE_ANIMATION, [0], 1, false);
		animation.add(Enemy.WALK_ANIMATION, [1, 2, 3, 1, 4, 5], 8);
        animation.add(Enemy.ATTACK_ANIMATION, [6,7,6], 4, false);

        aggroRange = RANGED_VILLAGER_AGGRO_RANGE;
    }
}