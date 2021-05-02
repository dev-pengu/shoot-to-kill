package actors.enemies.stats;

import flixel.system.FlxSound;

class EnemyStats {
	@:isVar public var maxHealth(get, null):Float;
	@:isVar public var aggroRange(get, null):Float;
	@:isVar public var attackSpeed(get, null):Float;
	@:isVar public var reloadTime(get, null):Float;
	@:isVar public var rounds(get, null):Int;
	@:isVar public var attackRange(get, null):Float;
	@:isVar public var enemySfx(default, null):Map<String, FlxSound>;

	public function new(maxHealth:Float, aggroRange:Float, attackSpeed:Float, attackRange:Float, ?reloadTime:Float=0, ?rounds:Int=0) {
		this.maxHealth = maxHealth;
		this.aggroRange = aggroRange;
		this.attackSpeed = attackSpeed;
		this.attackRange = attackRange;
		this.reloadTime = reloadTime;
		this.rounds = rounds;
		enemySfx = new Map<String, FlxSound>();
	}

    function get_maxHealth() return maxHealth;
    function get_aggroRange() return aggroRange;
    function get_attackSpeed() return attackSpeed;
    function get_reloadTime() return reloadTime;
    function get_rounds() return rounds;
    function get_attackRange() return attackRange;
}