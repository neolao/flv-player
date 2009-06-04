/**
 * links:
 * http://ejohn.org/blog/javascript-getters-and-setters/
 * http://robertnyman.com/2009/05/28/getters-and-setters-with-javascript-code-samples-and-demos/
 * http://annevankesteren.nl/2009/01/gettters-setters
 */

/**
 * Constructor
 */
var FlashFLVPlayer = function(htmlElement)
{
    // Constants
    this.NETWORK_EMPTY = 0;
    this.NETWORK_IDLE = 1;
    this.NETWORK_LOADING = 2;
    this.NETWORK_LOADED = 3;
    this.NETWORK_NO_SOURCE = 4;
    this.HAVE_NOTHING = 0;
    this.HAVE_METADATA = 1;
    this.HAVE_CURRENT_DATA = 2;
    this.HAVE_FUTURE_DATA = 3;
    this.HAVE_ENOUGH_DATA = 4;
    this.MEDIA_ERR_ABORTED = 1;
    this.MEDIA_ERR_NETWORK = 2;
    this.MEDIA_ERR_DECODE = 3;
    this.MEDIA_ERR_SRC_NOT_SUPPORTED = 4;

    // Variables
    this.error = null;
    this.src = "";
    this.currentSrc = "";
    this.networkState = this.NETWORK_EMPTY;
    this.autobuffer = true;
    this.buffered = null;
    this.readyState = this.HAVE_NOTHING;
    this.seeking = false;
    this.currentTime = 0;
    this.startTime = 0;
    this.duration = 0;
    this.paused = true;
    this.defaultPlaybackRate = 0;
    this.playbackRate = 0;
    this.played = null;
    this.seekable = null;
    this.ended = false;
    this.autoplay = false;
    this.loop = false;
    this.controls = false;
    this.volume = 0;
    this.muted = false;
    this.width = 0;
    this.height = 0;
    this.videoWidth = 0;
    this.videoHeight = 0;
    this.poster = "";

    // Private variables
    this._flash = htmlElement;
    this._eventListeners = new Object();

    // Getters / Setters
    //this.__defineSetter__("currentTime", this.setCurrentTime);

    // Default event handlers
    this.addEventListener("play", this._playHandler);
    this.addEventListener("pause", this._pauseHandler);
    this.addEventListener("seeked", this._seekedHandler);
    this.addEventListener("loadstart", this._loadstartHandler);
    this.addEventListener("progress", this._progressHandler);
    this.addEventListener("load", this._loadHandler);
    this.addEventListener("durationchange", this._durationchangeHandler);
    this.addEventListener("timeupdate", this._timeupdateHandler);
    this.addEventListener("loadedmetadata", this._loadedmetadataHandler);
    this.addEventListener("playing", this._playingHandler);
    this.addEventListener("ended", this._endedHandler);
    this.addEventListener("canplay", this._canplayHandler);
    this.addEventListener("canplaythrough", this._canplaythroughHandler);
    this.addEventListener("error", this._errorHandler);
};
FlashFLVPlayer.prototype = {
    /**
     * Indicates the Javascript is ready for the Flash
     */
    isReady: function()
    {
        return true;
    },

    /**
     * Add event listener
     */
    addEventListener: function(type, callback)
    {
        if (!this._eventListeners[type]) {
            this._eventListeners[type] = new Array();
        }
        this._eventListeners[type].push(callback);
    },

    /**
     * Dispatch an event
     */
    dispatchEvent: function(event)
    {
        var type = event.type;

        // Bug: the flash continues to dispatch event after a refresh
        if (type != "error" && type != "loadstart" && this.networkState == this.NETWORK_EMPTY) {
            return;
        }

        // Dispatch to all listeners
        // Quick delegate with "apply"
        if (this._eventListeners[type]) {
            for (var i = 0; i < this._eventListeners[type].length; i++) {
                this._eventListeners[type][i].apply(this, [event]);
            }
        }
    },

    /**
     * Load and play the video
     */
    load: function()
    {
        this._flash.play();
    },


    /**
     * Play the video
     */
    play: function()
    {
        this._flash.play();
    },

    /**
     * Pause
     */
    pause: function()
    {
        this._flash.pause();
    },

    /**
     * Get the currentTime
     *
     * @return             The value
     */
    getCurrentTime: function()
    {
        return this.currentTime;
    },

    /**
     * Set the new currentTime
     *
     * @param   value      The new value
     */
    setCurrentTime: function(value)
    {
        this.currentTime = value;
    },

    /**
     * Set the new duration
     *
     * @param   value      The new value
     */
    setDuration: function(value)
    {
        this.duration = value;
    },

    /**
     * Set the video width
     *
     * @param   value      The value
     */
    setVideoWidth: function(value)
    {
        this.videoWidth = value;
    },

    /**
     * Set the video height
     *
     * @param   value      The value
     */
    setVideoHeight: function(value)
    {
        this.videoHeight = value;
    },

    /**
     * Set the playback rate
     *
     * @param   value      The value
     */
    setPlaybackRate: function(value)
    {
        this.defaultPlaybackRate = value;
        this.playbackRate = value;
    },


    /**
     * "play" event handler
     *
     * @param   event       The event
     */
    _playHandler: function(event)
    {
        this.paused = false;
    },

    /**
     * "pause" event handler
     *
     * @param   event       The event
     */
    _pauseHandler: function(event)
    {
        this.paused = true;
    },

    /**
     * "durationchange" event handler
     *
     * @param   event       The event
     */
    _durationchangeHandler: function(event)
    {

    },

    /**
     * "timeupdate" event handler
     *
     * @param   event       The event
     */
    _timeupdateHandler: function(event)
    {

    },

    /**
     * "loadedmetadata" event handler
     *
     * @param   event       The event
     */
    _loadedmetadataHandler: function(event)
    {
        if (this.readyState < this.HAVE_METADATA) {
            this.readyState = this.HAVE_METADATA;
        }
    },

    /**
     * "seeked" event handler
     *
     * @param   event       The event
     */
    _seekedHandler: function(event)
    {

    },

    /**
     * "playing" event handler
     *
     * @param   event       The event
     */
    _playingHandler: function(event)
    {
        if (this.readyState < this.HAVE_FUTURE_DATA) {
            this.readyState = this.HAVE_FUTURE_DATA;
        }
        this.paused = false;
        this.seeking = false;
    },

    /**
     * "ended" event handler
     *
     * @param   event       The event
     */
    _endedHandler: function(event)
    {
        this.ended = true;
    },

    /**
     * "loadstart" event handler
     *
     * @param   event       The event
     */
    _loadstartHandler: function(event)
    {
        this.networkState = this.NETWORK_LOADING;
    },

    /**
     * "progress" event handler
     *
     * @param   event       The event
     */
    _progressHandler: function(event)
    {
        this.networkState = this.NETWORK_LOADING;
    },

    /**
     * "load" event handler
     *
     * @param   event       The event
     */
    _loadHandler: function(event)
    {
        this.networkState = this.NETWORK_LOADED;
    },

    /**
     * "canplay" event handler
     *
     * @param   event       The event
     */
    _canplayHandler: function(event)
    {
        if (this.readyState < this.HAVE_FUTURE_DATA) {
            this.readyState = this.HAVE_FUTURE_DATA;
        }
    },

    /**
     * "canplaythrough" event handler
     *
     * @param   event       The event
     */
    _canplaythroughHandler: function(event)
    {
        if (this.readyState < this.HAVE_ENOUGH_DATA) {
            this.readyState = this.HAVE_ENOUGH_DATA;
        }
    },

    /**
     * "error" event handler
     *
     * @param   event       The event
     */
    _errorHandler: function(event)
    {
        this.error = new Object();
        switch (event.code) {
            case "no_source":
                this.networkState = this.NETWORK_NO_SOURCE;
                this.error.code = this.MEDIA_ERR_SRC_NOT_SUPPORTED;
                break;
            default:
                this.error.code = 0;
        }
    }


};

