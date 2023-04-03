package;

import flixel.FlxBasic;
import flixel.FlxG;

import openfl.events.NetStatusEvent;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;

typedef FlxVideoOptions = {
	final source: String;
	final ?x: Float;
	final ?y: Float;
	final ?width: Int;
	final ?height: Int;
	final ?smoothing: Bool;
	final ?autoplay: Bool;
}

class FlxVideo extends FlxBasic {
	var video: Video;
	var netStream: NetStream;
	var videoSource: String;

	public var finishCallback: Void -> Void;

	public function new(options: FlxVideoOptions) {
		super();

		final width = options.width != null ? options.width : 1280;
		final height = options.height != null ? options.height : 720;
    final autoplay = options.autoplay != null ? options.autoplay : false;

		videoSource = options.source;
		video = new Video(width, height);

		video.x = options.x != null ? options.x : 0;
		video.y = options.y != null ? options.y : 0;
		video.smoothing = options.smoothing || true;

		FlxG.addChildBelowMouse(video);

		var netConnection = new NetConnection();
		netConnection.connect(null);

		netStream = new NetStream(netConnection);
		netStream.client = {onMetaData: client_onMetaData};
		netConnection.addEventListener(
			NetStatusEvent.NET_STATUS,
			netConnection_onNetStatus
		);

    if (autoplay) this.play();
	}

	public function pause() {
		netStream.pause();
	}

	public function play() {
		netStream.play(videoSource);
	}

  public function resume() {
    netStream.resume();
  }

	function client_onMetaData(metaData: Dynamic) {
		video.attachNetStream(netStream);
	}

	function netConnection_onNetStatus(event: NetStatusEvent) {
		if (event.info.code == 'NetStream.Play.Complete') finishVideo();
	}

	function finishVideo() {
		netStream.dispose();
		FlxG.removeChild(video);

		if (finishCallback != null) finishCallback();
	}
}