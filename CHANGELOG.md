# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-11-16

### Changes:

- Added the `pause()`, `resume()`, and `stop()` functions to `PiskelAnimationController`.
- Added the `excluded` paramater to the constructor of `PiskelAnimatedSprite`.
  - This lets you exclude layers from being rendered in the final sprite. Once the sprite has been instantiated, those layers can only be brought back by instantiating a new sprite.
  - [PR #1](https://github.com/Adamen-Ho/heaps-piskel/pull/1) by `realvirtu` on GitHub.
- Other general improvements to the animation controller.

### Fixes:

- Fixed animations not hiding themselves after they were stopped, or another animation was played.

## [1.0.0] - 2026-11-13

Initial release.
