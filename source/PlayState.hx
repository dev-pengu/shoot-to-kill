package;

import flixel.system.FlxSound;
import environment.HitBox;
import ui.Hud;
import environment.Spike;
import environment.LevelGoalBlock;
import environment.BreakableBlock;
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
import environment.background.Parallax;

class PlayState extends FlxState
{
	private static var HUD_OFFSET_Y:Float = 100;
	private static var HUD_OFFSET_X:Float = 200;

	private var player:Player;
	private var hud:Hud;
	private var enemies:FlxTypedGroup<Enemy>;
	private var breakableBlocks:FlxTypedGroup<BreakableBlock>;
	private var levelGoalBlocks:FlxTypedGroup<LevelGoalBlock>;
	private var spikes:FlxTypedGroup<Spike>;
	private var colliders:FlxTypedGroup<HitBox>;

	private var levelLoader:FlxOgmo3Loader;
	private var map:FlxTilemap;

	private var ambienceTrack:FlxSound;

	override public function create()
	{
		initBackground();

		setUpLevel(AssetPaths.shoot_to_kill__ogmo, AssetPaths.level_01__json);

		FlxG.camera.fade(FlxColor.BLACK, 2, true);
		FlxG.camera.follow(player, FlxCameraFollowStyle.PLATFORMER, 1 / 2);
		FlxG.camera.bgColor = FlxColor.fromRGB(20, 11, 7);
		FlxG.camera.setScrollBoundsRect(0, 0, FlxG.worldBounds.width, FlxG.worldBounds.height);
		FlxG.camera.zoom = 1.25;

		hud = new Hud(player, HUD_OFFSET_X, HUD_OFFSET_Y);

		ambienceTrack = FlxG.sound.load(AssetPaths.background_ambience__mp3, 0.05);
		if (ambienceTrack != null)
		{
			ambienceTrack.looped = true;
			ambienceTrack.play();
			ambienceTrack.fadeIn(1, 0, 0.05);
		}

		addAll();

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.collide(player, map);
		FlxG.collide(enemies, map);
		FlxG.collide(player, breakableBlocks, function(player, block) block.explode());
		FlxG.overlap(player, RangedVillager.BULLETS, Bullet.doDamage);
		FlxG.overlap(enemies, Player.BULLETS, Bullet.doDamage);
		FlxG.collide(RangedVillager.BULLETS, map, function(bullet, map) bullet.kill());
		FlxG.collide(Player.BULLETS, map, function(bullet, map) bullet.kill());
		FlxG.overlap(player, spikes, function(player, spike) spike.doDamage(player));
		FlxG.collide(player, colliders);
	}

	private function addAll():Void {
		add(map);
		add(enemies);
		add(spikes);
		add(breakableBlocks);
		add(levelGoalBlocks);
		add(RangedVillager.BULLETS);
		add(Player.BULLETS);
		add(player);
		add(hud);
	}

	private function setUpLevel(projectPath:String, projectJson:String):Void {
		levelLoader = new FlxOgmo3Loader(projectPath,
			projectJson);

		FlxG.worldBounds.setSize(
			levelLoader.getLevelValue("width"), levelLoader.getLevelValue("height")
		);

		map = levelLoader.loadTilemap(AssetPaths.Tilesheet__png, "platforms");
		for (i in 1...13) {
			map.setTileProperties(i, FlxObject.ANY);
		}

		enemies = new FlxTypedGroup<Enemy>();
		breakableBlocks = new FlxTypedGroup<BreakableBlock>();
		levelGoalBlocks = new FlxTypedGroup<LevelGoalBlock>();
		spikes = new FlxTypedGroup<Spike>();
		colliders = new FlxTypedGroup<HitBox>();

		levelLoader.loadEntities(placeEntities, "entities");
		Player.OBSTRUCTIONS = Enemy.OBSTRUCTIONS = map;
	}

	private function placeEntities(entityData:EntityData):Void {
		if (entityData.name == "player") {
			player = new Player(entityData.x - entityData.originX, entityData.y - entityData.originY);
		} else if (entityData.name == "ranged-villager") {
			enemies.add(new RangedVillager(entityData.x - entityData.originX, entityData.y - entityData.originY, player));
		} else if (entityData.name == "spikes") {
			spikes.add(new Spike(entityData.x - entityData.originX, entityData.y - entityData.originY));
			colliders.add(new HitBox(entityData.x - entityData.originX, entityData.y - entityData.originY + 16, 32, 16));
		} else if (entityData.name == "breakable-block") {
			breakableBlocks.add(new BreakableBlock(entityData.x - entityData.originX, entityData.y - entityData.originY));
		} else if (entityData.name == "level-goal-block") {
			levelGoalBlocks.add(new LevelGoalBlock(entityData.x - entityData.originX, entityData.y - entityData.originY));
		} else if (entityData.name == "hitbox") {
			colliders.add(new HitBox(entityData.x - entityData.originX, entityData.y - entityData.originY, 32, 32));
		}
	}

	private function initBackground() {
		Parallax.init();
		Parallax.addElement("sky", AssetPaths.Sky__png, 974, 800, 0, 0, 1/64, 0, 1, false);
		Parallax.addElement("sun", AssetPaths.Sun__png, 974, 800, 150, 30, 1/64, 1/512, 1, true, false);

		Parallax.addElement("mountains", AssetPaths.Mountains__png, 974, 800, 0, 54, 1/32, 1/92);
		Parallax.addElement("mountains-fg", AssetPaths.MountainsFG__png, 974, 800, 0, 70, 1/16, 1/48);
		Parallax.addElement("ground", AssetPaths.Ground__png, 974, 800, 0, 136, 1/8, 1/16);
	}
}
