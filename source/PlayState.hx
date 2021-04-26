package;

import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import actors.enemies.RangedVillager;
import actors.enemies.Enemy;
import flixel.util.FlxColor;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.group.FlxGroup.FlxTypedGroup;
import actors.player.Player;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxObject;

class PlayState extends FlxState
{
	private var player:Player;
	private var enemies:FlxTypedGroup<Enemy>;

	private var levelLoader:FlxOgmo3Loader;
	private var map:FlxTilemap;

	override public function create()
	{
		enemies = new FlxTypedGroup<Enemy>();
		setUpLevel();
		addAll();

		FlxG.camera.follow(player, FlxCameraFollowStyle.PLATFORMER, 1);
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.collide(player, map);
		FlxG.collide(enemies, map);

		if (FlxG.keys.justPressed.F) {
			player.hurt(10);
		}
	}

	private function addAll():Void {
		add(player);
		add(enemies);
		add(map);
	}

	private function setUpLevel():Void {
		levelLoader = new FlxOgmo3Loader(AssetPaths.shoot_to_kill__ogmo,
			AssetPaths.level_01__json);

		FlxG.worldBounds.setSize(
			levelLoader.getLevelValue("width"), levelLoader.getLevelValue("height")
		);

		map = levelLoader.loadTilemap(AssetPaths.Brick__png, "platforms");
		map.setTileProperties(1, FlxObject.ANY);

		levelLoader.loadEntities(placeEntities, "entities");
		Enemy.OBSTRUCTIONS = map;
	}

	private function placeEntities(entityData:EntityData):Void {
		if (entityData.name == "player") {
			player = new Player(entityData.x - entityData.originX, entityData.y - entityData.originY);
		} else if (entityData.name == "ranged-villager") {
			enemies.add(new RangedVillager(entityData.x - entityData.originX, entityData.y - entityData.originY));
		}
	}
}
