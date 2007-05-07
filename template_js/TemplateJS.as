/*
Version: MPL 1.1

The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in
compliance with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS"
basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
License for the specific language governing rights and limitations
under the License.

The Original Code is flvplayer (http://code.google.com/p/flvplayer/).

The Initial Developer of the Original Code is neolao (neolao@gmail.com).
*/
import flash.external.*;
/** 
 * Template for javascript controls
 * 
 * @author		neolao <neo@neolao.com> 
 * @version 	0.3.1 (07/05/2007)
 * @license		http://creativecommons.org/licenses/by-sa/3.0/deed.fr
 */ 
class TemplateJS extends ATemplate
{
	// ------------------------------ CONSTANTS --------------------------------
	
	// ------------------------------ VARIABLES --------------------------------
	/**
	 * Video instance controller
	 */
	public var controller:PlayerDefault;
	/**
	 * Javascript object listener
	 */
	private var _listener:String = "";
	/**
	 * Temporary Javascript object listener
	 */
	private var _listenerTemp:Object;
	/**
	 * Interval update in milliseconds	 */
	private var _intervalUpdate:Number = 1000;
	/**
	 * Stage listener	 */
	private var _stageListener:Object;
	/**
	 * The init feedback is launched	 */
	private var _isInit:Boolean = false;
	
	/*============================= CONSTRUCTOR ==============================*/
	/*========================================================================*/
	/**
	 * Constructor
	 */
	public function TemplateJS()
	{
		super();
		
		// Temporary Javascript object listener
		_listenerTemp = new Object();
		
		// Javascript object listener
		if (_root.listener) {
			_listener = _root.listener + ".";
		}
		
		// Stage listener
		_stageListener = new Object();
		_stageListener.onResize = this.delegate(this, _onResize);
		Stage.addListener(_stageListener);
		
		// Use ExternalInterface
		if (_root.useexternalinterface) {
			getURL("javascript:"+_listener+"oooupdate=function(o){eval(o);};void(0);");
		}
		
		// Interval update
		if (_root.interval) {
			_intervalUpdate = Number(_root.interval);
		}
		setInterval(this, "_enterFrame", _intervalUpdate);
	}
	/**
	 * Lancé par mtasc
	 */
	static function main():Void
	{
		_root.method = new TemplateJS();
		var player:PlayerBasic = new PlayerDefault(_root.method);
	}
	/*======================= END = CONSTRUCTOR = END ========================*/
	/*========================================================================*/
	
	/*=============================== PRIVATE ================================*/
	/*========================================================================*/
	/**
	 * Initialize the key manager
	 */
	private function _initKey()
	{
		var o:Object = new Object();
		o.onKeyUp = this.delegate(this, function() 
		{
			this.sendToJavascript(this._listener+"onKeyUp("+Key.getCode()+")");
		});
		Key.addListener(o);
	}
	/**
	 * Initialize the video
	 */
	private function _initVideo()
	{
		_onResize();
		
		// Action on click
		// (transparent background)
		var vButton:MovieClip;
		if (!this.video.button_mc) {
			vButton = this.video.createEmptyMovieClip("button_mc", this.video.getNextHighestDepth());
		} else {
			vButton = this.video.button_mc;
		}
		vButton.clear();
		vButton.beginFill(0, 0);
		vButton.lineTo(0, this._swfHeight);
		vButton.lineTo(this._swfWidth, this._swfHeight);
		vButton.lineTo(this._swfWidth, 0);
		vButton.endFill();
		vButton.tabEnabled = false;
		
		vButton.onRelease = this.delegate(this, function()
		{
			this.sendToJavascript(this._listener+"onClick()");
		});
		if (_root.useHandCursor == false) {
			vButton.useHandCursor = false;
		}
		
		// top container
		_root.createEmptyMovieClip("top", _root.getNextHighestDepth());
	}
	/**
	 * Global EnterFrame
	 */
	private function _enterFrame()
	{
		// Run the init feedback for the first update
		if (!_isInit) {
			jsInit();
			_isInit = true;
			return;
		}
		
		var loading:Object = this.controller.getLoading();
		
		_setProperty("bytesTotal", loading.total);
		_setProperty("bytesLoaded", loading.loaded);
		_setProperty("bytesPercent", loading.percent);
		_setProperty("bufferLength", this.controller.getBufferLength());
		_setProperty("bufferTime", this.controller.getBufferTime());
		_setProperty("position", this.controller.getPosition()*1000);
		_setProperty("duration", this.controller.getDuration()*1000);
		_setProperty("isPlaying", this.controller.isPlaying);
		_setProperty("volume", this.controller.getVolume());
		
		var js:String = "";
		for (var i:String in _listenerTemp) {
			js += _listener+i+"='"+_listenerTemp[i]+"';";
		}
		
		this.sendToJavascript(js+_listener+"onUpdate();");
	}
	/**
	 * Update property in the javascript listener
	 * 
	 * @param pName Property name
	 * @param pValue Property value
	 */
	private function _setProperty(pName:String, pValue:Object)
	{
		_listenerTemp[pName] = pValue;
	}
	/**
	 * Invoked when Stage is resized	 */
	private function _onResize()
	{
		this.video.video._width = Stage.width;
		this.video.video._height = Stage.height;
		
		this.video.button_mc._width = Stage.width;
		this.video.button_mc._height = Stage.height;
		
		if (_root.bgcolor) {
			this.video.clear();
			this.video.beginFill(parseInt(_root.bgcolor, 16));
			this.video.lineTo(0, Stage.height);
			this.video.lineTo(Stage.width, Stage.height);
			this.video.lineTo(Stage.width, 0);
			this.video.endFill();
		}
	}
	/*========================= END = PRIVATE = END ==========================*/
	/*========================================================================*/
	
	/*================================ PUBLIC ================================*/
	/*========================================================================*/
	/**
	 * Send command to javascript
	 * 
	 * @param pCommand The javascript command	 */
	public function sendToJavascript(pCommand:String)
	{
		if (_root.useexternalinterface) {
			ExternalInterface.call(_listener+"oooupdate", pCommand);
		} else if (System.capabilities.playerType == "ActiveX") {
			fscommand("update", pCommand);
		} else {
			getURL("javascript:"+pCommand);
		}
	}
	/**
	 * Play
	 */
	public function playRelease()
	{
		super.playRelease();
		
		this.controller["_ns"].onStatus = function(info:Object){
			switch(info.code){
				case "NetStream.Buffer.Empty":
					if(Math.abs(Math.floor(this.time) - Math.floor(this.parent._videoDuration)) < 2){
						// end of the video
						this.parent._template.sendToJavascript(this.parent._template["_listener"]+"onFinished()");
					}
					break;
				case 'NetStream.Buffer.Full' :
					this.parent._template.resizeVideo();
					break;
			}
		};
	}
	/**
	 * Initialize event to Javascript object listener	 */
	public function jsInit()
	{
		this.sendToJavascript(_listener+"onInit();");
	}
	/**
	 * Resize the video
	 * 
	 * @param pWidth (optional) La largeur de la vidéo
	 * @param pHeight (optional) La hauteur de la vidéo
	 */
	public function resizeVideo(pWidth:Number, pHeight:Number)
	{
		this.video.video._width = Stage.width;
		this.video.video._height = Stage.height;
		this.video.video._x = 0;
		this.video.video._y = 0;
	}
	/**
	 * Load jpg or swf on top of the video
	 * 
	 * @param pUrl The url	 */
	public function loadUrl(pDepth:Number, pUrl:String, pVerticalAlign:String, pHorizontalAlign:String)
	{
		var top:MovieClip = _root.top;
		
		var movieContainer:MovieClip = top.createEmptyMovieClip("movie_"+pDepth, pDepth);
		var movie:MovieClip = movieContainer.createEmptyMovieClip("mc", 1);
		
		movieContainer.stageListener = new Object();
		movieContainer.stageListener.verticalAlign = pVerticalAlign;
		movieContainer.stageListener.horizontalAlign = pHorizontalAlign;
		movieContainer.stageListener.mc = movieContainer;
		movieContainer.stageListener.onResize = function()
		{
			if (this.horizontalAlign == "") {
				// center
				this.mc._x = (Stage.width - this.mc._width) / 2;
			} else if (this.horizontalAlign.charAt(0) == "-") {
				// right align
				this.mc._x = Stage.width - this.mc._width + Number(this.horizontalAlign);
			} else {
				// left align
				this.mc._x = Number(this.horizontalAlign);
			}
			
			if (this.verticalAlign == "") {
				// center
				this.mc._y = (Stage.height - this.mc._height) / 2;
			} else if (this.verticalAlign.charAt(0) == "-") {
				// bottom align
				this.mc._y = Stage.height - this.mc._height + Number(this.verticalAlign);
			} else {
				// top align
				this.mc._y = Number(this.verticalAlign);
			}
		};
		Stage.addListener(movieContainer.stageListener);
		
		movieContainer.onEnterFrame = this.delegate(movieContainer, function()
		{
			if (this._width > 0) {
				this.stageListener.onResize();
				delete this.onEnterFrame;
			}
		});
		movie.loadMovie(pUrl);
	}
	/**
	 * Unload file on top of the video
	 * 	 * @param pDepth The depth of the file
	 */
	public function unloadAtDepth(pDepth:Number)
	{
		var top:MovieClip = _root.top;
		
		var movie:MovieClip = top.getInstanceAtDepth(pDepth);
		movie.removeMovieClip();
	}
	/*========================== END = PUBLIC = END ==========================*/
	/*========================================================================*/
	
	/*========================= JAVASCRIPT CONTROLS ==========================*/
	/*========================================================================*/
	/**
	 * Change the FLV's url
	 * 
	 * @param pUrl The new url	 */
	public function set setUrl(pUrl:String)
	{
		this.controller.setUrl(pUrl);
		_setProperty("url", pUrl);
	}
	/**
	 * Play the video	 */
	public function set play(n:String)
	{
		if (!this.controller.isPlaying) {
			this.playRelease();
		}
	}
	/**
	 * Pause	 */
	public function set pause(n:String)
	{
		if (this.controller.isPlaying) {
			this.pauseRelease();
		}
	}
	/**
	 * Stop the video	 */
	public function set stop(n:String)
	{
		this.stopRelease();
	}
	/**
	 * Change the volume
	 * 
	 * @param pVolume The new volume	 */
	public function set setVolume(pVolume:String)
	{
		this.controller.setVolume(Number(pVolume));
	}
	/**
	 * Change the video's position
	 * 
	 * @param pPosition The new position in milliseconds	 */
	public function set setPosition(pPosition:String)
	{
		this.controller.setPosition(Number(pPosition)/1000);
	}
	/**
	 * Change the video's type:
	 *   - 0: progressive download
	 *   - 1: php streaming
	 * 
	 * @param pType The type	 */
	public function set setVideoType(pType:String)
	{
		this.controller["_isPhpStream"] = (pType == "1");
	}
	/**
	 * Load jpg or swf on top of the video
	 * 
	 * @param pUrl The url	 */
	public function set loadMovieOnTop(pUrl:String)
	{
		var param:Array = pUrl.split("|");
		var vertical:String = (param[2] === undefined)?"":param[2];
		var horizontal:String = (param[3] === undefined)?"":param[3];
		
		this.loadUrl(Number(param[1]), 
					param[0], 
					vertical, 
					horizontal);
	}
	/**
	 * Unload file on top of the video
	 * 
	 * @param pDepth The depth of the file	 */
	public function set unloadMovieOnTop(pDepth:String)
	{
		this.unloadAtDepth(Number(pDepth));
	}
	/*=================== END = JAVASCRIPT CONTROLS = END ====================*/
	/*========================================================================*/
}