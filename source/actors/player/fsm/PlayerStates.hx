package actors.player.fsm;

enum PlayerStates {
    NO_CHANGE;
    STANDING;
    RUNNING;
    JUMPING;
    CROUCHING;
    FALLING;
    ATTACKING;
    RELOADING;
}