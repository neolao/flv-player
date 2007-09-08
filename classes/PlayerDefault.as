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
 * Normal player flv
 * 
 * @author		neolao <neo@neolao.com> 
 * @version 	0.9.1 (08/09/2007)
 * @license		http://creativecommons.org/licenses/by-sa/3.0/deed.fr
 */
class PlayerDefault extends PlayerBasic
{
	// ------------------------------ VARIABLES --------------------------------
	/**
	 * Use subtitles	 */
	private var _useSrt:Boolean = false;
	/**
	 * Subtitles path
	 */
	private var _srtUrl:String;
	/**
	 * Subtitles data	 */
	private var _subtitles:Array;
	
	/*============================= CONSTRUCTEUR =============================*/
	/*========================================================================*/
	/**
	 * Initialisation
	 * 
	 * @param pTemplate L'instance du thème à utiliser
	 */
	public function PlayerDefault(pTemplate:ATemplate)
	{
		super(pTemplate);
		
		this._initSubtitles();
	}
	/*======================= FIN = CONSTRUCTEUR = FIN =======================*/
	/*========================================================================*/
	
	/*=========================== METHODES PRIVEES ===========================*/
	/*========================================================================*/
	/**
	 * Initialize variables
	 */
	private function _initVars()
	{
		super._initVars();
		
		if (_root.srt == "1") {
			this._useSrt = true;
		}
		if (_root.srturl != undefined) {
			this._srtUrl = _root.srturl
		}
	}
	/**
	 * Initialisation des sous-titres	 */
	private function _initSubtitles()
	{
		this._subtitles = new Array();
		if (this._useSrt) {
			var vSrt:LoadVars = new LoadVars();
			vSrt.parent = this;
			vSrt.onData = function(data:String) {
				if (data != undefined) {
					data = data.split("\r\n").join("\n");
					this.parent._subtitles = data.split("\n\n");
					
					for (var i=0; i<this.parent._subtitles.length; i++) {
						var detail:Array = this.parent._subtitles[i].split("\n");
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
						
						this.parent._subtitles[i] = {id:id, 
													 message:message, 
													 timeStart:timeStartHour*60*60*1000+timeStartMinute*60*1000+timeStartSecond*1000+timeStartMilli, 
													 timeEnd:timeEndHour*60*60*1000+timeEndMinute*60*1000+timeEndSecond*1000+timeEndMilli};
					}
				}
			};
			if(this._srtUrl != undefined) {
				vSrt.load(this._srtUrl, vSrt, "GET");
			} else {
				vSrt.load(this._videoUrl.substr(0, this._videoUrl.length-3)+"srt", vSrt, "GET");
			}
		}
	}
	/*===================== FIN = METHODES PRIVEES = FIN =====================*/
	/*========================================================================*/
	
	/*========================== METHODES PUBLIQUES ==========================*/
	/*========================================================================*/
	/**
	 * Change le volume
	 * 
	 * @param pVolume Le volume	 */
	public function setVolume(pVolume:Number)
	{
		this._sound.setVolume(pVolume);
	}
	/**
	 * Récupère le volume
	 * 
	 * @return Le volume	 */
	public function getVolume():Number
	{
		return this._sound.getVolume();
	}
	/**
	 * Récupère les sous-titres
	 * 
	 * @return Les sous-titres	 */
	public function getSubtitles():Array
	{
		return this._subtitles;
	}
	/**
	 * Récupère le sous-titre en cours
	 * 
	 * @return Le sous-titre	 */
	public function getSubtitle():String
	{
		for (var i:Number=0; i<this._subtitles.length; i++) {
			if (this._ns.time*1000 >= this._subtitles[i].timeStart && this._ns.time*1000 <= this._subtitles[i].timeEnd) {
				return this._subtitles[i].message;
			}
		}
		return "";
	}
	/**
	 * Modifie l'url du fichier FLV à charger
	 * 
	 * @param pUrl L'url du nouveau fichier FLV	 */
	public function setUrl(pUrl:String):Void
	{
		this._videoUrl = pUrl;
		this._initSubtitles();
		this._firstPlay = false;
	}
	/*==================== FIN = METHODES PUBLIQUES = FIN ====================*/
	/*========================================================================*/
}