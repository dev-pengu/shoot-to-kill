package ui;

import actors.player.Player;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.ui.FlxBar;

using flixel.util.FlxSpriteUtil;

class Hud extends FlxTypedGroup<FlxSprite>
{
	private static var HEALTH_BAR_X:Float = 28;
	private static var HEALTH_BARY_Y:Float = 8;
	private static var BULLET_UI_BEGIN_X:Float = 28;
	private static var BULLET_UI_Y:Float = 22;
	private static var BULLET_SPRITE_SIZE:Int = 16;

	private var healthText:FlxText;
	private var healthBar:FlxBar;
	private var bulletSprites:Array<FlxSprite> = new Array<FlxSprite>();
	private var managedEntity:Player;
	private var roundsValue:Int;
	private var bulletsVar:String = "roundsLeft";

	public function new(?managedEntity:Player, ?x_offset:Float=0, ?y_offset:Float=0)
	{
		super();

		if (managedEntity != null) {
			this.managedEntity = managedEntity;
			healthText = new FlxText(x_offset + 4, y_offset + 4, 0, "HP:", 8);
			healthText.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
			healthBar = new FlxBar(x_offset + HEALTH_BAR_X, y_offset + HEALTH_BARY_Y, FlxBarFillDirection.LEFT_TO_RIGHT, Math.floor(managedEntity.maxHealth * 2), 10, managedEntity, "health", 0, managedEntity.health);
			healthBar.createFilledBar(FlxColor.BLACK, FlxColor.RED, true);

			for (i in 0...managedEntity.rounds) {
				var sprite:FlxSprite = new FlxSprite(x_offset + BULLET_UI_BEGIN_X + i * BULLET_SPRITE_SIZE, y_offset + BULLET_UI_Y);
				sprite.loadGraphic((i == 0 ? AssetPaths.bulletUI_1__png : AssetPaths.bulletUI_0__png));
				bulletSprites.push(sprite);
				add(bulletSprites[i]);
			}

			add(healthText);
			add(healthBar);
			forEach(function(sprite) sprite.scrollFactor.set(0, 0));
		}
	}

	function updateValueFromParent():Void {
		roundsValue = Reflect.getProperty(managedEntity, bulletsVar);
	}

	override public function update(elapsed:Float):Void	{
		super.update(elapsed);
		if (managedEntity != null) {
			if (Reflect.getProperty(managedEntity, bulletsVar) != roundsValue) {
				updateValueFromParent();
				updateUI();
			}
		}
	}

	function updateUI() {
        for (i in 0...managedEntity.rounds) {
            if (i + 1 <= roundsValue) {
				if (i != 0) {
					bulletSprites[i].loadGraphic(AssetPaths.bulletUI_0__png);
				} else {
					bulletSprites[i].loadGraphic(AssetPaths.bulletUI_1__png);
				}
            } else {
				bulletSprites[i].makeGraphic(BULLET_SPRITE_SIZE, BULLET_SPRITE_SIZE, FlxColor.TRANSPARENT);
            }
        }
    }
}