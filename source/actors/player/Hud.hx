package actors.player;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.ui.FlxBar;
import flixel.FlxObject;

using flixel.util.FlxSpriteUtil;

class Hud extends FlxTypedGroup<FlxSprite>
{
	// var background:FlxSprite;
	private var healthText:FlxText;
	private var healthBar:FlxBar;

	public function new(maxHealth:Float, managedEntity:FlxObject)
	{
		super();
		// background = new FlxSprite().makeGraphic(FlxG.width, 20, FlxColor.BLACK);
		// background.drawRect(0, 19, FlxG.width, 1, FlxColor.WHITE);
		healthText = new FlxText(4, 4, 0, "HP:", 8);
		healthText.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
		healthBar = new FlxBar(28, 8, FlxBarFillDirection.LEFT_TO_RIGHT, Math.floor(maxHealth * 2), 10, managedEntity, "health", 0, managedEntity.health);
		healthBar.createColoredFilledBar(FlxColor.RED);

		// add(background);
		add(healthText);
		add(healthBar);
		forEach(function(sprite) sprite.scrollFactor.set(0, 0));
		FlxG.state.add(this);
	}
}