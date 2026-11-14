package h2d.piskel;

import haxe.ds.StringMap;
import h2d.Anim;

class PiskelAnimationController
{
  public var anims(default, null) = new StringMap<Anim>();

  public var frames:Array<Tile>;

  public var parent:PiskelAnimatedSprite;

  public function new(parent:PiskelAnimatedSprite, frames:Array<Tile>)
  {
    this.parent = parent;
    this.frames = frames;
    trace('initialized piskel animations with a total framecount of ${frames.length}');
    registerAnimation("default", 0, frames.length);
  }

  public function play(?name:String = "default")
  {
    trace('playing anim $name');
    var toPlay = anims.get(name);
    trace('loaded animation $name: ${toPlay.frames}');
    toPlay.play(toPlay.frames);
  }

  public function registerAnimation(name:String, startIndex:Int, endIndex:Int):Void
  {
    @:privateAccess anims.set(name, new Anim(frames.slice(startIndex, endIndex), this.parent._data.piskel.fps, this.parent));
  }
}
