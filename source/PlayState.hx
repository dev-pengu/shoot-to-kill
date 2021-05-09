package;

import items.SteakPickup;
import actors.enemies.boss.Boss;
import items.TntPickup;
import items.ItemPickup;
import items.Tnt;
import flixel.text.FlxText;
import states.GameOverState;
import states.PauseMenuState;
import items.PowerUp;
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
import environment.Explodable;
import actors.enemies.stats.StatFactory;
import flixel.math.FlxPoint;

class PlayState extends FlxState
{
	private static var HUD_OFFSET_Y:Float = 100;
	private static var HUD_OFFSET_X:Float = 200;

	private var player:Player;
	private var hud:Hud;
	private var enemies:FlxTypedGroup<Enemy>;
	private var boss:Boss;
	private var breakableBlocks:FlxTypedGroup<BreakableBlock>;
	private var levelGoalBlocks:FlxTypedGroup<LevelGoalBlock>;
	private var spikes:FlxTypedGroup<Spike>;
	private var colliders:FlxTypedGroup<HitBox>;
	private var allPowerUps:FlxTypedGroup<PowerUp>;
	private var allExplodables:FlxTypedGroup<Explodable>;
	private var itemPickups:FlxTypedGroup<ItemPickup>;
	private var levelGoal:HitBox;
	private var message:FlxText;
	private var messageTimer:Float = 2;
	private var bossWayPointsTemp:Array<FlxPoint>;
	private var bossBattleTrigger:HitBox;

	private var levelLoader:FlxOgmo3Loader;
	private var map:FlxTilemap;

	private var pauseMenuSubState:PauseMenuState;
	private var ambienceTrack:FlxSound;

	override public function create()
	{
		initBackground();
		setupLevel(AssetPaths.shoot_to_kill__ogmo, AssetPaths.level_01__json);
		setupCamera();

		FlxG.mouse.visible = false;

		hud = new Hud(player, HUD_OFFSET_X, HUD_OFFSET_Y);
		StatFactory.BULLETS = new FlxTypedGroup<Bullet>();
		StatFactory.DROPS = new FlxTypedGroup<ItemPickup>();
		message = new FlxText(0, 0, 0, "message", 24);
		message.alignment = CENTER;
		message.screenCenter();
		message.visible = false;
		message.scrollFactor.set(0, 0);

		boss.onKillEvent.add(onBossDeath);
		player.onDeathEvent.add(gameOver);


		ambienceTrack = FlxG.sound.load(AssetPaths.background_ambience__ogg, 0.15);
		if (ambienceTrack != null)
		{
			ambienceTrack.looped = true;
			ambienceTrack.play();
			ambienceTrack.fadeIn(1, 0, 0.15);
		}

		addAll();

		super.create();

		destroySubStates = false;
		pauseMenuSubState = new PauseMenuState();
		pauseMenuSubState.isPersistent = true;
	}

	override public function update(elapsed:Float)
	{
		if (!message.isOnScreen()) {
			var x = FlxG.width / 2 * ((FlxG.camera.zoom - 1) / FlxG.camera.zoom);
			var y = FlxG.height / 2 * ((FlxG.camera.zoom - 1) / FlxG.camera.zoom);
			message.x = x;
			message.y = y;
		}

		super.update(elapsed);

		handleCollisions();
		if (message.visible && messageTimer <= 0) {
			message.visible = false;
		} else if (messageTimer > 0) {
			messageTimer -= elapsed;
		}

		if (FlxG.keys.justPressed.ESCAPE) {
			openSubState(pauseMenuSubState);
		}
	}

	private function handleCollisions():Void {
		FlxG.collide(player, map);
		FlxG.collide(enemies, map);
		FlxG.collide(player.tnt, map);
		FlxG.collide(player, allExplodables);
		FlxG.collide(player.tnt, allExplodables);
		FlxG.overlap(player, StatFactory.BULLETS, Bullet.doDamage);
		FlxG.overlap(enemies, player.bullets, Bullet.doDamage);
		FlxG.collide(StatFactory.BULLETS, map, function(bullet:Bullet, map) bullet.kill());
		FlxG.collide(player.bullets, map, function(bullet:Bullet, map) bullet.kill());
		FlxG.overlap(player, spikes, function(player:Player, spike:Spike) spike.doDamage(player));
		FlxG.collide(player, colliders);
		FlxG.overlap(player, allPowerUps, function(player:Player, powerUp:PowerUp)
		{
			powerUp.pickUp(player);
			message.text = powerUp.data.unlockMessage;
			message.visible = true;
			messageTimer = 1;

		});
		FlxG.overlap(player, levelGoal, function(player, levelGoal)
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
			{
				FlxG.switchState(new GameOverState(true, 0));
			});
		});
		FlxG.overlap(player, itemPickups, function(player:Player, itemPickup:ItemPickup) {
			itemPickup.pickup(player);
			message.text = itemPickup.numItems + " " + itemPickup.itemData.pickupMessage;
			message.visible = true;
			messageTimer = 1;
		});
		FlxG.overlap(player, bossBattleTrigger, function(player:Player, trigger:HitBox) {
			levelGoalBlocks.forEach(function(block:LevelGoalBlock) {
				block.activate();
			});
			boss.activate();
			bossBattleTrigger.kill();
			boss.target = player;
			ambienceTrack.stop();
			ambienceTrack = FlxG.sound.load(AssetPaths.boss_fight_ambience__ogg, 0.25);
			if (ambienceTrack != null)
			{
				ambienceTrack.looped = true;
				ambienceTrack.play();
				ambienceTrack.fadeIn(1, 0, 0.25);
			}
		});
		FlxG.overlap(player, StatFactory.DROPS, function(player:Player, itemPickup:ItemPickup) {
			itemPickup.pickup(player);
			if (Std.is(itemPickup, SteakPickup)) {
				if (message.visible) {
					message.text += "\n" + itemPickup.itemData.pickupMessage;
				} else {
					message.text = itemPickup.itemData.pickupMessage;
				}
			} else if (Std.is(itemPickup, TntPickup)) {
				if (message.visible) {
					message.text += "\n" + itemPickup.numItems + " " + itemPickup.itemData.pickupMessage;
				} else {
					message.text = itemPickup.numItems + " " + itemPickup.itemData.pickupMessage;
				}
			}

			if (message.visible) {
				messageTimer += 1;
			} else {
				message.visible = true;
				messageTimer = 1;
			}
		});
		FlxG.collide(player, levelGoalBlocks);
		FlxG.collide(enemies, levelGoalBlocks);
		FlxG.collide(StatFactory.DROPS, map);
	}

	private function setupCamera():Void {
		FlxG.camera.fade(FlxColor.BLACK, 2, true);
		FlxG.camera.follow(player, FlxCameraFollowStyle.PLATFORMER, 1 / 2);
		FlxG.camera.bgColor = FlxColor.fromRGB(20, 11, 7);
		FlxG.camera.setScrollBoundsRect(0, 0, FlxG.worldBounds.width, FlxG.worldBounds.height);
		FlxG.camera.zoom = 1.25;
	}

	private function addAll():Void {
		add(map);
		add(spikes);
		add(breakableBlocks);
		add(levelGoalBlocks);
		add(allPowerUps);
		add(StatFactory.BULLETS);
		add(player.bullets);
		add(player.tnt);
		add(player);
		add(enemies);
		add(StatFactory.DROPS);
		add(itemPickups);
		add(hud);
		add(message);
		add(boss);
		add(bossBattleTrigger);
	}

	private function setupLevel(projectPath:String, projectJson:String):Void {
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
		allPowerUps = new FlxTypedGroup<PowerUp>();
		allExplodables = new FlxTypedGroup<Explodable>();
		itemPickups = new FlxTypedGroup<ItemPickup>();
		bossWayPointsTemp = new Array<FlxPoint>();

		levelLoader.loadEntities(placeEntities, "entities");
		Player.OBSTRUCTIONS = Enemy.OBSTRUCTIONS = map;
		Tnt.EXPLODABLES = allExplodables;
		for (i in 0...bossWayPointsTemp.length) {
			boss.addWayPoint(bossWayPointsTemp[i]);
		}
		
	}

	private function placeEntities(entityData:EntityData):Void {
		if (entityData.name == "player") {
			player = new Player(entityData.x - entityData.originX, entityData.y - entityData.originY);
		} else if (entityData.name == "ranged-villager") {
			enemies.add(new RangedVillager(entityData.x - entityData.originX, entityData.y - entityData.originY, player));
		} else if (entityData.name == "spikes") {
			var spike:Spike = new Spike(entityData.x - entityData.originX, entityData.y - entityData.originY);
			spikes.add(spike);
			colliders.add(new HitBox(entityData.x - entityData.originX, entityData.y - entityData.originY + 16, 32, 16, spike));
		} else if (entityData.name == "breakable-block") {
			var block:BreakableBlock = new BreakableBlock(entityData.x - entityData.originX, entityData.y - entityData.originY);
			breakableBlocks.add(block);
			allExplodables.add(block);
		} else if (entityData.name == "level-goal-block") {
			levelGoalBlocks.add(new LevelGoalBlock(entityData.x - entityData.originX, entityData.y - entityData.originY));
		} else if (entityData.name == "hitbox") {
			colliders.add(new HitBox(entityData.x - entityData.originX, entityData.y - entityData.originY, 32, 32));
		} else if (entityData.name == "double-powerup") {
			allPowerUps.add(new PowerUp(entityData.x - entityData.originX, entityData.y - entityData.originY, "doubleJump"));
		} else if (entityData.name == "goal") {
			levelGoal = new HitBox(entityData.x - entityData.originX, entityData.y - entityData.originY, 32, 32);
		} else if (entityData.name == "jump-shot-powerup") {
			allPowerUps.add(new PowerUp(entityData.x - entityData.originX, entityData.y - entityData.originY, "jumpShot"));
		} else if (entityData.name == "bomb-pickup") {
			itemPickups.add(new TntPickup(entityData.x - entityData.originX, entityData.y - entityData.originY, 1));
		} else if (entityData.name == "triple-bomb-pickup") {
			itemPickups.add(new TntPickup(entityData.x - entityData.originX, entityData.y - entityData.originY, 3));
		} else if (entityData.name == "boss-path-trigger") {
			bossWayPointsTemp.push(new FlxPoint(entityData.x - entityData.originX, entityData.y - entityData.originY));
		} else if (entityData.name == "boss") {
			boss = new Boss(entityData.x - entityData.originX, entityData.y - entityData.originY, AssetPaths.Sherriff_sprite_sheet__png, player, "boss01", 22, 60, 48);
			enemies.add(boss);
		} else if (entityData.name == "boss-battle-trigger") {
			bossBattleTrigger = new HitBox(entityData.x - entityData.originX, entityData.y - entityData.originY, 32, 96);
		}
	}


	override public function destroy():Void {
		super.destroy();

		pauseMenuSubState.destroy();
		pauseMenuSubState = null;
	}

	private function initBackground() {
		Parallax.init();
		Parallax.addElement("sky", AssetPaths.Sky__png, 974, 800, 0, 0, 1/64, 0, 1, false);
		Parallax.addElement("sun", AssetPaths.Sun__png, 974, 800, 150, 30, 1/64, 1/512, 1, true, false);

		Parallax.addElement("mountains", AssetPaths.Mountains__png, 974, 800, 0, 54, 1/32, 1/92);
		Parallax.addElement("mountains-fg", AssetPaths.MountainsFG__png, 974, 800, 0, 70, 1/16, 1/48);
		Parallax.addElement("ground", AssetPaths.Ground__png, 974, 800, 0, 136, 1/8, 1/16);

	}

	public function onBossDeath():Void {
			levelGoalBlocks.forEach(function(block:LevelGoalBlock) {
				block.explode();
			});
			ambienceTrack.stop();
			ambienceTrack = FlxG.sound.load(AssetPaths.boss_defeated_ambience__ogg, 0.15);
			if (ambienceTrack != null)
			{
				ambienceTrack.looped = true;
				ambienceTrack.play();
				ambienceTrack.fadeIn(1, 0, 0.15);
			}
	}

	public function gameOver():Void {
		FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function()
		{
			FlxG.switchState(new GameOverState(false, 0));
		});
	}
}
