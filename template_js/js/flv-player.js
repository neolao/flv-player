/**
 * jQuery plugin for flash viewer
 */
var myListener = {
	onInit : function() {
		document.getElementById("myFlash").SetVariable("method:setUrl", this.href);
		document.getElementById("myFlash").SetVariable("method:play", "");
	},
	onFinished : function() {

	},
	bMuted: false,
	bChangingPosition: false,
	onUpdate : function() {
		document.getElementById("playerplay").style.display = (this.isPlaying == "true") ? "none"
				: "inline";
		document.getElementById("playerpause").style.display = (this.isPlaying == "true") ? "inline"
				: "none";
		document.getElementById("playermute").style.display = (this.bMuted) ? "none"
				: "inline";
		document.getElementById("playerunmute").style.display = (this.bMuted) ? "inline"
				: "none";
		if(!this.bChangingPosition){
			jQuery("#slider").slider({
				value : 100 * this.position / this.duration
			});			
		}
	},
	href: null,
	play : function() {
		document.getElementById("myFlash").SetVariable("method:play", "");			
	},
	start: function() {
	    jQuery("#placeholder").hide();
	    jQuery("#video").show();
	},
	pause: function(){
		document.getElementById("myFlash").SetVariable("method:pause", "");
	},
	mute: function(){
    	this.bMuted = true;
    	document.getElementById("myFlash").SetVariable("method:setVolume", 0);		
	},
	unmute: function(){
    	this.bMuted = false;
    	document.getElementById("myFlash").SetVariable("method:setVolume", 100);				
	},
	setPosition: function(){
        var position = jQuery("#slider").slider( "value" );
        document.getElementById("myFlash").SetVariable("method:setPosition", this.duration * position/100);
        this.bChangingPosition = false;
	},
	startSliding: function(){
		this.bChangingPosition = true;
	},
	oPopup: null,
	popup :function(evt) {
		if(!this.oPopup){
			this.oPopup = jQuery(
					'<div id="popup">' +
					'<div id="placeholder"><a href="javascript:jQuery.proxy(myListener.start, myListener)()">' +
					'<img src="images/play.svg" /></a></div>' +
					'<div id="video">' +
					'<object id="myFlash" type="application/x-shockwave-flash" data="player_flv_js.swf" width="320" height="240">' +
						'<param name="movie" value="player_flv_js.swf" />' +
						'<param name="AllowScriptAccess" value="always" />' +
						'<param name="FlashVars" value="listener=myListener&amp;interval=500&amp;useHandCursor=0&amp;bgcolor=0&amp;buffer=9" />' +
					'</object>' +
		            '<div id="playercontroller">' +
	                '<a href="javascript:jQuery.proxy(myListener.play, myListener)()" ><span id="playerplay"' +
					'class="glyphicon glyphicon-play"></span></a>' +
	                '<a href="javascript:jQuery.proxy(myListener.pause, myListener)()"><span id="playerpause"' +
					'class="glyphicon glyphicon-pause"></span></a>' +
					'<div id="slider"></div>' +                
					'<a href="javascript:jQuery.proxy(myListener.mute, myListener)()" >' +
					'<span id="playermute" class="glyphicon glyphicon-volume-off"></span></a>' +
	                '<a href="javascript:jQuery.proxy(myListener.unmute, myListener)()">' +
	                '<span id="playerunmute" class="glyphicon glyphicon-volume-up"></span></a>' +
	                '</div></div></div>' );
		}
		this.oPopup.dialog({ modal: true,  width: 328,
            height: 320, title: evt.target.title});
	    jQuery( "#slider" ).slider({value:0, min:0, max:100, 
	    	stop:jQuery.proxy(myListener.setPosition, myListener),
	    	start:jQuery.proxy(myListener.startSliding(), myListener)});
	    this.href = evt.target.href;
	    this.bChangingPosition = false;
	    jQuery("#placeholder").show();
	    jQuery("#video").hide();
	    this.position = 0;
		return false;
	}
};

(function($) {
	$.fn.flvRunner = function() {
		jQuery(this).click(jQuery.proxy(myListener.popup, myListener));
		return this;
	};
}(jQuery));