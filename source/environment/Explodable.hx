package environment;

import flixel.FlxSprite;

interface I_Explodable {

    public function explode():Void;
}

class Explodable extends FlxSprite implements I_Explodable {
    public function explode():Void {}
}