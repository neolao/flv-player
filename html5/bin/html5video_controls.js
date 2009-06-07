var trace = function(message)
{
    $('#log').val($('#log').val() + message + "\n");
    $('#log').scrollTop($('#log').height());
};
var timeoutHandler = function()
{
    $('#time').text(video.currentTime);
    $('#playbackRate').text(video.playbackRate);
    $('#defaultPlaybackRate').text(video.defaultPlaybackRate);
    $('#paused').text(video.paused);
    $('#volume').text(video.volume);
    $('#seeking').text(video.seeking);
    setTimeout("timeoutHandler()", 100);
};
$('document').ready(function(){
    video = document.getElementById('myVideo');
    if (video.currentSrc === undefined) {
        var att = { data: "player_flv_html5.swf?4", width: "320", height: "240", id: "myFlash", name: "myFlash"};
        var params = { flashvars: "listener=video&src=KyodaiNoGilga.flv", swliveconnect: "true"};
        flash = swfobject.createSWF(att, params, "myVideoFlash");
        video = new FlashFLVPlayer(flash);
    }

    // Events
    video.addEventListener("loadstart", function(event) {
        trace("[event] loadstart");
    });
    video.addEventListener("load", function(event) {
        trace("[event] load");
    });
    video.addEventListener("play", function(event) {
        trace("[event] play");
    });
    video.addEventListener("ended", function(event) {
        trace("[event] ended");
    });
    video.addEventListener("pause", function(event) {
        trace("[event] pause");
    });
    video.addEventListener("playing", function(event) {
        trace("[event] playing");
    });
    video.addEventListener("seeked", function(event) {
        //trace("[event] seeked");
    });
    video.addEventListener("loadedmetadata", function(event) {
        trace("[event] loadedmetadata");
        $('#videoWidth').text(video.videoWidth);
        $('#videoHeight').text(video.videoHeight);
    });
    video.addEventListener("durationchange", function(event) {
        trace("[event] durationchange : " + video.duration);
        $('#duration').text(video.duration);
    });
    video.addEventListener("timeupdate", function(event) {
        //trace("[event] timeupdate : " + video.currentTime);
    });
    video.addEventListener("error", function(event) {
        trace("[event] error : " + video.networkState);
    });
    video.addEventListener("canplay", function(event) {
        trace("[event] canplay");
    });
    video.addEventListener("canplaythrough", function(event) {
        trace("[event] canplaythrough");
    });
    video.addEventListener("volumechange", function(event) {
        trace("[event] volumechange : " + video.volume);
    });






    $('#play').bind('click', function(event){
        video.play();
    });

    $('#pause').bind('click', function(event){
        video.pause();
    });

    $('#setCurrentTime').bind('click', function(event){
        video.currentTime = $('#currentTimeField').val();
    });

    $('#setVolume').bind('click', function(event){
        video.volume = parseFloat( $('#volumeField').val() );
    });


    setTimeout("timeoutHandler()", 100);
});
