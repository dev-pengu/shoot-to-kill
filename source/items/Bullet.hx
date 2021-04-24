package items;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.FlxObject;

class Bullet extends FlxSprite {
	private var speed:Float;
	private var direction:Int;
	private var spawnPoint:FlxPoint;
	private var range:Float;
	private var damage:Float;
	
	public function new(?X:Float=0, ?Y:Float=0, speed:Float, direction:Int, range:Float, damage:Float):Void {
		super(X,Y);
		makeGraphic(7,7);
		this.speed = speed;
		this.direction = direction;
		this.range = range;
		this.damage = damage;
		this.spawnPoint = FlxPoint.weak(X, Y);
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		if (Math.abs(Math.sqrt(Math.pow(this.x - spawnPoint.x, 2))) >= range) {
			kill();
		}
		
		if (!isOnScreen()) {
			kill();
		}
	}
	
	public function fire():Void {
		if (direction != 0) {
			velocity.set(speed * direction, 0);
		}
	}
	
	public static function doDamage(object:FlxObject, bullet:Bullet) {
		object.hurt(bullet.damage);
		bullet.kill();
	}
}