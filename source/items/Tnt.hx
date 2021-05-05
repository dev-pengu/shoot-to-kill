package items;

import flixel.group.FlxGroup.FlxTypedGroup;
import environment.Explodable;
import actors.player.Player;
import environment.HitBox;
import items.UsableItem.ItemData;
import flixel.FlxSprite;
import flixel.FlxObject;
import items.UsableItem.I_UsableItem;
import flixel.FlxG;

class Tnt extends FlxSprite implements I_UsableItem {
    public var data(default, null):ItemData;
    public static var EXPLODABLES(default, default):FlxTypedGroup<Explodable> = new FlxTypedGroup<Explodable>();

    public var hitBox(default, null):HitBox;
    private var owner:Player;
    private var explosionTimer:Float;
    private var ignited:Bool = false;

    private static var USE_ANIMATION(default, never):String = "useAnim";
    private static var EXPLODE_ANIMATION(default, never):String = "explodeAnim";
    private static var BLAST_RADIUS(default, never):Int = 96;
    private static var GRAVITY(default, never):Int = 400;
    private static var WIDTH(default, never):Int = 20;
    private static var HEIGHT(default, never):Int = 20;
    private static var SPRITE_SIZE(default, never):Int = 32;

    override public function new(?X:Float=0, ?Y:Float=0) {
        super(X, Y);
        data = ItemFactory.getItemData("tnt");
        velocity.y = GRAVITY;
        this.maxVelocity.set(GRAVITY, 0);
		loadGraphic(data.iconPath, true, SPRITE_SIZE, SPRITE_SIZE);
		hitBox = new HitBox(X
			- ((BLAST_RADIUS - SPRITE_SIZE) / 2), Y
			- ((BLAST_RADIUS - SPRITE_SIZE) / 2), BLAST_RADIUS, BLAST_RADIUS, this,
			-((BLAST_RADIUS - SPRITE_SIZE) / 2));

        this.animation.add(USE_ANIMATION, [0, 1], 8, true);
        this.animation.add(EXPLODE_ANIMATION, [2, 3, 4], 6, false);
        animation.play(USE_ANIMATION);
        FlxG.state.add(hitBox);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if(isTouching(FlxObject.DOWN)) {
            velocity.y = 0;
        }
        if (ignited && explosionTimer > 0) {
            explosionTimer -= elapsed;
        } else if (ignited && explosionTimer <= 0) {
			ignited = false;
            explode();
        }

		if (this.animation.name == EXPLODE_ANIMATION && this.animation.finished) {
            trace("i should be disappearing now");
			this.kill();
        }

    }

    public function setOwner(player:Player) {
        owner = player;
    }

    public function use():Void {
        explosionTimer = 2;
        ignited = true;
        owner.tntCount--;
		this.y = owner.y + Player.BULLET_SPAWN_OFFSET_Y + 4;
		this.x = owner.x;
		this.width = WIDTH;
		this.height = HEIGHT;
        this.offset.set((SPRITE_SIZE - WIDTH) / 2, (SPRITE_SIZE - HEIGHT));
		hitBox.setPosition(this.x - ((BLAST_RADIUS - SPRITE_SIZE) / 2), this.y - ((BLAST_RADIUS - SPRITE_SIZE) / 2));
        this.animation.play(USE_ANIMATION);
        this.velocity.y = GRAVITY;
    }

    private function explode():Void {
		this.animation.play(EXPLODE_ANIMATION);
        FlxG.sound.play(AssetPaths.explosion__ogg, 0.25, false);
		FlxG.overlap(this.hitBox, EXPLODABLES, function(tnt:Tnt, explodable:Explodable) {
            explodable.explode();
        });
    }
}