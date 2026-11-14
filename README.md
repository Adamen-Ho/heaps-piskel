# heaps-piskel

`heaps-piskel` provides .piskel file parsing for the [Heaps](https://github.com/HeapsIO/heaps) game engine.

## Installation

- Install by running `haxelib install heaps-piskel`.
- Add `-lib heaps-piskel` to your project's `.hxml` file.

## Usage

```haxe
import h2d.piskel.PiskelAnimatedSprite;

// automatically parses .piskel file and attaches it to the parent `Object` if one is provided.
// specific frames may be registered as an animation through sprite.anim.registerAnimation()...
var myPiskelSprite:PiskelAnimatedSprite = new PiskelAnimatedSprite('path/to/my/file.piskel', s2d);
```
