package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class GameState extends FlxState {

	var vid: FlxVideo;
  var title: FlxText;

	override public function create() {
		super.create();

    title = new FlxText(0, 200, 0, "Press SPACE to play", 80);
    title.screenCenter(X);
    title.scrollFactor.set(0, 0);
    add(title);

		vid = new FlxVideo({source: 'assets/videos/globe.ogg'});
		vid.finishCallback = () -> trace('It\'s done');
	}

	override function update(_elapsed: Float) {
    if (FlxG.keys.pressed.SPACE) {
      vid.play();
      title.destroy();
    }
		if (FlxG.keys.pressed.P) {
			vid.pause();
		}
		if (FlxG.keys.pressed.R) {
			vid.resume();
		}
  }
}
