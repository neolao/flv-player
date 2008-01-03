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
/**
 * Basic FLV player
 * 
 * @author		neolao <neo@neolao.com> 
 * @version 	1.0.0 (17/11/2007)
 * @license		http://creativecommons.org/licenses/by-sa/3.0/deed.fr
 */
class PlayerBasic
{
	// ------------------------------ CONSTANTS --------------------------------
	
	// ------------------------------ VARIABLES --------------------------------
	private var _nc:NetConnection;
	private var _ns:NetStream;
	
	/**
	 * Template instances
	 */
	private var _template:ATemplate;
	/**
	 * The buffer time in milliseconds	 */
	private var _bufferTime:Number = 5;
	/**
	 * Loop the video	 */
	private var _loop:Boolean = false;
	/**
	 * Use php stream	 */
	private var _isPhpStream:Boolean = false;
	/**
	 * keyframes.times in the FLV	 */
	private var _times:Array;
	/**
	 * keyframes.filepositions in the FLV	 */
	private var _positions:Array;
	/**
	 * The sound	 */
	private var _sound:Sound;
	/**
	 * The video duration	 */
	private var _videoDuration:Number;
	/**
	 * The video URL	 */
	private var _videoUrl:String;
	/**
	 * The video is played for the first time	 */
	private var _firstPlay:Boolean = false;
	/**
	 * The video stream is started	 */
	public var streamStarted:Boolean = false;
	/**
	 * The video is playing	 */
	public var isPlaying:Boolean = false;
	/**
	 * A time memory	 */
	private var _timeTemp:Number;
	
	/*============================= CONSTRUCTOR ==============================*/
	/*========================================================================*/
	/**
	 * Constructor
	 * 
	 * @param pTemplate The template instance
	 */
	public function PlayerBasic(pTemplate:ATemplate)
	{
		
		this._template = pTemplate;
		this._template.controller = this;
		
		this._initVars();
		this._initVideo();
		
		// PHP streaming
		if (_root.phpstream == "1") {
			this._isPhpStream = true;
		}
		
		// Auto play
		if (_root.autoplay == "1") {
			this._template.playRelease();
		} else {
			if (_root.autoload == "1") {
				this._template.playRelease();
			}
			this._template.stopRelease();
		}
		
		// Create movieclip for enterframe event
		var mc:MovieClip = _root.createEmptyMovieClip("time_mc", _root.getNextHighestDepth());
		mc.onEnterFrame = this._template.delegate(this, this._enterFrame);
	}
	/*======================= END = CONSTRUCTOR = END ========================*/
	/*========================================================================*/
	
	/*=============================== PRIVATE ================================*/
	/*========================================================================*/
	/**
	 * Initialize variables 
	 */
	private function _initVars()
	{
		if (_root.flv != undefined) {
			this._videoUrl = _root.flv;
		}
		if (_root.buffer != undefined) {
			this._bufferTime = Number(_root.buffer);
		}
		if (_root.loop == "1") {
			this._loop = true;
		}
	}
	/**
	 * Initialize video
	 */
	private function _initVideo()
	{
		this._nc = new NetConnection();
		if (_root.netconnection != undefined) {
			this._nc.connect(_root.netconnection);
		} else {
			this._nc.connect(null);
		}
		
		this._ns = new NetStream(this._nc);
		this._ns.setBufferTime(this._bufferTime);
		_ns["parent"] = this;
		this._ns.onStatus = function(info:Object){
			switch(info.code){
				case "NetStream.Buffer.Empty":
					if(Math.abs(Math.floor(this.time) - Math.floor(this.parent._videoDuration)) < 2){
						// The video is finished
						this.parent._template.stopRelease();
						if(this.parent._loop){
							this.parent._template.playRelease();
						}
					}
					break;
				case "NetStream.Buffer.Full":
					this.parent._template.resizeVideo();
					break;
				case 'NetConnection.Connect.Success' :
                    var myStream:Object = {};
                    myStream.parent = this;
                    myStream.onResult = function(streamLength) {
                        this.parent.parent._videoDuration = (info.duration < 0)?0:info.duration;
                    };
                    this.call("getLength", myStream, "theVideo");
                    break;
			}
		};
		this._ns.onMetaData = function(info:Object){
			this.parent._videoDuration = (info.duration < 0)?0:info.duration;
			this.parent._template.resizeVideo(info.width, info.height);
			
			this.parent._times = info.keyframes.times;
			this.parent._positions = info.keyframes.filepositions;
		};
		
		// The video object displays the NetStream
		this._template.video.video.attachVideo(this._ns);
		
		// Smooth effect
		this._template.video.video.smoothing = true;
		
		// Sound manager
		this._sound = new Sound();
		this._sound.attachSound(this._template.video.video);
	}
	/**
	 * Enterframe	 */
	private function _enterFrame()
	{
		var newPosition:Number = this.getPosition();
		if (newPosition !== this._timeTemp) {
			this.streamStarted = true;
		} else {
			this.streamStarted = false;
		}
		
		this._timeTemp = newPosition;
	}
	/*========================= END = PRIVATE = END ==========================*/
	/*========================================================================*/
	
	/*================================ PUBLIC ================================*/
	/*========================================================================*/
	/**
	 * Play	 */
	public function play()
	{
		// Si le NetConnection et le NetStream ne sont pas encore créés
		if (!this._nc && !this._ns) {
			this._firstPlay = false;
			this._initVideo();
		}
		
		if (!this._firstPlay) {
			this._ns.play(this._videoUrl);
			
			this._firstPlay = true;
		} else {
			this._ns.pause();
		}
		
		this.isPlaying = true;
	}
	/**
	 * Pause
	 */
	public function pause()
	{
		this._ns.pause();
		this.isPlaying = false;
	}
	/**
	 * Stop
	 */
	public function stop()
	{
		if (this._isPhpStream) {
			this._ns.play(this._videoUrl+"0");
			this._ns.seek(0);
			this._ns.pause();
		} else {
			this._ns.seek(0);
			if (this.isPlaying) {
				this._ns.pause();
			}
		}
		this.isPlaying = false;
		
		// Stop the video loading
		if (_root.loadonstop == 0) {
			delete this._ns;
			delete this._nc;
		}
	}
	/**
	 * Change the video position
	 * 
	 * @param pPosition The position	 */
	public function setPosition(pPosition:Number)
	{
		if (pPosition < 0) {
			pPosition = 0;
		}
		if (pPosition > this._videoDuration) {
			pPosition = this._videoDuration;
		}
		if (this._isPhpStream) {
			var newPosition:Number = 0;
			var length:Number = this._times.length;
			
			if (pPosition <= this._times[0]) {
				newPosition = this._positions[0];
			} else if (pPosition >= this._times[length-1]) {
				newPosition = this._positions[0];
			} else {
				// binary search (recherche dichotomique)
				var linearSearchTolerance:Number = 40;
				var startIndex:Number = 0;
				var endIndex:Number = length;
				var newStart:Number = 0;
				var newEnd:Number = 0;
				
				// reduce startIndex and endIndex
				while ((endIndex - startIndex) > linearSearchTolerance) {
					var newMax:Number = endIndex - startIndex;
					var k:Number = (newMax>>1);  // divide by 2 without the remainder
					k = startIndex + k;
					var timeMiddle:Number = this._times[k];
					newStart = startIndex;
					newEnd = k;
					if (pPosition >= timeMiddle) { newStart = k; newEnd = endIndex; }
					startIndex = newStart;
					endIndex = newEnd;
				}
				// linear search 
				for (var i:Number = startIndex; i < endIndex; i++) {
					if (this._times[i] <= pPosition && pPosition < this._times[i+1]) {
						newPosition = _positions[i];
						break;
					}
				}
			}
			newPosition = (newPosition < 0)?0:newPosition;
			
			this._ns.play(this._videoUrl+newPosition);
			if (!this.isPlaying) {
				this._ns.pause();
			}
		} else {
			this._ns.seek(pPosition);
		}
	}
	/**
	 * Get the video position
	 * 
	 * @return The position	 */
	public function getPosition():Number
	{
		var pos:Number;
		
		if (this._ns.time > this._videoDuration) {
			pos = this._videoDuration;
		} else if (this._ns.time < 0) {
			pos = 0;
		} else {
			pos = this._ns.time;
		}
		
		return pos;
	}
	/**
	 * Get the video duration
	 * 
	 * @return The duration	 */
	public function getDuration():Number
	{
		return this._videoDuration;
	}
	/**
	 * Get the buffer length
	 * 
	 * @return The buffer length	 */
	public function getBufferLength():Number
	{
		return this._ns.bufferLength;
	}
	/**
	 * Get the buffer time
	 * 
	 * @return The buffer time	 */
	public function getBufferTime():Number
	{
		return this._ns.bufferTime;
	}
	/**
	 * Get the video loading informations
	 * 
	 * - loaded: bytes loaded
	 * - total: bytes total
	 * - percent: percent
	 * 
	 * @return Informations object
	 */
	public function getLoading():Object
	{
		var loaded:Number = this._ns.bytesLoaded;
		var total:Number = this._ns.bytesTotal;
		var percent:Number = Math.round(loaded / total * 100);
		
		if (_root.netconnection != undefined) {
			loaded = 100;
			total = 100;
			percent = 100;
		}
		 
		return {loaded:loaded, total:total, percent:percent};
	}
	/*========================== END = PUBLIC = END ==========================*/
	/*========================================================================*/
}