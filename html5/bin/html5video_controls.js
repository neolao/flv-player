$('document').ready(function(){
    //video = $('#myVideo');
    video = document.getElementById('myVideo');
    if (video.src === undefined) {
        video = new FlashFLVPlayer(document.getElementById('myVideoFlash'));
    }

    $('#play').bind('click', function(event){
        video.play();
    });
    $('#pause').bind('click', function(event){
        video.pause();
    });
});
