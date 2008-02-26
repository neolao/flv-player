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
 * Template Maxi
 * 
 * @author		neolao <neo@neolao.com> 
 * @license		http://creativecommons.org/licenses/by-sa/3.0/deed.fr
 */ 
class TemplateMaxiBase extends ATemplate
{
	// ----------------------------- CONSTANTES --------------------------------
	public var PLAYER_HEIGHT:Number = 20;
	public var BUTTON_WIDTH:Number = 26;
	public var SLIDER_WIDTH:Number = 20;
	public var SLIDER_HEIGHT:Number = 10;
	public var VOLUME_WIDTH:Number = 30;
	public var VOLUME_HEIGHT:Number = 6;
	
	// ------------------------------ VARIABLES --------------------------------
	/**
	 * La marge de la vidéo
	 */
	private var _videoMargin:Number = 5;
	/**
	 * La couleur des sous-titres
	 */
	private var _subtitleColor:Number = 0xffffff;
	/**
	 * La couleur du fond des sous-titres
	 */
	private var _subtitleBackgroundColor:Number;
	/**
	 * La taille des sous-titres
	 */
	private var _subtitleSize:Number = 11;
	/**
	 * L'instance du clip des sous-titres
	 */
	private var _subtitles:MovieClip;
	/**
	 * Le format de la police du titre
	 */
	private var _titleFormat:TextFormat;
	/**
	 * Le format de la police des sous-titres
	 */
	private var _subtitleFormat:TextFormat;
	/**
	 * Le format de la police du temps
	 */
	private var _timeFormat:TextFormat;
	/**
	 * Le fond du lecteur
	 */
	private var _playerBackground:MovieClip;
	/**
	 * Les séparateurs du lecteur
	 */
	private var _playerSeparators:MovieClip;
	/**
	 * La couleur du lecteur
	 */
	private var _playerColor:Number = 0x111111;
	/**
	 * Le bouton Play du lecteur
	 */
	private var _playerPlay:MovieClip;
	/**
	 * Le bouton Pause du lecteur
	 */
	private var _playerPause:MovieClip;
	/**
	 * Le bouton Stop du lecteur
	 */
	private var _playerStop:MovieClip;
	/**
	 * Le bouton "Close Captions" du lecteur pour afficher les sous-titres
	 */
	private var _playerShowSubtitles:MovieClip;
	/**
	 * Le bouton "Close Captions" du lecteur pour cacher les sous-titres
	 */
	private var _playerHideSubtitles:MovieClip;
	/**
	 * Le bouton Fullscreen du lecteur
	 */
	private var _playerFullscreen:MovieClip;
	/**
	 * Le bouton Volume du lecteur
	 */
	private var _playerVolume:MovieClip;
	/**
	 * Le bouton Time du lecteur
	 */
	private var _playerTime:MovieClip;
	/**
	 * La barre de lecture
	 */
	private var _playerSlider:MovieClip;
	/**
	 * L'interval du lecteur pour la fermeture
	 */
	private var _playerItv:Number;
	/**
	 * L'écouteur de la souris
	 */
	private var _mouse:Object;
	/**
	 * La barre de chargement
	 */
	private var _loadingBar:MovieClip;
	/**
	 * L'indicateur du tampon
	 */
	private var _buffering:MovieClip;
	/**
	 * La couleur des boutons
	 */
	private var _buttonColor:Number = 0xffffff;
	/**
	 * La couleur des boutons au survol
	 */
	private var _buttonOverColor:Number = 0xffff00;
	/**
	 * La couleur 1 de la barre de lecture
	 */
	private var _sliderColor1:Number = 0xcccccc;
	/**
	 * La couleur 2 de la barre de lecture
	 */
	private var _sliderColor2:Number = 0x888888;
	/**
	 * La couleur de la barre de lecture au survol
	 */
	private var _sliderOverColor:Number = 0xffff00;
	/**
	 * La couleur de la barre de chargement
	 */
	private var _loadingColor:Number = 0xffff00;
	/**
	 * Le titre de la vidéo
	 */
	private var _title:String = "";
	/**
	 * L'image de titre de la vidéo
	 */
	private var _startImage:String;
	/**
	 * Le bouton Stop
	 */
	private var _showStop:Boolean = false;
	/**
	 * Le bouton Volume
	 */
	private var _showVolume:Boolean = false;
	/**
	 * Le bouton Time
	 * 
	 * 0: ne pas afficher
	 * 1: afficher le temps écoulé par défaut
	 * 2: afficher le temps restant par défaut
	 */
	private var _showTime:Number = 0;
	/**
	 * Le skin
	 */
	private var _backgroundSkin:String;
	/**
	 * La couleur du fond tout au fond vraiment au fond fond fond
	 */
	private var _backgroundColor:Number;
	/**
	 * La couleur 1 du fond
	 */
	private var _backgroundColor1:Number = 0x7c7c7c;
	/**
	 * La couleur 2 du fond
	 */
	private var _backgroundColor2:Number = 0x333333;
	/**
	 * Le volume
	 */
	private var _volume:Number = 100;
	/**
	 * Le volume maximum
	 */
	private var _volumeMax:Number = 200;
	/**
	 * Interval for onclick
	 */
	private var _onClickInterval:Number = -1;
	/**
	 * Action on click
	 * 
	 * - "playpause" : Toggle play / pause
	 * - "none" : do nothing
	 * - url : open new url
	 */
	private var _onClick:String = "playpause";
	/**
	 * The onclick's target
	 */
	private var _onClickTarget:String = "_self";
	/**
	 * Action on double click
	 * 
	 * - "none" : do nothing
	 * - "fullscreen" : Toggle fullscreen / normal view
	 * - "playpause" : Toggle play / pause
	 * - url : open new url
	 */
	private var _onDoubleClick:String = "none";
	/**
	 * The double click's target
	 */
	private var _onDoubleClickTarget:String = "_self";
	/**
	 * Taille de la police du titre
	 */
	private var _titleSize:Number = 20;
	/**
	 * Type d'affichage du lecteur
	 * 
	 * autohide, always, never
	 */
	private var _showPlayer:String = "autohide";
	/**
	 * Le délai avant que le lecteur ne soit masqué, en milliseconde
	 */
	private var _playerTimeout:Number = 1500;
	/**
	 * Le message de la mémoire tampon
	 * 
	 * _n_ pour le pourcentage
	 */
	private var _bufferMessage:String = "Buffering _n_";
	/**
	 * Force la taille indiqué pour la vidéo
	 */
	private var _forceSize:Boolean = false;
	/**
	 * Affichage de la barre de chargement
	 * 
	 * - always : Toujours afficher
	 * - never : Toujours cacher
	 * - autohide : Afficher pendant le chargement uniquement
	 */
	private var _showLoading:String = "autohide";
	/**
	 * Indique s'il y a une couleur de fond au message de buffer
	 */
	private var _bufferShowBackground:Boolean = true;
	/**
	 * La couleur de fond du message de buffer
	 */
	private var _bufferBackgroundColor:Number = 0;
	/**
	 * La couleur de texte du message de buffer
	 */
	private var _bufferColor:Number = 0xffffff;
	/**
	 * La couleur de fond de la vidéo (quand il n'y a pas de vidéo ^.^;)
	 */
	private var _videoBackgroundColor:Number = 0;
	/**
	 * Activation des raccourcis clavier
	 */
	private var _shortcut:Boolean = true;
	/**
	 * Affichage du bouton Fullscreen
	 */
	private var _showFullscreen:Boolean = false;
	/**
	 * Indique si le lecteur est en plein écran
	 */
	private var _isFullscreen:Boolean = false;
	/**
	 * La marge gauche du slider
	 */
	private var _marginSlider:Number = 0;
	/**
	 * Mémorisation des paramètres en non fullscreen
	 */
	private var _stageNormalParams:Object;
	/**
	 * Affichage du bouton "Close Captions"
	 */
	private var _showSwitchSubtitles:Boolean = false;
	/**
	 * La couleur du titre de la vidéo
	 */
	private var _titleColor:Number = 0xffffff;
	/**
	 * La dernière valeur du buffer
	 */
	private var _lastBuffer:Number = 0;
	/**
	 * Indique que la vidéo est en position STOP
	 */
	private var _stopped:Boolean = true;
	/**
	 * Mouse display type:
	 *   - "always" : The mouse is always visible
	 *   - "autohide" : The mouse is hidden after 1500 milliseconds
	 *   - "never" : The mouse is never visible
	 */
	private var _showMouse:String = "always";
	/**
	 * L'instance du controleur de la vidéo
	 */
	public var controller:PlayerDefault;
	/**
	 * Alpha transparency of the player
	 */
	private var _playerAlpha:Number = 100;
	/**
	 * Top containers
	 */
	private var _topContainers:Array;
	/**
	 * Show the title and the startimage at the same time
	 */
	private var _showTitleAndStartimage:Boolean = false;
	/**
	 * Show play icon
	 */
	private var _showIconPlay:Boolean = false;
	/**
	 * Icon play color
	 */
	private var _iconPlayColor:Number = 0xffffff;
	/**
	 * Icon play background color
	 */
	private var _iconPlayBackgroundColor:Number = 0x000000;
	/**
	 * Icon play background alpha
	 */
	private var _iconPlayBackgroundAlpha:Number = 75;
	
	
	/**
	 * Constructor
	 */
	public function TemplateMaxiBase()
	{
		this._topContainers = new Array();
		super();
	}
	
	/**
	 * Change general variable
	 * 
	 * @param pVarName The variable name
	 * @param pList Values by priority order
	 * @param pType The variable type: String, Number, Color ou Boolean (String by default)
	 * @return true if the change succeed, false otherwise
	 */
	private function _setVar(pVarName:String, pList:Array, pType:String):Boolean
	{
		for (var i:Number=0; i<pList.length; i++) {
			if (pList[i] != undefined) {
				switch (pType) {
					case "Number":
						this[pVarName] = parseInt(pList[i], 10);
						break;
					case "Color":
						this[pVarName] = parseInt(pList[i], 16);
						break;
					case "Boolean":
						this[pVarName] = (pList[i] == "false" || pList[i] == false)?false:true;
						break;
					default:
						this[pVarName] = pList[i];
				}
				return true;
			}
		}
		return false;
	}
	/**
	 * Initialize variables
	 * 
	 * @param pConfig The default config 
	 */
	private function _initVars(pConfig:Object)
	{
		super._initVars();
		
		this._setVar("_title", 				[_root.title, pConfig.title], 				"String");
		this._setVar("_startImage", 		[_root.startimage, pConfig.startimage], 	"String");
		this._setVar("_backgroundSkin", 	[_root.skin, pConfig.skin], 				"String");
		this._setVar("_backgroundColor", 	[_root.bgcolor, pConfig.bgcolor], 			"Color");
		this._setVar("_backgroundColor1", 	[_root.bgcolor1, pConfig.bgcolor1], 		"Color");
		this._setVar("_backgroundColor2", 	[_root.bgcolor2, pConfig.bgcolor2], 		"Color");
		this._setVar("_showStop", 			[_root.showstop, pConfig.showstop], 		"Boolean");
		this._setVar("_showVolume", 		[_root.showvolume, pConfig.showvolume], 	"Boolean");
		this._setVar("_showTime", 			[_root.showtime, pConfig.showtime], 		"Number");
		this._setVar("_videoMargin", 		[_root.margin, pConfig.margin], 			"Number");
		this._setVar("_subtitleColor", 		[_root.srtcolor, pConfig.srtcolor], 		"Color");
		this._setVar("_subtitleBackgroundColor", [_root.srtbgcolor, pConfig.srtbgcolor], "Color");
		this._setVar("_subtitleSize", 		[_root.srtsize, pConfig.srtsize], 			"Number");
		this._setVar("_playerColor", 		[_root.playercolor, pConfig.playercolor], 	"Color");
		this._setVar("_buttonColor", 		[_root.buttoncolor, pConfig.buttoncolor], 	"Color");
		this._setVar("_buttonOverColor", 	[_root.buttonovercolor, pConfig.buttonovercolor], "Color");
		this._setVar("_sliderColor1", 		[_root.slidercolor1, pConfig.slidercolor1], "Color");
		this._setVar("_sliderColor2", 		[_root.slidercolor2, pConfig.slidercolor2], "Color");
		this._setVar("_sliderOverColor", 	[_root.sliderovercolor, pConfig.sliderovercolor], "Color");
		this._setVar("_loadingColor", 		[_root.loadingcolor, pConfig.loadingcolor], "Color");
		this._setVar("_titleSize", 			[_root.titlesize, pConfig.titlesize], 		"Number");
		this._setVar("_onClick", 			[_root.onclick, pConfig.onclick], 			"String");
		this._setVar("_onClickTarget", 		[_root.onclicktarget, pConfig.onclicktarget], "String");
		this._setVar("_showPlayer", 		[_root.showplayer, pConfig.showplayer],		"String");
		this._setVar("_playerTimeout", 		[_root.playertimeout, pConfig.playertimeout], "Number");
		this._setVar("_bufferMessage", 		[_root.buffermessage, pConfig.buffermessage], "String");
		this._setVar("_bufferColor", 		[_root.buffercolor, pConfig.buffercolor], 	"Color");
		this._setVar("_bufferBackgroundColor", [_root.bufferbgcolor, pConfig.bufferbgcolor], "Color");
		this._setVar("_bufferShowBackground", [_root.buffershowbg, pConfig.buffershowbg], "Boolean");
		this._setVar("_forceSize", 			[_root.forcesize, pConfig.forcesize], 		"Boolean");
		this._setVar("_videoBackgroundColor", [_root.videobgcolor, pConfig.videobgcolor], "Color");
		this._setVar("_showLoading", 		[_root.showloading, pConfig.showloading], 	"String");
		this._setVar("_volume", 			[_root.volume, pConfig.volume], 			"Number");
		this._setVar("_shortcut", 			[_root.shortcut, pConfig.shortcut], 		"Boolean");
		this._setVar("_showFullscreen", 	[_root.showfullscreen, pConfig.showfullscreen], "Boolean");
		this._setVar("_showSwitchSubtitles",[_root.showswitchsubtitles, pConfig.showswitchsubtitles], "Boolean");
		this._setVar("_titleColor", 		[_root.titlecolor, pConfig.titlecolor], 	"Color");
		this._setVar("_onDoubleClick", 		[_root.ondoubleclick, pConfig.ondoubleclick], "String");
		this._setVar("_onDoubleClickTarget", [_root.ondoubleclicktarget, pConfig.ondoubleclicktarget], "String");
		this._setVar("_showMouse", 			[_root.showmouse, pConfig.showmouse], 		"String");
		this._setVar("_playerAlpha", 		[_root.playeralpha, pConfig.playeralpha], 	"Number");
		this._setVar("_showTitleAndStartimage", [_root.showtitleandstartimage, pConfig.showtitleandstartimage], 	"Boolean");
		this._setVar("_showIconPlay", 			[_root.showiconplay, pConfig.showiconplay], 	"Boolean");
		this._setVar("_iconPlayColor", 			[_root.iconplaycolor, pConfig.iconplaycolor], 	"Color");
		this._setVar("_iconPlayBackgroundColor", [_root.iconplaybgcolor, pConfig.iconplaybgcolor], 	"Color");
		this._setVar("_iconPlayBackgroundAlpha", [_root.iconplaybgalpha, pConfig.iconplaybgalpha], 	"Number");
		
		// Initialize top containers
		for (var i:String in _root) {
			if (i.indexOf("top") === 0) {
				// The parameter starts with "top"
				var depth:Number = Number(i.substring(3));
				var params:Array = _root[i].split("|");
				var url:String = params[0];
				var horizontal:String = (params[1] === undefined)?"":params[1];
				var vertical:String = (params[2] === undefined)?"":params[2];
				this._topContainers.push({depth:depth, url:url, verticalAlign:vertical, horizontalAlign:horizontal});
			}
		}
	}
}