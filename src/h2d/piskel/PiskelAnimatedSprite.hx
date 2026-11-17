package h2d.piskel;

import h3d.mat.Texture;
import haxe.crypto.Base64;
import haxe.Json;
import hxd.Pixels;
import hxd.Res;
import h2d.Tile;
import h2d.Object;

using StringTools;

typedef PiskelChunk = {
	var layout:Array<Array<Int>>;
	var base64PNG:String;
}

typedef PiskelLayer = {
	var name:String;
	var frameCount:Int;
	var chunks:Array<PiskelChunk>;
}

typedef PiskelData = {
	var name:String;
	var description:String;
	var fps:Int;
	var height:Int;
	var width:Int;
	var layers:Array<String>;
	var hiddenFrames:Array<Int>;
}

typedef PiskelFile = {
	var modelVersion:Int;
	var piskel:PiskelData;
}

class PiskelAnimatedSprite extends Object {
	final _data:PiskelFile;
	final _excluded:Array<String>;

	var chunks:Array<Dynamic> = [];

	var layers:Array<{name:String, spritesheet:Tile, frameCount:Int}> = [];

	var layerFrames:Array<Array<Tile>> = [];

	public var frames:Array<Tile> = [];

	public var anim:PiskelAnimationController;

	/**
	 * @param filePath the filepath to the directory containg the piskel file.
	 * @param excluded layers to exclude from the final sprite.
	 */
	public function new(filePath:String, ?excluded:Array<String>, ?parent:Object) {
		super(parent);

		if (!filePath.endsWith(".piskel"))
			throw new haxe.Exception("Tried to load non-piskel file.");

		var rawData = Res.load(filePath).toText();

		this._data = cast Json.parse(rawData);
		this._excluded = excluded;

		makeLayers(this._data.piskel.layers);

		anim = new PiskelAnimationController(this, this.frames);
	}

	function makeLayers(layers:Array<String>) {
		for (layer in layers) {
			var toLayer:PiskelLayer = cast Json.parse(layer);

			if (_excluded != null && _excluded.contains(toLayer.name))
				continue;

			for (chunk in toLayer.chunks) {
				var rawImg:String = chunk.base64PNG;

				if (!rawImg.startsWith("data:image/png;base64,"))
					throw new haxe.Exception("This .piskel file contains corrupted data!");
				rawImg = rawImg.substr("data:image/png;base64,".length);

				var pngBytes = Base64.decode(rawImg);
				var pngData:haxe.io.BytesInput = new haxe.io.BytesInput(pngBytes);
				var reader = new format.png.Reader(pngData);
				var formattedData:format.png.Data = reader.read();
				var headerData = format.png.Tools.getHeader(formattedData);
				var uncompressedData = format.png.Tools.extract32(formattedData);

				Pixels.alloc(headerData.width, headerData.height, RGBA);
				var pixels = new Pixels(headerData.width, headerData.height, uncompressedData, BGRA);

				var tile = Tile.fromPixels(pixels);

				this.layers.push({name: toLayer.name, spritesheet: tile, frameCount: toLayer.frameCount});
			}
		}

		makeLayerFrames();
		makeFinalFrames();
	}

	function makeLayerFrames() {
		for (layer in layers) {
			var img = layer.spritesheet;
			var frames:Array<Tile> = [];
			for (i in 0...layer.frameCount) {
				if (_data.piskel.hiddenFrames.contains(i + 1))
					continue;
				frames.push(img.sub(0 + this._data.piskel.width * i, 0, this._data.piskel.width, this._data.piskel.height));
			}

			layerFrames.push(frames);
		}
	}

	function makeFinalFrames() {
		//  +--------------------+
		//  |  |  |  |  |  |  |  |
		//  |--------------------|
		//  |  |  |  |  |  |  |  |
		//  |--------------------|           this comment is important i promise
		//  |  |  |  |  |  |  |  |
		//  |--------------------|
		//  |  |  |  |  |  |  |  |
		//  |--------------------|
		//  |  |  |  |  |  |  |  |
		//  +--------------------+

		if (layers.length == 0)
			return;

		for (i in 0...this.layers[0].frameCount) {
			var drawObj:Object = new Object();
			var drawTex:Texture = new Texture(this._data.piskel.width, this._data.piskel.height, [Target]);
			for (timeline in layerFrames) {
				var frame = timeline[i];
				drawObj.addChild(new Bitmap(frame));
			}

			drawObj.drawTo(drawTex);

			var finalFrame = Tile.fromTexture(drawTex);
			this.frames.push(finalFrame);
		}
	}
}
