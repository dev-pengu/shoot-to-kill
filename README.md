# shoot-to-kill
This is a 2D platformer game created by Lippelman515 / Matt L., a student at Missouri State University.

The main purpose of this project was to learn [HaxeFlixel](http://www.haxeflixel.com) and make a playable game.

## Description

Shoot to Kill is a 2D platformer with a Western setting. The player plays as an outlaw disrupting the people in town by blowing up their buildings and shooting their livestock. The player collects gold that they steal from the townspeople, that could be later spent for items or temporary power ups. However, the townspeople are fighting back and the sheriff is tracking the outlaw down to keep him from leaving town.

![Shoot To Kill Screenshot](/screenshots/gameplay.jpg?raw=true)

Version 1.0 - [Try Me!](https://lippelman515.github.io/shoot-to-kill/)

## Getting Started

To build and run Shoot to Kill locally, follow the steps below:

1. Ensure you have [Haxe](http://www.haxe.org/download), [HaxeFlixel](http://www.haxeflixel.com), [HaxeFlixel Addons](https://haxeflixel.com/documentation/flixel-addons/) (2.8.0 +), and [OpenFL](http://www.openfl.org/download/) installed on your computer.
2. Open a command prompt in your copy of the source code.
3. Run the command `lime test html5` to build and run the executable in your web browser or `lime test neko` to build and run a desktop version.

## Win/Lose Condition

The player wins if they are able to defeat the sheriff and leave the area. The player will lose the game if they are stopped (killed) by a town resident or by the sheriff.

## Player Interaction
The player can move around the levels using keyboard input. The main character can use two attacks, dropping tnt and shooting a pistol. The main use of the tnt is to explode blocks that may be in the way of progression. There is a limited supply of guaranteed tnt so be sure to not waste it attacking, or you may get stuck and have to start over. Enemies do have a chance of dropping tnt but the chance is low. The attack speed of the main character is limited and the pistol is only able to fire four shots before having to reload. Reloading takes a little longer than the time between the four shots in the pistol. The player is able to reload cancel by crouching and jumping to avoid incoming bullets. There are power ups throughout the level to help you advance further and make combat easier. Once the player has defeated the sheriff,they may exit the level.

## Controls
If player health reaches 0, a Game Over window will appear and the option is given to exit to the main menu.

* Use the [A] and [D] keys to move the player left and right.
* Use the [S] key to have the player crouch.
* Use the [E] key to drop a pack of tnt and ignite it.
* Use the [R] key to manually reload.
* Use the [LMB] (left mouse button) to fire your gun.
* use the [SPACE] key to jump
* * Holding the [SPACE] key will let you jump to the max height.
* * Tapping the [SPACE] key will let you jump lightly.
* * Tapping the [SPACE] key while falling, will allow you to double jump (once the double jump ability has been unlocked).

## Enemies
### Towns People
* ![towns people](/screenshots/average_enemy.jpg)
* Starts of patrolling an area.
* When the player has walked into attack range, the enemy will begin firing bullets in the direction of the player.
* When the player touches the enemy, the enemy will inflict damage to the player.
* The towns people have 3 rounds before they must reload.

### Sheriff
* Waits for the Outlaw to get close.
* * Once the player gets close, the sheriff will wall off the area to keep the Outlaw from leaving and will begin his attacks.
* The sheriff has two attacks:
* * A shotgun fire that fires 3 times with 3 bullets spraying the area towards the player.
* * A charge towards the player at an increased speed (The screen will shake to indicate this attack along with an increased speed).
* When the sheriff is attacking, he is invincible.

## Power ups
* When a power up has been acquired, a message will appear indicating what power up has been learned.
* A power up pickup will have a sprite similar to: ![power up image](/screenshots/powerup-example.jpg)
### Double Jump
* Allows the player to jump again while in the air.
### Jump Shot
* Allows the player to fire his pistol while in the air.

## Items
* Items can be dropped from enemies or gathered from around the map
### Steak 
* ![steak image](/screenshots/meat_drop.jpg)
* Enemies have a chance of dropping meat.
* Steak restores health.
* The restoration value can vary between 10 and 30.
### TNT
* TNT can be found around the map in packs of 1 and 3.
* * 1 pack: ![tnt pack](/screenshots/single_tnt_pickup.jpg)
* * 3 pack: ![tnt pack](/screenshots/three_pack_tnt_pickup.jpg)
* 1 TNT have a chance of dropping from enemies.
* TNT is used to blow up explodable blocks and damaging enemies.

## Environment Objects
### Blocks
* Breakable blocks can be blown up using TNT
* * ![breakable block](/screenshots/breakable_block.jpg)
* Unbreakable blocks have an event that must happen before they may be destroyed
* * ![unbreakable block](/screenshots/unbreakable_block.jpg)
### Spikes
* Spikes will damage the player if touched.
* * ![spikes](/screenshots/environmental_hazard.jpg)

## Attributions
* Sound Effects and Music were attained through [FesliyanStudios](https://www.fesliyanstudios.com).
* Graphics were produced by Lippelman515.