package items;


import flixel.math.FlxVector;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.FlxObject;

class Bullet extends FlxSprite {
	private var speed:Float;
	private var direction:Int;
	private var spawnPoint:FlxPoint;
	private var range:Float;
	private var damage:Float;

	private static var WIDTH:Float = 10;
	private static var HEIGHT:Float = 8;
	private static var OFFSET_Y:Int = 1;
	private static var OFFSET_X:Int = 0;

	public function new(?X:Float=0, ?Y:Float=0):Void {
		super(X,Y);
		loadGraphic(AssetPaths.Bullet__png, false, 10, 10);
		width = WIDTH;
		height = HEIGHT;
		this.offset.set(OFFSET_X, OFFSET_Y);
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
		this.angle = 0;
		if (direction != 0) {
			velocity.set(speed * direction, 0);
		}
	}

	public function fireAngle(angle:Float):Void {
		var directionVector:FlxVector = FlxVector.weak(direction, 0);
		directionVector.rotateByDegrees(angle);
		directionVector.normalize();
		this.angle = angle;

		velocity = directionVector.scale(speed);
		velocity.x = Math.floor(velocity.x);
		velocity.y = Math.floor(velocity.y);
	}

	public function setParams(speed:Float, direction:Int, range:Float, damage:Float):Void {
		this.speed = speed;
		this.direction = direction;
		this.range = range;
		this.damage = damage;
		this.spawnPoint.set(this.x, this.y);
		this.facing = direction == -1 ? FlxObject.LEFT : FlxObject.RIGHT;
		this.flipX = facing == FlxObject.LEFT;
	}
	
	public static function doDamage(object:FlxObject, bullet:Bullet) {
		object.hurt(bullet.damage);
		bullet.kill();
	}
}