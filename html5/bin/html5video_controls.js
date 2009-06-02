$('document').ready(function(){
    //video = $('#myVideo');
    video = document.getElementById('myVideo');
    if (video.src === undefined) {
        video = new FlashFLVPlayer(document.getElementById('myVideoFlash'));
    }

    // Events
    video.addEventListener("play", function(event) {
        $('#log').val($('#log').val() + "[event] play\n");
    });
    video.addEventListener("pause", function(event) {
        $('#log').val($('#log').val() + "[event] pause\n");
    });

    $('#play').bind('click', function(event){
        video.play();
    });
    $('#pause').bind('click', function(event){
        video.pause();
    });
});
