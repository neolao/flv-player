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

    // Variables
    this.error = null;
    this.src = "";
    this.currentSrc = "";
    this.networkState = 0;
    this.autobuffer = true;
    this.buffered = null;
    this.readyState = 0;
    this.seeking = false;
    this.currentTime = 0;
    this.startTime = 0;
    this.duration = 0;
    this.paused = false;
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

    // Private variables
    this._flash = htmlElement;
    this._eventListeners = new Object();
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
        if (this._eventListeners[type]) {
            for (var i = 0; i < this._eventListeners[type].length; i++) {
                this._eventListeners[type][i](event);
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
        this.dispatchEvent({type:"play"});
    },

    /**
     * Pause
     */
    pause: function()
    {
        this._flash.pause();
        this.dispatchEvent({type:"pause"});
    }
};

