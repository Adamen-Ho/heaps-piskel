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
			anims.get(currentAnimation).pause();
		}
		var toPlay = anims.get(name);
		if (toPlay == null)
			trace('No animation found with name $name!');
		else
			toPlay.play(toPlay.frames);
	}

	public function pause() {
		if (currentAnimation != null) {
			var toPause = anims.get(currentAnimation);
			toPause.pause();
		}
	}

	public function registerAnimation(name:String, startIndex:Int, endIndex:Int):Void {
		@:privateAccess anims.set(name, new Anim(frames.slice(startIndex, endIndex), this.parent._data.piskel.fps, this.parent));
	}
}
