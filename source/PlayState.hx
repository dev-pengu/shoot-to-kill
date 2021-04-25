package;

import flixel.util.FlxColor;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.group.FlxGroup.FlxTypedGroup;
import actors.player.Player;
import flixel.FlxState;
import flixel.FlxG;

class PlayState extends FlxState
{

	private static var GROUND_TILE_COUNT(default, never):Int = 18;
	private static var GROUND_START_X(default, never):Float = 32;
	private static var GROUND_START_Y(default, never):Float = 320;

	private static var HERO_START_X(default, never):Float = 320;
	private static var HERO_START_Y(default, never):Float = 256;

	private var player:Player;
	private var groundGroup:FlxTypedGroup<Ground>;

	override public function create()
	{
		bgColor = FlxColor.fromRGB(66,66,66);

		instantiateEntities();
		addEntities();

		FlxG.camera.follow(player, FlxCameraFollowStyle.PLATFORMER, 1);
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.collide(player, groundGroup);

		if (FlxG.keys.justPressed.F) {
			player.hurt(10);
		}
	}

	private function instantiateEntities():Void {
		player = new Player(HERO_START_X, HERO_START_Y);

		groundGroup = new FlxTypedGroup<Ground>();
		for (i in 0...GROUND_TILE_COUNT) {
			groundGroup.add(new Ground(GROUND_START_X + Ground.LENGTH * i, GROUND_START_Y));
		}
	}

	private function addEntities():Void {
		add(player);
		add(groundGroup);
	}
}
