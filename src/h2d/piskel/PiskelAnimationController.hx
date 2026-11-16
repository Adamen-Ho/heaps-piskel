package h2d.piskel;

import haxe.ds.StringMap;
import h2d.Anim;

class PiskelAnimationController {
	public var anims(default, null) = new StringMap<Anim>();

	public var frames:Array<Tile>;

	public var parent:PiskelAnimatedSprite;

	public var currentAnimation:String;

	public function new(parent:PiskelAnimatedSprite, frames:Array<Tile>) {
		this.parent = parent;
		this.frames = frames;
		trace('initialized piskel animations with a total framecount of ${frames.length}');
		registerAnimation("default", 0, frames.length);
		currentAnimation = "default";
	}

	public function play(?name:String = "default") {
		if (currentAnimation != null) {
			var curPlaying = anims.get(currentAnimation);
			curPlaying.pause = true;
			curPlaying.currentFrame = 0;
			curPlaying.alpha = 0;
		}
		var toPlay = anims.get(name);
		if (toPlay == null)
			trace('No animation found with name $name!');
		else {
			toPlay.play(toPlay.frames);
			toPlay.alpha = 1;
			toPlay.currentFrame = 0;
			toPlay.pause = false;
		}
	}

	public function pause() {
		if (currentAnimation != null) {
			var toPause = anims.get(currentAnimation);
			toPause.pause = true;
		}
	}

	public function resume() {
		if (currentAnimation != null) {
			var toResume = anims.get(currentAnimation);
			toResume.pause = false;
		}
	}

	public function stop() {
		if (currentAnimation != null) {
			var toStop = anims.get(currentAnimation);
			toStop.pause = true;
			toStop.currentFrame = 0;
		}
	}

	public function registerAnimation(name:String, startIndex:Int, endIndex:Int, ?flipX:Bool = false, ?flipY:Bool = false):Void {
		@:privateAccess var toAdd = new Anim(frames.slice(startIndex, endIndex), this.parent._data.piskel.fps, this.parent);
		if (flipX)
			toAdd.scaleX = -1;
		if (flipY)
			toAdd.scaleY = -1;

		toAdd.alpha = 0;
		toAdd.pause = true;

		anims.set(name, toAdd);
	}
}
