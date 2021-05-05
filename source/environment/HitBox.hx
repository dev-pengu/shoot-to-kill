package environment;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class HitBox extends FlxSprite {

    private var owner:FlxSprite;
    private var offsetX:Float = 0;
    private var offsetY:Float = 0;

    public function new(?x:Float=0, ?y:Float=0, ?width:Int = 1, ?height:Int = 1, ?owner:FlxSprite, ?offset:Float) {
        super(x,y);

        this.owner = owner;
        makeGraphic(width, height, FlxColor.TRANSPARENT);

        immovable = true;
        visible = false;
        if (offset != null) {
            offsetX = offsetY = offset;
        }
    }

    public function positionBox(from:String = "Bottom", to:String = "South") {
        var originX:Float = 0;
        var originY:Float = 0;
        var targetX:Float = 0;
        var targetY:Float = 0;

        switch (from)
        {
            case "Bottom","B","South","S":
                originX = width/2;
                originY = height;
            case "Bottom-Left","BL","South-West","SW":
                originX = 0;
                originY = height;
            case "Bottom-Right","BR","South-East","SE":
                originX = width;
                originY = height;
        }

        switch (to)
        {
            case "Bottom","B","South","S":
                targetX = owner.width/2;
                targetY = owner.height;
        }

        offsetX = -(originX - targetX);
        offsetY = -(originY - targetY);
    }

    override public function update(elapsed:Float):Void {
        if (owner != null) {
            this.x = Reflect.getProperty(owner, "x") + offsetX;
            this.y = Reflect.getProperty(owner, "y") + offsetY;
        }
    }
}