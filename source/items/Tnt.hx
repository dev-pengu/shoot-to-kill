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
    public static var EXPLODABLES(default, default):FlxTypedGroup<Explodable>;

    private var hitBox:HitBox;
    private var owner:Player;
    private var explosionTimer:Float;
    private var ignited:Bool = false;

    private static var PICKUP_ANIMATION(default, never):String = "pickup";
    private static var USE_ANIMATION(default, never):String = "use";
    private static var BLAST_RADIUS(default, never):Int = 96;

    override public function new(?X:Float=0, ?Y:Float=0) {
        super(X, Y);
        data = ItemFactory.getItemData("tnt");
        loadGraphic(data.iconPath, true, 32, 32);
        hitBox = new HitBox(X - ((BLAST_RADIUS - 32) / 2), Y - ((BLAST_RADIUS - 32) / 2), BLAST_RADIUS, BLAST_RADIUS, this);

        animation.add(PICKUP_ANIMATION, [0], 1, false);
        animation.add(USE_ANIMATION, [0, 1], 12, true);
        animation.play(PICKUP_ANIMATION);
    }

    override public function update(elapsed:Float) {
        if (ignited && explosionTimer > 0) {
            explosionTimer -= elapsed;
        } else if (ignited && explosionTimer <= 0) {
            explode();
        }
    }

    public function use():Void {
        explosionTimer = 2;
        ignited = true;
        owner.tntCount--;
        switch(owner.facing) {
            case FlxObject.LEFT:
                this.y = owner.y + Player.HIT_BOX_HEIGHT;
                this.x = owner.x - 32;
            case FlxObject.RIGHT:
                this.y = owner.y + Player.HIT_BOX_HEIGHT;
                this.x = owner.x + Player.HIT_BOX_WIDTH;
        }
        this.animation.play(USE_ANIMATION);
    }

    public function pickup(owner:Player):Void {
        this.owner = owner;
        this.kill();
    }

    private function explode():Void {
		FlxG.overlap(this.hitBox, EXPLODABLES, function(tnt:Tnt, explodable:Explodable) {
            explodable.explode(); 
            this.kill();
        });
    }
}