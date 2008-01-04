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
 * Player for several FLV
 * 
 * @author		neolao <neo@neolao.com> 
 * @version 	0.2.12 (23/10/2007)
 * @license		http://creativecommons.org/licenses/by-sa/3.0/deed.fr 
 */
class PlayerMulti extends PlayerDefault
{
	// ------------------------------ CONSTANTES -------------------------------
	/**
	 * Url separator
	 */
	static var URL_SEPARATOR:String = "|";
	
	// ------------------------------ VARIABLES --------------------------------
	/**
	 * La liste des flv à lire
	 */
	public var playlist:Array;
	/**
	 * Choisir le mp3 suivant aléatoirement dans la playlist
	 */
	public var shuffle:Boolean = false;
	/**
	 * Indique s'il y a un précédent
	 */
	public var hasPrevious:Boolean = false;
	/**
	 * Indique s'il y a un suivant
	 */
	public var hasNext:Boolean = false;
	/**
	 * L'index du mp3 dans la playlist
	 */
	public var index:Number = 0;
	
	/*============================= CONSTRUCTEUR =============================*/
	/*========================================================================*/
	/**
	 * Initialisation
	 * 
	 * @param pTemplate L'instance du thème à utiliser
	 */
	public function PlayerMulti(pTemplate:ATemplate)
	{
		this._template = pTemplate;
		this._template.controller = this;
		
		this._initVars();
		this._initVideo();
		
		this._initSubtitles();
		
		// Définition de la liste des flv
		this.playlist = _root.flv.split(URL_SEPARATOR);
		
		if (this.playlist.length > 1) {
			this.hasNext = true;
		}
		
		if (_root.shuffle != undefined) {
			this.shuffle = true;
			this.index = Math.round(Math.random() * (this.playlist.length - 1));
			this.hasPrevious = true;
			this.hasNext = true;
		}
		
		// Lecture automatique
		if (_root.autoplay == "1") {
			this._template.playRelease();
		} else {
			if (_root.autoload != undefined) {
				this._template.playRelease();
			}
			this._template.stopRelease();
		}
	}
	/*======================= FIN = CONSTRUCTEUR = FIN =======================*/
	/*========================================================================*/
	
	/*=========================== METHODES PRIVEES ===========================*/
	/*========================================================================*/
	/**
	 * Initialisation des variables 
	 */
	private function _initVars()
	{
		super._initVars();
		
		
	}
	/**
	 * Initialisation de la video
	 */
	private function _initVideo(){
		this._nc = new NetConnection();
		this._nc.connect(null);
		
		this._ns = new NetStream(this._nc);
		this._ns.setBufferTime(this._bufferTime);
		_ns["parent"] = this;
		this._ns.onStatus = function(info:Object){
			switch(info.code){
				case "NetStream.Play.Start":
					//this.parent.isPlaying = true;
					break;
				case "NetStream.Play.Stop":
					//this.parent.isPlaying = false;
					break;
				case "NetStream.Buffer.Empty":
					if(Math.abs(Math.floor(this.time) - Math.floor(this.parent._videoDuration)) < 2){
						// la vidéo est terminée
						this.parent._template.nextRelease();
					}
					break;
				case "NetStream.Buffer.Full":
					this.parent._template.resizeVideo();
					break;
			}
		};
		this._ns.onMetaData = function(info:Object){
			this.parent._videoDuration = (info.duration < 0)?0:info.duration;
			this.parent._template.resizeVideo(info.width, info.height);
		};
		
		// La zone video du thème affiche le NetStream
		this._template.video.video.attachVideo(this._ns);
		
		// Smooth effect
		this._template.video.video.smoothing = true;
		
		// Gestion du son
		this._sound = new Sound();
		this._sound.attachSound(this._template.video.video);
	}
	/**
	 * Initialisation des sous-titres
	 */
	private function _initSubtitles()
	{
		var vSrt:LoadVars;
		if (this._useSrt) {
			if (this._subtitles == undefined) {
				this._subtitles = new Array();
			}
			vSrt = new LoadVars();
			vSrt.parent = this;
			vSrt.index = this.index;
			vSrt.onData = function(data:String) {
				if (data != undefined) {
					data = data.split("\r\n").join("\n");
					this.parent._subtitles[this.index] = new Array();
					this.parent._subtitles[this.index] = data.split("\n\n");
					
					for (var i=0; i<this.parent._subtitles[this.index].length; i++) {
						var detail:Array = this.parent._subtitles[this.index][i].split("\n");
						var id:Number = Number(detail.shift());
						var time:String = String(detail.shift());
						var timeDetail:Array = time.split(" --> ");
						var timeStart:Array = timeDetail[0].split(",")[0].split(":").concat(timeDetail[0].split(",")[1]);
						var timeStartHour:Number = Number(timeStart[0]);
						var timeStartMinute:Number = Number(timeStart[1]);
						var timeStartSecond:Number = Number(timeStart[2]);
						var timeStartMilli:Number = Number(timeStart[3]);
						var timeEnd:Array = timeDetail[1].split(",")[0].split(":").concat(timeDetail[1].split(",")[1]);
						var timeEndHour:Number = Number(timeEnd[0]);
						var timeEndMinute:Number = Number(timeEnd[1]);
						var timeEndSecond:Number = Number(timeEnd[2]);
						var timeEndMilli:Number = Number(timeEnd[3]);
						var message:String = detail.join("\n");
						
						this.parent._subtitles[this.index][i] = {id:id, 
																 message:message, 
																 timeStart:timeStartHour*60*60*1000+timeStartMinute*60*1000+timeStartSecond*1000+timeStartMilli, 
													 			 timeEnd:timeEndHour*60*60*1000+timeEndMinute*60*1000+timeEndSecond*1000+timeEndMilli};
					}
				}
			};
			
			if (this.playlist[this.index] != undefined) {
				vSrt.load(this.playlist[this.index].substr(0, this.playlist[this.index].length-3)+"srt", vSrt, "GET");
			}
		}
	}
	/*===================== FIN = METHODES PRIVEES = FIN =====================*/
	/*========================================================================*/
	
	/*========================== METHODES PUBLIQUES ==========================*/
	/*========================================================================*/
	/**
	 * Changer l'index
	 * 
	 * @param pIndex L'index du mp3
	 */
	public function setIndex(pIndex:Number)
	{
		this.index = pIndex;
		this._firstPlay = false;
		if (this.shuffle) {
			this.hasNext  = true;
			this.hasPrevious = true;
		} else {
			this.hasNext = (this.index < this.playlist.length - 1) || this._loop;
			this.hasPrevious = (this.index > 0);
		}
		if (this.isPlaying) {
			this.play();
		}
	}
	/**
	 * Jouer
	 */
	public function play():Void
	{
		this._initSubtitles();
		if (isPlaying) {
			this._ns.pause();
		}
		if (!this._firstPlay) {
			this._ns.play(this.playlist[this.index]);
			_root.currentUrl = this.playlist[this.index];
			_root.currentIndex = this.index;
			
			this._firstPlay = true;
		} else {
			this._ns.pause();
		}
		if (this.shuffle) {
			this.hasNext  = true;
			this.hasPrevious = true;
		} else {
			this.hasNext = (this.index < this.playlist.length - 1) || this._loop;
			this.hasPrevious = (this.index > 0);
		}
		
		this.isPlaying = true;
	}
	/**
	 * mp3 suivant
	 * 
	 * @return true s'il y a une suite, sinon false
	 */
	public function next():Boolean
	{
		if (this.shuffle) {
			this.index = Math.round(Math.random() * (this.playlist.length - 1));
			this.hasNext = true;
		} else {
			this.index++;
			this.hasNext = (this.index < this.playlist.length - 1) || this._loop;
		}
		
		if (this.index >= this.playlist.length) {
			if (this._loop) {
				this.index = 0;
				this.hasNext = (this.index < this.playlist.length - 1) || this._loop;
			} else {
				this.stop();
				return false;
			}
		}
		this.hasPrevious = (this.index > 0);
		this._firstPlay = false;
		if (this.isPlaying) {
			this.play();
		}
		return true;
	}
	/**
	 * mp3 précédent
	 * 
	 * @return true s'il y a un précédent, sinon false
	 */
	public function previous():Boolean
	{
		if (this.shuffle) {
			this.index = Math.round(Math.random() * (this.playlist.length - 1));
			this.hasPrevious = true;
		} else {
			this.index--;
			this.hasPrevious = (this.index > 0);
		}
		
		if (this.index < 0) {
			// Si on fait précédent la piste 0, on la rejoue
			this.index = 0;
			this.hasPrevious = false;
		}
		this.hasNext = (this.index < this.playlist.length - 1) || this._loop;
		this._firstPlay = false;
		if (this.isPlaying) {
			this.play();
		}
		return true;
	}
	/**
	 * Récupère le sous-titre en cours
	 * 
	 * @return Le sous-titre
	 */
	public function getSubtitle():String
	{
		for (var i:Number=0; i<this._subtitles[this.index].length; i++) {
			if (this._ns.time*1000 >= this._subtitles[this.index][i].timeStart && this._ns.time*1000 <= this._subtitles[this.index][i].timeEnd) {
				return this._subtitles[this.index][i].message;
			}
		}
		return "";
	}
	/*==================== FIN = METHODES PUBLIQUES = FIN ====================*/
	/*========================================================================*/
}