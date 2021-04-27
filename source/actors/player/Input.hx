package actors.player;

class Input {
	// movement inputs
    public var rightJustPressed:Bool = false;
    public var leftJustPressed:Bool = false;
    public var downJustPressed:Bool = false;
    public var upJustPressed:Bool = false;
    public var jumpJustPressed:Bool = false;

	public var rightPressed:Bool = false;
	public var leftPressed:Bool = false;
	public var downPressed:Bool = false;
	public var upPressed:Bool = false;
	public var jumpPressed:Bool = false;

	public var rightJustReleased:Bool = false;
	public var leftJustReleased:Bool = false;
	public var downJustReleased:Bool = false;
	public var upJustReleased:Bool = false;
	public var jumpJustReleased:Bool = false;

	// attacking inputs
	public var attackJustPressed:Bool = false;
	public var attackPressed:Bool = false;
	public var attackJustReleased:Bool = false;

	public var reloadJustPressed:Bool = false;

    public function new() {}
}