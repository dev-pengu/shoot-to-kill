package items;

import items.PowerUpAD.PowerUpData;

class PowerUpFactory {
    private static var POWER_UPS:Map<String, PowerUpData> = new Map<String, PowerUpData>();

    public static function getPowerUpData(name:String):PowerUpData {
		var data:PowerUpData = POWER_UPS.get(name);

        if (data == null) {
            switch(name) {
                case "doubleJump":
                    data = new PowerUpData("doubleJump", AssetPaths.double_jump_icon__png, "Double Jump Ability Unlocked!");
                    POWER_UPS.set(name, data);
                case "jumpShot":
                    data = new PowerUpData("jumpShot", AssetPaths.jump_shot_icon__png, "Jump Shot Ability Unlocked!");
                    POWER_UPS.set(name, data);
            }
        }

        return data;
    }
}