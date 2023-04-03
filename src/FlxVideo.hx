package;

import flixel.FlxBasic;
import flixel.FlxG;
import openfl.events.NetStatusEvent;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;

typedef FlxVideoOptions = {
	/**
	 * Path to video
	 */
	final source: String;
	/**
	 * x Position of the video. Defaults to 0
	 */
	final ?x: Float;
	/**
	 * y Position of the video. Defaults to 0
	 */
	final ?y: Float;
	/**
	 * width of the video. Defaults to 1280
	 */
	final ?width: Int;
	/**
	 * height of the video. Defaults to 720
	 */
	final ?height: Int;
	/**
	 * Indicates if video should play automatically. Set to false by default
	 */
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