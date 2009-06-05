package
{
import flash.display.Sprite;
import flash.display.StageScaleMode;
import flash.display.StageAlign;
import flash.external.ExternalInterface;
import flash.utils.Timer;
import flash.events.Event;
import flash.events.NetStatusEvent;
import flash.events.TimerEvent;
import flash.media.Video;
import flash.media.SoundTransform;
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
     * The current time
     */
    protected var _currentTime:Number = 0;

    /**
     * The current volume
     */
    protected var _currentVolume:Number = 1;
    /**
     * Indicates the player is ready
     */
    protected var _isReady:Boolean = false;

    /**
     * The meta data of the video
     */
    protected var _metaData:Object;

    /**
     * Indicates the loading data is started
     */
    protected var _loadStarted:Boolean = false;

    /**
     * Indicates the loading data is finished
     */
    protected var _loaded:Boolean = false;
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
            ExternalInterface.addCallback("seek", this._seek);
            ExternalInterface.addCallback("volume", this._volume);

            if (this._checkJavascriptReady()) {
                this._ready();
            } else {
                var timer:Timer = new Timer(500);
                timer.addEventListener(TimerEvent.TIMER, this._timerHandler);
                timer.start();
            }
        }

        this.addEventListener(Event.ENTER_FRAME, this._enterFrameHandler);
    }

    /**
     * Check if the Javascript is ready
     *
     * return true if the Javascript is ready, false otherwise
     */
    protected function _checkJavascriptReady():Boolean
    {
        var isReady:Boolean = ExternalInterface.call(this._javascriptListener+".isReady");
        this._isReady = isReady;
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
        this._connection.addEventListener(NetStatusEvent.NET_STATUS, this._netStatusHandler);
        this._connection.connect(null);

        this._stream = new NetStream(this._connection);
        this._stream.addEventListener(NetStatusEvent.NET_STATUS, this._netStatusHandler);
        this._stream.client = new Object();
        this._stream.client.onMetaData = this._metaDataHandler;

        this._video = new Video();
        this._video.attachNetStream(this._stream);
        this.addChild(this._video);

        /*
        this._video.width = this.stage.stageWidth;
        this._video.height = this.stage.stageHeight;
        this._video.width = 320;
        this._video.height = 240;
        */
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

        var jsEvent:Object = new Object();
        jsEvent.type = "play";
        this._dispatchEventToJavascript(jsEvent);
    }

    /**
     * Pause
     */
    protected function _pause():void
    {
        this._stream.pause();

        // Dispatch timeupdate event
        jsEvent = new Object();
        jsEvent.type = "timeupdate";
        this._dispatchEventToJavascript(jsEvent);

        // Dispatch pause event
        var jsEvent:Object = new Object();
        jsEvent.type = "pause";
        this._dispatchEventToJavascript(jsEvent);
    }

    /**
     * Seek
     */
    protected function _seek(offset:Number):void
    {
        this._stream.seek(offset);

        var jsEvent:Object = new Object();
        jsEvent.type = "seeking";
        this._dispatchEventToJavascript(jsEvent);
    }

    /**
     * Volume
     */
    protected function _volume(value:Number):void
    {
        var transform:SoundTransform = this._stream.soundTransform;
        transform.volume = value;
        this._stream.soundTransform = transform;
    }

    /**
     * "metaData" event handler
     *
     * @param   info        The info object
     */
    protected function _metaDataHandler(info:Object):void
    {
        this._metaData = info;

        // duration
        this._callJavascript("setDuration", info.duration);
        var jsEvent:Object = new Object();
        jsEvent.type = "durationchange";
        this._dispatchEventToJavascript(jsEvent);

        // width
        this._callJavascript("setVideoWidth", info.width);

        // height
        this._callJavascript("setVideoHeight", info.height);

        // framerate
        //this._callJavascript("setPlaybackRate", info.framerate);
        //jsEvent = new Object();
        //jsEvent.type = "ratechange";
        //this._dispatchEventToJavascript(jsEvent);

        // The metadata is loaded
        jsEvent = new Object();
        jsEvent.type = "loadedmetadata";
        this._dispatchEventToJavascript(jsEvent);
    }

    /**
     *The enter frame event handler
     *
     * @param   event       The event
     */
    protected function _enterFrameHandler(event:Event):void
    {
        // video size
        // Sometimes, the sprite is not already added to the stage (Firefox 3.1, MacOSX)
        // So, I wait until the stage exists and I set the video size
        if (this.stage && (this._video.width != this.stage.stageWidth || this._video.height != this.stage.stageHeight)) {
            this._video.width = this.stage.stageWidth;
            this._video.height = this.stage.stageHeight;
        }

        // The javascript player is ready
        if (this._isReady) {
            var jsEvent:Object;

            // event "loadstart"
            if (!this._loadStarted && this._stream.bytesLoaded > 0) {
                this._loadStarted = true;

                jsEvent = new Object();
                jsEvent.type = "loadstart";
                this._dispatchEventToJavascript(jsEvent);
            }

            // event "progress"
            if (this._loadStarted && !this._loaded) {
                jsEvent = new Object();
                jsEvent.type = "progress";
                this._dispatchEventToJavascript(jsEvent);
            }

            // event "load"
            if (!this._loaded && this._loadStarted && this._stream.bytesLoaded >= this._stream.bytesTotal) {
                this._loaded = true;

                jsEvent = new Object();
                jsEvent.type = "load";
                this._dispatchEventToJavascript(jsEvent);
            }

            // Time check
            var jsCurrentTime:Number = this._callJavascript("getCurrentTime");
            var currentTimeChanged:Boolean = false;
            if (this._currentTime == jsCurrentTime) {
                //if (this._stream.time != this._currentTime) {
                //    currentTimeChanged = true;
                //}
                this._currentTime = this._stream.time;
            } else {
                this._currentTime = jsCurrentTime;
                this._seek(this._currentTime);
                currentTimeChanged = true;
            }
            this._callJavascript("setCurrentTime", this._currentTime);

            // If a new time is set, dispatch the event
            if (currentTimeChanged) {
                jsEvent = new Object();
                jsEvent.type = "timeupdate";
                this._dispatchEventToJavascript(jsEvent);
            }

            // Volume check
            var jsVolume:Number = this._callJavascript("getVolume");
            var volumeChanged:Boolean = false;
            if (this._currentVolume != jsVolume) {
                this._volume(jsVolume);
                this._currentVolume = jsVolume;
                volumeChanged = true;
            }
            this._callJavascript("setVolume", this._currentVolume);

            // If a new volume is set, dispatch the event
            if (volumeChanged) {
                jsEvent = new Object();
                jsEvent.type = "volumeupdate";
                this._dispatchEventToJavascript(jsEvent);
            }
        }
    }

    /**
     * The net status event handler
     *
     * @param   event       The event
     */
    protected function _netStatusHandler(event:NetStatusEvent):void
    {
        var jsEvent:Object = new Object();

        switch (event.info.code) {
            default:
                jsEvent.type = "unknown";
                break;
            case "NetStream.Play.StreamNotFound":
                jsEvent.type = "error";
                jsEvent.code = "no_source";
                break;
            case "NetStream.Play.Start":
                jsEvent.type = "playing";
                break;
            case "NetStream.Play.Stop":
                jsEvent.type = "ended";
                break;
            case "NetStream.Pause.Notify":
                jsEvent.type = "pause";
                break;
            case "NetStream.Seek.Notify":
                jsEvent.type = "seeked";
                break;
        }
        if (this._loadStarted || jsEvent.type == "error") {
            this._dispatchEventToJavascript(jsEvent);
        }
        //ExternalInterface.call("console.log", event.info.code);
    }

    /**
     * Dispatch an event to javascript
     *
     * @param   event       The event
     */
    protected function _dispatchEventToJavascript(event:Object):void
    {
        ExternalInterface.call(this._javascriptListener + ".dispatchEvent", event);
    }

    /**
     * Call a javascript method
     *
     * @param   methodName      The javascript method name
     * @param   parameters      The parameters
     * @return                  The method result
     */
    protected function _callJavascript(methodName:String, ...parameters):*
    {
        var jsParameters:Array = new Array();
        jsParameters.push(this._javascriptListener + "." + methodName);
        for each (var parameter:* in parameters) {
            jsParameters.push(parameter);
        }

        return ExternalInterface.call.apply(ExternalInterface, jsParameters);
    }
}
}
