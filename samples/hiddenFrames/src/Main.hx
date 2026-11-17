package;

import h3d.Engine;
import h2d.piskel.PiskelAnimatedSprite;
import hxd.Res;

class Main extends hxd.App {
	public function new() {
		super();
	}

	override function init() {
		super.init();
		Res.initEmbed();
		Engine.getCurrent().backgroundColor = 0x0000FF;
		// if you see a blue or pink square, there is a problem with the haxelib.
		// please report this on GitHub.
		var spriteWithHiddenFrames = new PiskelAnimatedSprite('hiddenFrames.piskel', this.s2d);
		spriteWithHiddenFrames.x = this.s2d.width / 2;
		spriteWithHiddenFrames.y = this.s2d.height / 2;
		spriteWithHiddenFrames.anim.play();
		spriteWithHiddenFrames.scale(50);
		trace(spriteWithHiddenFrames.frames.length);
	}

	static function main() {
		new Main();
	}
}
