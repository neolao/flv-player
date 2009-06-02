package
{
import flash.display.Sprite;
import flash.display.StageScaleMode;
import flash.display.StageAlign;
import flash.external.ExternalInterface;
import flash.utils.Timer;
import flash.events.TimerEvent;
import flash.media.Video;
import flash.net.NetConnection;
import flash.net.NetStream;

[SWF(width="200", height="200", backgroundColor="#000000", frameRate="48")]
public class FLVPlayer extends Sprite
{
    /**
     * The javascript listener
     */
    protected var _javascriptListener:String = "";

    /**
     * The net connection
     */
    protected var _connection:NetConnection;

    /**
     * The net stream
     */
    protected var _stream:NetStream;
    /**
     * The video object
     */
    protected var _video:Video;

    /**
     * The video URL
     */
    protected var _videoURL:String = "";

    /**
     * Indicates the video is playing for the first time
     */
    protected var _firstPlay:Boolean = true;

    /**
     * Constructor
     */
    public function FLVPlayer()
    {
        super();

        // Initialize the stage
        this.stage.scaleMode = StageScaleMode.NO_SCALE;
        this.stage.align = StageAlign.TOP_LEFT;

        // Flash parameters
        var parameters:Object = this.root.loaderInfo.parameters;
        this._javascriptListener = parameters.listener;
        this._videoURL = parameters.src;

        // Initialize external interface
        if (ExternalInterface.available) {
            ExternalInterface.addCallback("play", this._play);
            ExternalInterface.addCallback("pause", this._pause);

            if (this._checkJavascriptReady()) {
                this._ready();
            } else {
                var timer:Timer = new Timer(500);
                timer.addEventListener(TimerEvent.TIMER, this._timerHandler);
                timer.start();
            }
        }
    }

    /**
     * Check if the Javascript is ready
     *
     * return true if the Javascript is ready, false otherwise
     */
    protected function _checkJavascriptReady():Boolean
    {
        var isReady:Boolean = ExternalInterface.call(this._javascriptListener+".isReady");
        return isReady;
    }

    /**
     * Timer handler
     *
     * @param   event   The event
     */
    protected function _timerHandler(event:TimerEvent):void
    {
        if (this._checkJavascriptReady()) {
            this._ready();
        }
    }

    /**
     * The javascript is ready
     */
    protected function _ready():void
    {
        this._connection = new NetConnection();
        this._connection.connect(null);
        this._stream = new NetStream(this._connection);
        this._video = new Video();
        this._video.attachNetStream(this._stream);
        this.addChild(this._video);
        this._video.width = this.stage.stageWidth;
        this._video.height = this.stage.stageHeight;
    }

    /**
     * Play the video
     */
    protected function _play():void
    {
        if (this._firstPlay) {
            this._stream.play(this._videoURL);
            this._firstPlay = false;
        } else {
            this._stream.resume();
        }
    }

    /**
     * Pause
     */
    protected function _pause():void
    {
        this._stream.pause();
    }
}
}
