/**
 * Constructor
 */
var FlashFLVPlayer = function(htmlElement)
{
    this.video = htmlElement;
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
    addEventListener: function()
    {
        //loadedmetadata
    },

    /**
     * Play the video
     */
    play: function()
    {
        this.video.play();
    },

    /**
     * Pause
     */
    pause: function()
    {
        this.video.pause();
    }
};

