package;

import ui.PauseMenuState;
import items.Bullet;
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

	private var pauseMenuSubState:PauseMenuState;

	override public function create()
	{
		enemies = new FlxTypedGroup<Enemy>();
		setUpLevel();
		addAll();

		FlxG.camera.follow(player, FlxCameraFollowStyle.PLATFORMER, 1);
		super.create();

		destroySubStates = false;
		pauseMenuSubState = new PauseMenuState(FlxColor.fromRGB(0,0,0,185));
		pauseMenuSubState.isPersistent = true;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.collide(player, map);
		FlxG.collide(enemies, map);
		FlxG.overlap(player, RangedVillager.BULLETS, Bullet.doDamage);
		FlxG.overlap(enemies, Player.BULLETS, Bullet.doDamage);

		if (FlxG.keys.justPressed.ESCAPE) {
			openSubState(pauseMenuSubState);
		}
	}

	private function addAll():Void {
		add(player);
		add(enemies);
		add(map);
		add(RangedVillager.BULLETS);
		add(Player.BULLETS);
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
		Player.OBSTRUCTIONS = Enemy.OBSTRUCTIONS = map;
	}

	private function placeEntities(entityData:EntityData):Void {
		if (entityData.name == "player") {
			player = new Player(entityData.x - entityData.originX, entityData.y - entityData.originY);
		} else if (entityData.name == "ranged-villager") {
			enemies.add(new RangedVillager(entityData.x - entityData.originX, entityData.y - entityData.originY, player));
		}
	}

	override public function destroy():Void {
		super.destroy();

		pauseMenuSubState.destroy();
		pauseMenuSubState = null;
	}
}
