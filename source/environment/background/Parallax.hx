package environment.background;

import flixel.addons.display.FlxBackdrop;
import flixel.FlxG;

class Parallax {
    public static var elements:Map<String, FlxBackdrop>;

    public static function init() {
        elements = new Map<String, FlxBackdrop>();
    }

    public static function addElement(  name:String, assetPath:String, ?elementWidth:Int = 0, ?elementHeight:Int = 0,
        ?initialX:Int = 0, ?initialY:Int = 0, ?scrollXSpeed:Float = 1, ?scrollYSpeed:Float = 1,
        ?opacity:Float = 1, ?canOffset:Bool = true, ?repeat:Bool = true):FlxBackdrop {

        elements[name] = new FlxBackdrop(assetPath, scrollXSpeed, scrollYSpeed, repeat, false);

        elements[name].setPosition(initialX, initialY);
        elements[name].alpha = opacity;
        elements[name].scrollFactor.set(scrollXSpeed, scrollYSpeed);

        elements[name].health = canOffset ? 1 : 0;

		FlxG.state.add(elements[name]);

        return elements[name];
    }

    public static function shiftAllElements(?xOff:Int = 0, ?yOff:Int = 0):Void {
        for (element in elements) {
            if (element.health == 1) {
                element.setPosition(xOff, yOff);
            }
        }
    }
}