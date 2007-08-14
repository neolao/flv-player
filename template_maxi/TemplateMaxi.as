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
 * @version 	1.3.0 (14/08/2007)
 * @license		http://creativecommons.org/licenses/by-sa/3.0/deed.fr
 */ 
class TemplateMaxi extends ATemplate
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
	 * La marge de la vidéo	 */
	private var _videoMargin:Number = 5;
	/**
	 * La couleur des sous-titres	 */
	private var _subtitleColor:Number = 0xffffff;
	/**
	 * La couleur du fond des sous-titres	 */
	private var _subtitleBackgroundColor:Number;
	/**
	 * La taille des sous-titres	 */
	private var _subtitleSize:Number = 11;
	/**
	 * L'instance du clip des sous-titres	 */
	private var _subtitles:MovieClip;
	/**
	 * Le format de la police du titre	 */
	private var _titleFormat:TextFormat;
	/**
	 * Le format de la police des sous-titres	 */
	private var _subtitleFormat:TextFormat;
	/**
	 * Le format de la police du temps	 */
	private var _timeFormat:TextFormat;
	/**
	 * Le fond du lecteur
	 */
	private var _playerBackground:MovieClip;
	/**
	 * Les séparateurs du lecteur	 */
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
	 * L'interval du lecteur pour la fermeture	 */
	private var _playerItv:Number;
	/**
	 * L'écouteur de la souris	 */
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
	 * Le titre de la vidéo	 */
	private var _title:String = "";
	/**
	 * L'image de titre de la vidéo	 */
	private var _startImage:String;
	/**
	 * Le bouton Stop	 */
	private var _showStop:Boolean = false;
	/**
	 * Le bouton Volume	 */
	private var _showVolume:Boolean = false;
	/**
	 * Le bouton Time
	 * 
	 * 0: ne pas afficher
	 * 1: afficher le temps écoulé par défaut
	 * 2: afficher le temps restant par défaut	 */
	private var _showTime:Number = 0;
	/**
	 * Le skin	 */
	private var _backgroundSkin:String;
	/**
	 * La couleur du fond tout au fond vraiment au fond fond fond	 */
	private var _backgroundColor:Number;
	/**
	 * La couleur 1 du fond	 */
	private var _backgroundColor1:Number = 0x7c7c7c;
	/**
	 * La couleur 2 du fond	 */
	private var _backgroundColor2:Number = 0x333333;
	/**
	 * Le volume	 */
	private var _volume:Number = 100;
	/**
	 * Le volume maximum	 */
	private var _volumeMax:Number = 200;
	/**
	 * Interval for onclick	 */
	private var _onClickInterval:Number = -1;
	/**
	 * Action on click
	 * 
	 * - "playpause" : Toggle play / pause
	 * - "none" : do nothing
	 * - url : open new url	 */
	private var _onClick:String = "playpause";
	/**
	 * The onclick's target	 */
	private var _onClickTarget:String = "_self";
	/**
	 * Action on double click
	 * 
	 * - "none" : do nothing
	 * - "fullscreen" : Toggle fullscreen / normal view
	 * - "playpause" : Toggle play / pause
	 * - url : open new url	 */
	private var _onDoubleClick:String = "none";
	/**
	 * The double click's target	 */
	private var _onDoubleClickTarget:String = "_self";
	/**
	 * Taille de la police du titre	 */
	private var _titleSize:Number = 20;
	/**
	 * Type d'affichage du lecteur
	 * 
	 * autohide, always, never
	 */	private var _showPlayer:String = "autohide";
	/**
	 * Le délai avant que le lecteur ne soit masqué, en milliseconde	 */
	private var _playerTimeout:Number = 1500;
	/**
	 * Le message de la mémoire tampon
	 * 
	 * _n_ pour le pourcentage	 */
	private var _bufferMessage:String = "Buffering _n_";
	/**
	 * Force la taille indiqué pour la vidéo	 */
	private var _forceSize:Boolean = false;
	/**
	 * Affichage de la barre de chargement
	 * 
	 * - always : Toujours afficher
	 * - never : Toujours cacher
	 * - autohide : Afficher pendant le chargement uniquement	 */
	private var _showLoading:String = "autohide";
	/**
	 * Indique s'il y a une couleur de fond au message de buffer	 */
	private var _bufferShowBackground:Boolean = true;
	/**
	 * La couleur de fond du message de buffer	 */
	private var _bufferBackgroundColor:Number = 0;
	/**
	 * La couleur de texte du message de buffer	 */
	private var _bufferColor:Number = 0xffffff;
	/**
	 * La couleur de fond de la vidéo (quand il n'y a pas de vidéo ^.^;)	 */
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
	 * La marge gauche du slider	 */
	private var _marginSlider:Number = 0;
	/**
	 * Mémorisation des paramètres en non fullscreen	 */
	private var _stageNormalParams:Object;
	/**
	 * Affichage du bouton "Close Captions"	 */
	private var _showSwitchSubtitles:Boolean = false;
	/**
	 * La couleur du titre de la vidéo
	 */
	private var _titleColor:Number = 0xffffff;
	/**
	 * La dernière valeur du buffer	 */
	private var _lastBuffer:Number = 0;
	/**
	 * Indique que la vidéo est en position STOP	 */
	private var _stopped:Boolean = true;
	/**
	 * Mouse display type:
	 *   - "always" : The mouse is always visible
	 *   - "autohide" : The mouse is hidden after 1500 milliseconds
	 *   - "never" : The mouse is never visible	 */
	private var _showMouse:String = "always";
	/**
	 * L'instance du controleur de la vidéo
	 */
	public var controller:PlayerDefault;
	/**
	 * Alpha transparency of the player	 */
	private var _playerAlpha:Number = 100;
	
	/*============================= CONSTRUCTEUR =============================*/
	/*========================================================================*/
	/**
	 * Initialisation
	 */
	public function TemplateMaxi()
	{
		super();
		
		this._initBackground();
		this._initFont();
		this._initTitle();
		this._initSubtitles();
		

		this._marginSlider = BUTTON_WIDTH;
		var vSeparators:Array = [BUTTON_WIDTH]; // Premier séparateur pour le bouton Play
		if (this._showStop) {
			this._marginSlider += BUTTON_WIDTH;
			vSeparators.push(BUTTON_WIDTH);
		}
		if (this._showVolume) {
			this._marginSlider += VOLUME_WIDTH;
			vSeparators.push(VOLUME_WIDTH);
		}
		if (this._showSwitchSubtitles) {
			this._marginSlider += BUTTON_WIDTH;
			vSeparators.push(BUTTON_WIDTH);
		}
		if (this._showFullscreen) {
			this._marginSlider += BUTTON_WIDTH;
			vSeparators.push(BUTTON_WIDTH);
		}
		this._initPlayerTime();
		if (this._showTime > 0) {
			this._marginSlider += this._playerTime._width + 10;
			vSeparators.push(this._playerTime._width + 10);
		}
		this._initPlayerSlider(this._marginSlider);
		this._createSeparators(vSeparators);
		
		// Initialisation des événements du Fullscreen
		var fullscreenListener:Object = new Object();
		fullscreenListener.onFullScreen = this.delegate(this, function(pFull:Boolean)
		{
			if (!this._isFullscreen) {
				this._onStageFullscreen();
			} else {
				this._onStageNormal();
			}
		});
		Stage.addListener(fullscreenListener);
		
		// Initialize logo logo
		_root.createEmptyMovieClip("top", _root.getNextHighestDepth());
		this.loadMovieOnTop = _root.logo;
		
		// Auto resize
		/* for netvibes
		var stageListener:Object = new Object();
		stageListener.onResize = this.delegate(this, function () {
		     this._onStageFullscreen();
		});
		Stage.addListener(stageListener);
		*/
	}
	/**
	 * Lancé par mtasc
	 */
	static function main():Void
	{
		// On vérifie s'il y a un fichier de configuration à charger
		if (_root.config != undefined) {
			// Fichier de configuration texte
			var vConfigLoad:LoadVars = new LoadVars();
			vConfigLoad.onData = function(data:String) {
				if (data != undefined) {
					data = data.split("\r\n").join("\n");
					var newdata:Array = data.split("\n");
					
					for (var i=0; i<newdata.length; i++) {
						var detail:Array = newdata[i].split("=");
						if (detail[0] != "") {
							if (_root[detail[0]] == undefined) {
								_root[detail[0]] = detail[1];
							}
						}
					}
				}
				// Initialisation du lecteur
				_root.player = new TemplateMaxi();
				var player:PlayerBasic = new PlayerDefault(_root.player);
			};
			vConfigLoad.load(_root.config, vConfigLoad, "GET");
			
		} else if (_root.configxml != undefined) {
			// Fichier de configuration XML
			var vConfigLoad:XML = new XML();
			vConfigLoad.ignoreWhite = true;
			vConfigLoad.onLoad = function(success:Boolean) {
				if (success) {
					for (var i=0; i<this.firstChild.childNodes.length; i++) {
						var name:String = this.firstChild.childNodes[i].attributes.name;
						var value:String = this.firstChild.childNodes[i].attributes.value;
						if (name != "") {
							if (_root[name] == undefined) {
								_root[name] = value;
							}
						}
					}
				}
				// Initialisation du lecteur
				_root.player = new TemplateMaxi();
				var player:PlayerBasic = new PlayerDefault(_root.player);
			};
			vConfigLoad.load(_root.configxml);
		} else {
			// Aucun fichier de configuration
			// Initialisation du lecteur
			_root.player = new TemplateMaxi();
			var player:PlayerBasic = new PlayerDefault(_root.player);
		}
		
	}
	/*======================= FIN = CONSTRUCTEUR = FIN =======================*/
	/*========================================================================*/
	
	/*=========================== METHODES PRIVEES ===========================*/
	/*========================================================================*/
	/**
	 * Initialisation du gestionnaire de clavier
	 */
	private function _initKey()
	{
		super._initKey();
		
		var vPlayPause:Function = this.delegate(this, function()
		{
			if (this.controller.isPlaying) {
				this.pauseRelease();
			} else {
				this.playRelease();
			}
		});
		var vIncreaseVolume:Function = this.delegate(this, function()
		{
			var vVolume:Number = this._volume;
			vVolume += 10;
			if (vVolume > this._volumeMax) {
				vVolume = this._volumeMax;
			}
			this._volume = vVolume;
			this.controller.setVolume(vVolume);
			this._updateVolume();
		});
		var vDecreaseVolume:Function = this.delegate(this, function()
		{
			var vVolume:Number = this._volume;
			vVolume -= 10;
			if (vVolume < 0) {
				vVolume = 0;
			}
			this._volume = vVolume;
			this.controller.setVolume(vVolume);
			this._updateVolume();
		});
		
		if (this._shortcut) {
			// touche "Espace"
			this._addShortcut(32, vPlayPause);
			// touche "P"
			this._addShortcut(80, vPlayPause);
			
			// touche "S"
			this._addShortcut(83, this.delegate(this, function()
			{
				this.stopRelease();
			}));
			// touche flèche gauche
			this._addShortcut(37, this.delegate(this, function()
			{
				this.controller.setPosition(this.controller.getPosition() - 5);
			}));
			// touche flèche droite
			this._addShortcut(39, this.delegate(this, function()
			{
				this.controller.setPosition(this.controller.getPosition() + 5);
			}));
			// touche flèche bas
			this._addShortcut(40, vDecreaseVolume);
			// touche "-"
			this._addShortcut(109, vDecreaseVolume);
			this._addShortcut(189, vDecreaseVolume);
			// touche flèche haut
			this._addShortcut(38, vIncreaseVolume);
			// touche "+"
			this._addShortcut(107, vIncreaseVolume);
			this._addShortcut(187, vIncreaseVolume);
			// touche "C"
			this._addShortcut(67, this.delegate(this, function()
			{
				this.showSubtitlesRelease();
			}));
		}
		/*
		// Pour connaitre le code de la touche
		var o:Object = new Object();
		o.onKeyUp = this.delegate(this, function() 
		{
			this.video.title_txt.text = Key.getCode();
		});
		Key.addListener(o);
		*/
	}
	/**
	 * Modification d'une variable suivant des priorités
	 * 
	 * @param pVarName Le nom de la variable à modifier
	 * @param pList La liste des valeurs par ordre de priorité
	 * @param pType Le type de la variable: String, Number, Color ou Boolean (String par défaut)
	 * @return true si la variable a été modifié, sinon false
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
	 * Initialisation des variables
	 * 
	 * @param pConfig La configuration par défaut
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
	}
	/**
	 * Initialisation du buffering
	 */
	private function _initBuffering(){
		if (!this.video.buffering_mc) {
			this._buffering = this.video.createEmptyMovieClip("buffering_mc", this.video.getNextHighestDepth());
			
			this._buffering.createTextField("message_txt", this._buffering.getNextHighestDepth(), 0, 0, 0, 0);
			this._buffering.message_txt.selectable = false;
			this._buffering.message_txt.textColor = this._bufferColor;
			this._buffering.message_txt.background = this._bufferShowBackground;
			this._buffering.message_txt.backgroundColor = this._bufferBackgroundColor;
			this._buffering.message_txt.text = "buffering ...";
			this._buffering.message_txt.autoSize = "left";
			this._buffering._visible = false;
		}
	}
	/**
	 * Initialisation du fond
	 */
	private function _initBackground(){
		// Le skin
		if(this._backgroundSkin != undefined){
			// Une image de skin a été définie
			this._background.loadMovie(this._backgroundSkin);
		}else{
			var vWidth:Number = this._swfWidth;
			var vHeight:Number = this._swfHeight;
			
			// La couleur de fond fond fond si elle est définie
			if(this._backgroundColor != undefined){ 
				this._background.beginFill(this._backgroundColor); 
				this._background.lineTo(0, vHeight); 
				this._background.lineTo(vWidth, vHeight); 
				this._background.lineTo(vWidth, 0); 
				this._background.endFill(); 
			}
			
			this._background.beginGradientFill("linear", 
				[this._backgroundColor1, this._backgroundColor2], 
				[100,100], 
				[0,255], 
				{matrixType:"box", x:0, y:0, w:vWidth, h:vHeight, r:Math.PI/2});
			_background.moveTo(0, 5);
			_background.lineTo(0, vHeight - 5);
			_background.curveTo(0, vHeight, 5, vHeight);
			_background.lineTo(vWidth - 5, vHeight);
			_background.curveTo(vWidth, vHeight, vWidth, vHeight - 5);
			_background.lineTo(vWidth, 5);
			_background.curveTo(vWidth, 0, vWidth - 5, 0);
			_background.lineTo(5, 0);
			_background.curveTo(0, 0, 0, 5);
			_background.endFill();
		}
	}
	/**
	 * Initialisation de la vidéo
	 */
	private function _initVideo()
	{
		//super._initVideo(); // Je n'utilise pas la méthode parente parce que je veux personnaliser la couleur de fond
		// Fond de la taille de la vidéo
		this.video.clear();
		this.video.beginFill(this._videoBackgroundColor);
		this.video.lineTo(0, this._swfHeight - this._videoMargin*2);
		this.video.lineTo(this._swfWidth - this._videoMargin*2, this._swfHeight - this._videoMargin*2);
		this.video.lineTo(this._swfWidth - this._videoMargin*2, 0);
		this.video.endFill();

		this.video.video._width = this._swfWidth - this._videoMargin*2;
		this.video.video._height = this._swfHeight - this._videoMargin*2;
		this.video.video._x = 0;
		this.video.video._y = 0;
		
		
		// Action on click (transparent background)
		var vButton:MovieClip;
		if (!this.video.button_mc) {
			vButton = this.video.createEmptyMovieClip("button_mc", this.video.getNextHighestDepth());
		} else {
			vButton = this.video.button_mc;
		}
		vButton.clear();
		vButton.beginFill(0, 0);
		vButton.lineTo(0, this._swfHeight - this._videoMargin*2);
		vButton.lineTo(this._swfWidth - this._videoMargin*2, this._swfHeight - this._videoMargin*2);
		vButton.lineTo(this._swfWidth - this._videoMargin*2, 0);
		vButton.endFill();
		vButton.tabEnabled = false;
		vButton.useHandCursor = false;
		
		vButton.onRelease = this.delegate(this, function()
		{
			if (this._onClickInterval != -1) {
				clearInterval(this._onClickInterval);
				this._onClickInterval = -1;
				this._videoOnDoubleClick();
			} else {
				clearInterval(this._onClickInterval);
				this._onClickInterval = setInterval(this, "_videoOnClick", 180);
			}
		});
		
		// Un masque pour pas que la vidéo ne dépasse sur la marge
		var vMask:MovieClip;
		if (!this.video._parent.mask_mc) {
			vMask = this.video._parent.createEmptyMovieClip("mask_mc", this.video._parent.getNextHighestDepth());
		} else {
			vMask = this.video._parent.mask_mc;
		}
		vMask._x = this._videoMargin;
		vMask._y = this._videoMargin;
		vMask.clear();
		vMask.beginFill(0, 0);
		vMask.lineTo(0, this._swfHeight - this._videoMargin*2);
		vMask.lineTo(this._swfWidth - this._videoMargin*2, this._swfHeight - this._videoMargin*2);
		vMask.lineTo(this._swfWidth - this._videoMargin*2, 0);
		vMask.endFill();
		this.video.setMask(vMask);
		
		// Dimension du conteneur vidéo
		this.video._xscale = 100;
		this.video._yscale = 100;
		this.video._x = this._videoMargin;
		this.video._y = this._videoMargin;
		
		// Initialisation du buffer
		this._initBuffering();
	}
	/**
	 * The user click on the video	 */
	private function _videoOnClick()
	{
		// Reset onclick interval
		clearInterval(this._onClickInterval);
		this._onClickInterval = -1;
		
		// Actions
		switch (this._onClick) {
			case "playpause":
				if (this.controller.isPlaying) {
					this.pauseRelease();
				} else {
					this.playRelease();
				}
				break;
			case "none":
				break;
			default:
				getURL(this._onClick, this._onClickTarget);
		}
	}
	/**
	 * The user double click on the video	 */
	private function _videoOnDoubleClick()
	{
		// Actions
		switch (this._onDoubleClick) {
			case "fullscreen":
				this.fullscreenRelease();
				break;
			case "playpause":
				if (this.controller.isPlaying) {
					this.pauseRelease();
				} else {
					this.playRelease();
				}
				break;
			case "none":
				break;
			default:
				getURL(this._onDoubleClick, this._onDoubleClickTarget);
		}
	}
	/**
	 * Initialisation de la police	 */
	private function _initFont()
	{
		var vFontList:Array = TextField.getFontList();
		var vFontListString:String = "|" + vFontList.join("|") + "|";
		var vFont:String = "_sans";
		
		// Recherche de la police Verdana si elle existe
		if(vFontListString.indexOf("|Verdana|") != -1){
			vFont = "Verdana";
		}
		
		this._subtitleFormat = new TextFormat();
		this._subtitleFormat.size = this._subtitleSize;
		this._subtitleFormat.bold = true;
		this._subtitleFormat.align = "center";
		this._subtitleFormat.font = vFont;
		
		this._titleFormat = new TextFormat();
		this._titleFormat.size = this._titleSize;
		this._titleFormat.bold = true;
		this._titleFormat.align = "center";
		this._titleFormat.font = vFont;
		
		this._timeFormat = new TextFormat();
		this._timeFormat.size = 11;
		this._timeFormat.align = "left";
		this._timeFormat.font = vFont;
	}
	/**
	 * Initialisation des sous-titres
	 */
	private function _initSubtitles()
	{
		var vDepth:Number;
		if (this._subtitles) {
			vDepth = this._subtitles.getDepth();
			this._subtitles.removeMovieClip();
		} else {
			vDepth = this.video.getNextHighestDepth();
		}
		this._subtitles = this.video.createEmptyMovieClip("subtitles_mc", vDepth);
		
		this._subtitles.createTextField("message_txt", this._subtitles.getNextHighestDepth(), 0, 0, this._swfWidth - this._videoMargin*2, 0);
		this._subtitles.message_txt.selectable = false;
		this._subtitles.message_txt.multiline = true;
		this._subtitles.message_txt.wordWrap = true;
		this._subtitles.message_txt.textColor = this._subtitleColor;
		if (_subtitleBackgroundColor != undefined) {
			this._subtitles.message_txt.background = true;
			this._subtitles.message_txt.backgroundColor = this._subtitleBackgroundColor;
		}
		this._subtitles.message_txt.text = "";
		this._subtitles.message_txt.autoSize = "center";
		this._subtitles.message_txt.setNewTextFormat(this._subtitleFormat);
		
		this._subtitles.onEnterFrame = this.delegate(this, function()
		{
			this._subtitles.message_txt.text = this.controller.getSubtitle();
			this._subtitles._visible = !(this._subtitles.message_txt.text == "") && !this._subtitles.hide;
			this._subtitles.message_txt._x = 0;
			this._subtitles._y = this._swfHeight - this._videoMargin*2 - this._subtitles.message_txt._height;
			
			// Si le lecteur est affiché, on remonte encore
			if (this._player._visible) {
				this._subtitles._y -= this.PLAYER_HEIGHT;
			}
		});
	}
	/**
	 * Initialisation du Titre
	 */
	private function _initTitle()
	{
		// On remplace les \n par des retours de ligne dans le titre
		this._title = this._title.split("\\n").join("\n");
		this._title = this._title.split("/n").join("\n"); // pour IE
		
		// Fond noir transparent
		if (this.video.freeze_mc) {
			this.video.freeze_mc._width = this._swfWidth - this._videoMargin*2;
			this.video.freeze_mc._height = this._swfHeight - this._videoMargin*2;
		} else {
			var vFreeze:MovieClip = this.video.createEmptyMovieClip("freeze_mc", this.video.getNextHighestDepth());
			vFreeze.beginFill(0, 75);
			vFreeze.lineTo(0, this._swfHeight - this._videoMargin*2);
			vFreeze.lineTo(this._swfWidth - this._videoMargin*2, this._swfHeight - this._videoMargin*2);
			vFreeze.lineTo(this._swfWidth - this._videoMargin*2, 0);
			vFreeze.endFill();
		}
		
		// Image de départ
		var vImageDepth:Number;
		var vImageVisible:Boolean = true;
		if (this.video.image_mc) {
			vImageDepth = this.video.image_mc.getDepth();
			vImageVisible = this.video.image_mc._visible;
			this.video.image_mc.removeMovieClip();
		} else {
			vImageDepth = this.video.getNextHighestDepth();
		}
		this.video.createEmptyMovieClip("image_mc", vImageDepth);
		this._initStartImage();
		this.video.image_mc._visible = vImageVisible;
		
		// Titre
		if (!this.video.title_txt) {
			this.video.createTextField("title_txt", this.video.getNextHighestDepth(), 0, 0, this._swfWidth - this._videoMargin*2, 0);
			this.video.title_txt.multiline = true;
			this.video.title_txt.wordWrap = true;
			this.video.title_txt.selectable = false;
			this.video.title_txt.textColor = _titleColor;
			this.video.title_txt.text = _title;
			this.video.title_txt.autoSize = "center";
			this.video.title_txt.setTextFormat(this._titleFormat);
		}
		this.video.title_txt._width = this._swfWidth;
		this.video.title_txt._y = (this._swfHeight - this._videoMargin*2) / 2 - this.video.title_txt._height / 2;
		
	}
	/**
	 * Initialisation de l'image de départ	 */
	private function _initStartImage()
	{
		if(this._startImage != undefined){
			this.video.image_mc.loadMovie(this._startImage);
				
			// Pour la taille réelle
			this.video.image_mc._xscale = 100;
			this.video.image_mc._yscale = 100;
			
			// Ajuster la taille à la vidéo et aussi centrer
			this.video.onEnterFrame = this.delegate(this, function()
			{
				if (this.video.image_mc._width > 0) {
					var vWidth:Number = this.video.image_mc._width;
					var vHeight:Number = this.video.image_mc._height;
					
					this.video.image_mc._width = this._swfWidth - this._videoMargin*2;
					this.video.image_mc._height = this._swfHeight - this._videoMargin*2;
					
					if (this._showPlayer == "always") {
						this.video.image_mc._height -= this.PLAYER_HEIGHT;
					}
					
					if (this.video.image_mc._yscale > this.video.image_mc._xscale) {
						this.video.image_mc._yscale = this.video.image_mc._xscale;
					} else {
						this.video.image_mc._xscale = this.video.image_mc._yscale;
					}
					this.video.image_mc._x = Math.floor((this._swfWidth - this._videoMargin*2 - this.video.image_mc._width) / 2);
					
					if (this._showPlayer == "always") {
						this.video.image_mc._y = Math.floor((this._swfHeight - this._videoMargin*2 - this.video.image_mc._height - this.PLAYER_HEIGHT) / 2);
					} else {
						this.video.image_mc._y = Math.floor((this._swfHeight - this._videoMargin*2 - this.video.image_mc._height) / 2);
					}
					
					delete this.video.onEnterFrame;
				};
			});
		}
	}
	/**
	 * Initialisation du lecteur
	 */
	private function _initPlayer()
	{
		if (this._player) {
			this._player.removeMovieClip();
		}
		super._initPlayer();
		
		if (this._showMouse == "never") {
			Mouse.hide();
		}
		
		if (this._showPlayer !== "never") {
			this._player._y = this._swfHeight - PLAYER_HEIGHT - this._videoMargin;
			this._player._x = this._videoMargin;
			
			this._initPlayerBackground();
			this._initPlayerPlay();
			this._initPlayerPause();
			this._initPlayerStop();
			this._initPlayerVolume();
			this._initPlayerSwitchSubtitles();
			this._initPlayerFullscreen();
			
			this._mouse = new Object();
			this._mouse.onMouseMove = this.delegate(this, function(){
				if (this._showMouse != "never") {
					Mouse.show();
				}
				
				this._player._visible = true;
				clearInterval(this._playerItv);
				this._playerItv = setInterval(this, "_playerInterval", this._playerTimeout);
			});
		} else {
			this._player._visible = false;
		}
	}
	/** 
	 * Affichage du lecteur lorsque la souris est sur la video
	 */ 
	private function _playerInterval()
	{
		if (this._showMouse == "autohide") {
			Mouse.hide();
		}
		this._player._visible = false;
		clearInterval(this._playerItv);
	}
	/**
	 * Initialisation du fond du lecteur
	 */
	private function _initPlayerBackground()
	{
		if (!this._playerBackground) {
			this._playerBackground = this._player.createEmptyMovieClip("background_mc", this._player.getNextHighestDepth()); 
		}
		
		this._playerBackground.clear();
		this._playerBackground.beginFill(this._playerColor, this._playerAlpha);
		this._playerBackground.lineTo(0, PLAYER_HEIGHT);
		this._playerBackground.lineTo(this.video.video._width, PLAYER_HEIGHT);
		this._playerBackground.lineTo(this.video.video._width, 0);
		this._playerBackground.endFill();
	}
	/**
	 * Crée les séparateurs de bouton
	 * 
	 * @param pList La liste des distances entre séparateur
	 */
	private function _createSeparators(pList:Array)
	{
		this._playerSeparators = this._player.createEmptyMovieClip("separators_mc", this._player.getNextHighestDepth()); 
		
		var vTotal:Number = 0;
		for (var i:Number=0; i<=pList.length; i++) {
			vTotal += pList[i];
			this._playerSeparators.beginFill(0xcccccc, 50);
			this._playerSeparators.moveTo(vTotal, 2);
			this._playerSeparators.lineTo(vTotal, PLAYER_HEIGHT - 2);
			this._playerSeparators.lineTo(vTotal + 1, PLAYER_HEIGHT - 2);
			this._playerSeparators.lineTo(vTotal + 1, 2);
			this._playerSeparators.endFill();
			this._playerSeparators.beginFill(0x666666, 50);
			this._playerSeparators.lineTo(vTotal - 1, 2);
			this._playerSeparators.lineTo(vTotal - 1, PLAYER_HEIGHT - 2);
			this._playerSeparators.lineTo(vTotal, PLAYER_HEIGHT - 2);
			this._playerSeparators.endFill();
		}
	}
	/**
	 * Initialisation d'un bouton
	 * @param pTarget Le bouton à initialiser
	 * @param pWidth (optional) La largeur du bouton
	 */
	private function _initButton(pTarget:MovieClip, pWidth:Number)
	{
		if (pWidth == undefined) {
			pWidth = BUTTON_WIDTH;
		}
		
		var vArea:MovieClip = pTarget.createEmptyMovieClip("area_mc", pTarget.getNextHighestDepth());
		var vIcon:MovieClip = pTarget.createEmptyMovieClip("icon_mc", pTarget.getNextHighestDepth());
		
		vArea.beginFill(0, 0);
		vArea.lineTo(0, PLAYER_HEIGHT);
		vArea.lineTo(pWidth, PLAYER_HEIGHT);
		vArea.lineTo(pWidth, 0);
		vArea.endFill();
		
		vArea.parent = this;
		vArea.color = new Color(vIcon);
		vArea.tabEnabled = false;
		vArea.onRollOver = function()
		{ 
			this.color.setRGB(this.parent._buttonOverColor); 
		}; 
		vArea.onRollOut = vArea.onDragOut = vArea.onPress = function()
		{ 
			this.color.setRGB(this.parent._buttonColor); 
		}; 
	}
	/** 
	 * Change l'état d'un bouton 
	 * @param pButton L'instance du bouton 
	 * @param pStatus true pour activer le bouton, sinon false 
	 * @param pMask (optional) pour masquer complètement le bouton
	 */ 
	private function _enableButton(pButton:MovieClip, pStatus:Boolean, pMask:Boolean)
	{ 
		pButton.area_mc.enabled = pStatus; 
		pButton._visible = !pMask; 
		if (!pStatus) pButton.icon_mc._alpha = 30; 
		else pButton.icon_mc._alpha = 100; 
	}
	/**
	 * Initialisation du bouton play
	 */
	private function _initPlayerPlay()
	{
		this._playerPlay = this._player.createEmptyMovieClip("play_btn", this._player.getNextHighestDepth()); 
		this._initButton(this._playerPlay);
		
		this._playerPlay.area_mc.onRelease = this.delegate(this, this.playRelease);
		
		// icone
		this._playerPlay.icon_mc.beginFill(_buttonColor);
		this._playerPlay.icon_mc.lineTo(0, 8);
		this._playerPlay.icon_mc.lineTo(6, 4);
		this._playerPlay.icon_mc.endFill();
		this._playerPlay.icon_mc._y = PLAYER_HEIGHT/2 - _playerPlay.icon_mc._height/2;
		this._playerPlay.icon_mc._x = BUTTON_WIDTH/2 - _playerPlay.icon_mc._width/2;
	}
	/**
	 * Initialisation du bouton pause
	 */
	private function _initPlayerPause()
	{
		this._playerPause = this._player.createEmptyMovieClip("pause_btn", this._player.getNextHighestDepth()); 
		this._initButton(this._playerPause);
		
		this._playerPause.area_mc.onRelease = this.delegate(this, this.pauseRelease); 
		
		// icone
		this._playerPause.icon_mc.beginFill(this._buttonColor); 
		this._playerPause.icon_mc.lineTo(0, 8); 
		this._playerPause.icon_mc.lineTo(3, 8); 
		this._playerPause.icon_mc.lineTo(3, 0); 
		this._playerPause.icon_mc.endFill(); 
		this._playerPause.icon_mc.beginFill(this._buttonColor); 
		this._playerPause.icon_mc.moveTo(5, 0); 
		this._playerPause.icon_mc.lineTo(5, 8); 
		this._playerPause.icon_mc.lineTo(8, 8); 
		this._playerPause.icon_mc.lineTo(8, 0); 
		this._playerPause.icon_mc.endFill(); 
		this._playerPause.icon_mc._y = PLAYER_HEIGHT/2 - _playerPause.icon_mc._height/2;
		this._playerPause.icon_mc._x = BUTTON_WIDTH/2 - _playerPause.icon_mc._width/2;
	}
	/**
	 * Initialisation du bouton stop
	 */
	private function _initPlayerStop()
	{
		if (this._showStop) {
			this._playerStop = this._player.createEmptyMovieClip("stop_btn", this._player.getNextHighestDepth()); 
			this._initButton(this._playerStop);
			
			this._playerStop._x = BUTTON_WIDTH;
			
			this._playerStop.area_mc.onRelease = this.delegate(this, this.stopRelease); 
			
			// icone
			this._playerStop.icon_mc.beginFill(this._buttonColor); 
			this._playerStop.icon_mc.lineTo(0, 8);
			this._playerStop.icon_mc.lineTo(8, 8);
			this._playerStop.icon_mc.lineTo(8, 0);
			this._playerStop.icon_mc.endFill(); 
			this._playerStop.icon_mc._y = PLAYER_HEIGHT/2 - _playerStop.icon_mc._height/2;
			this._playerStop.icon_mc._x = BUTTON_WIDTH/2 - _playerStop.icon_mc._width/2;
		}
	}
	/**
	 * Initialisation du bouton Volume
	 */
	private function _initPlayerVolume()
	{
		if (this._showVolume) {
			this._playerVolume = this._player.createEmptyMovieClip("volume_btn", this._player.getNextHighestDepth());
			this._initButton(this._playerVolume, VOLUME_WIDTH);
			
			this._playerVolume._x = BUTTON_WIDTH;
			if (this._showStop) {
				this._playerVolume._x += BUTTON_WIDTH;
			}
			
			this._playerVolume.area_mc.onPress = this.delegate(this, this._volumePress);
			this._playerVolume.area_mc.onRelease = this.delegate(this, this._volumeRelease);
			this._playerVolume.area_mc.onReleaseOutside = this.delegate(this, this._volumeRelease);
			
			// icone fond
			var vIconBackground:MovieClip = this._playerVolume.icon_mc.createEmptyMovieClip("background_mc", 1);
			vIconBackground.beginFill(this._buttonColor, 25);
			vIconBackground.moveTo(0, VOLUME_HEIGHT);
			vIconBackground.lineTo(VOLUME_WIDTH - 8, VOLUME_HEIGHT);
			vIconBackground.lineTo(VOLUME_WIDTH - 8, 0);
			vIconBackground.endFill();
			vIconBackground._y = PLAYER_HEIGHT/2 - vIconBackground._height/2;
			vIconBackground._x = VOLUME_WIDTH/2 - vIconBackground._width/2;
			
			// icone
			this._updateVolume();
		}
	}
	/**
	 * Mise à jour du bouton Volume
	 */
	private function _updateVolume()
	{
		var vIcon:MovieClip;
		if (this._playerVolume.icon_mc.current_mc == undefined) {
			vIcon = this._playerVolume.icon_mc.createEmptyMovieClip("current_mc", 2);
		} else {
			vIcon = this._playerVolume.icon_mc.current_mc;
		}
		vIcon.clear();
		
		if (this._volume > this._volumeMax) {
			this._volume = this._volumeMax;
		}
		
		var vWidth:Number = (VOLUME_WIDTH - 8) * this._volume / this._volumeMax;
		var vRatio:Number = this._volume / this._volumeMax;
		
		vIcon.beginFill(this._buttonColor);
		vIcon.moveTo(0, VOLUME_HEIGHT);
		vIcon.lineTo(vWidth, VOLUME_HEIGHT);
		vIcon.lineTo(vWidth, VOLUME_HEIGHT - VOLUME_HEIGHT * vRatio);
		vIcon.endFill();
		vIcon._y = vIcon._parent.background_mc._y;
		vIcon._x = vIcon._parent.background_mc._x;
	}
	/**
	 * Le enterFrame pendant l'appui du bouton Volume
	 */
	private function _volumeEnterFrame()
	{
		var xmouse:Number = this._playerVolume.icon_mc.current_mc._xmouse;
		var max:Number = this._playerVolume.icon_mc.background_mc._width;
		if (xmouse < 0) {
			xmouse = 0;
		}
		if (xmouse > max) {
			xmouse = max;
		}
		
		var volume:Number = xmouse * this._volumeMax / max;
		this.controller.setVolume(volume);
		this._volume = volume;
		this._updateVolume();
	}
	/**
	 * On appuie sur le bouton Volume
	 */
	private function _volumePress()
	{
		this._playerVolume.onEnterFrame = this.delegate(this, this._volumeEnterFrame);
	}
	/**
	 * On relâche le bouton Volume
	 */
	private function _volumeRelease()
	{
		delete this._playerVolume.onEnterFrame;
	}
	/**
	 * Initialisation du bouton "Close Captions"
	 */
	private function _initPlayerSwitchSubtitles()
	{
		if (this._showSwitchSubtitles) {
			this._playerShowSubtitles = this._player.createEmptyMovieClip("showSubtitles_btn", this._player.getNextHighestDepth()); 
			this._initButton(this._playerShowSubtitles);
			
			this._playerShowSubtitles._x = BUTTON_WIDTH;
			if (this._showStop) {
				this._playerShowSubtitles._x += BUTTON_WIDTH;
			}
			if (this._showVolume) {
				this._playerShowSubtitles._x += VOLUME_WIDTH;
			}
			
			this._playerShowSubtitles.area_mc.onRelease = this.delegate(this, this.showSubtitlesRelease); 
			
			// icone
			this._playerShowSubtitles.icon_mc.lineStyle(1, this._buttonColor, 100);
			this._playerShowSubtitles.icon_mc.lineTo(0, 10);
			this._playerShowSubtitles.icon_mc.lineTo(14, 10);
			this._playerShowSubtitles.icon_mc.lineTo(14, 0);
			this._playerShowSubtitles.icon_mc.lineTo(0, 0);
			
			this._playerShowSubtitles.icon_mc.moveTo(7, 3);
			this._playerShowSubtitles.icon_mc.lineTo(6, 2);
			this._playerShowSubtitles.icon_mc.curveTo(0, 5, 6, 8);
			this._playerShowSubtitles.icon_mc.lineTo(7, 7);
			
			this._playerShowSubtitles.icon_mc.moveTo(12, 3);
			this._playerShowSubtitles.icon_mc.lineTo(11, 2);
			this._playerShowSubtitles.icon_mc.curveTo(5, 5, 11, 8);
			this._playerShowSubtitles.icon_mc.lineTo(12, 7);
			
			this._playerShowSubtitles.icon_mc._y = PLAYER_HEIGHT/2 - this._playerShowSubtitles.icon_mc._height/2 + 1;
			this._playerShowSubtitles.icon_mc._x = BUTTON_WIDTH/2 - this._playerShowSubtitles.icon_mc._width/2 + 1;
		}
	}
	/**
	 * Initialisation du bouton Fullscreen
	 */
	private function _initPlayerFullscreen()
	{
		if (this._showFullscreen) {
			this._playerFullscreen = this._player.createEmptyMovieClip("fullscren_btn", this._player.getNextHighestDepth()); 
			this._initButton(this._playerFullscreen);
			
			this._playerFullscreen._x = BUTTON_WIDTH;
			if (this._showStop) {
				this._playerFullscreen._x += BUTTON_WIDTH;
			}
			if (this._showVolume) {
				this._playerFullscreen._x += VOLUME_WIDTH;
			}
			if (this._showSwitchSubtitles) {
				this._playerFullscreen._x += BUTTON_WIDTH;
			}
			
			this._playerFullscreen.area_mc.onRelease = this.delegate(this, this.fullscreenRelease); 
			
			// icone
			this._playerFullscreen.icon_mc.lineStyle(1, this._buttonColor, 100);
			this._playerFullscreen.icon_mc.lineTo(0, 12);
			this._playerFullscreen.icon_mc.lineTo(12, 12);
			this._playerFullscreen.icon_mc.lineTo(12, 0);
			this._playerFullscreen.icon_mc.lineTo(0, 0);
			
			this._playerFullscreen.icon_mc.lineStyle(2, this._buttonColor, 100);
			this._playerFullscreen.icon_mc.moveTo(6, 4);
			this._playerFullscreen.icon_mc.lineTo(9, 4);
			this._playerFullscreen.icon_mc.lineTo(9, 7);
			this._playerFullscreen.icon_mc.moveTo(9, 4);
			this._playerFullscreen.icon_mc.lineTo(4, 9);
			
			this._playerFullscreen.icon_mc._y = PLAYER_HEIGHT/2 - this._playerFullscreen.icon_mc._height/2 + 1;
			this._playerFullscreen.icon_mc._x = BUTTON_WIDTH/2 - this._playerFullscreen.icon_mc._width/2 + 1;
		}
	}
	/**
	 * Initialisation du bouton Time
	 */
	private function _initPlayerTime()
	{
		if (this._showTime > 0) {
			this._playerTime = this._player.createEmptyMovieClip("time_btn", this._player.getNextHighestDepth());
			
			// position
			this._playerTime._x = BUTTON_WIDTH;
			if (this._showStop) {
				this._playerTime._x += BUTTON_WIDTH;
			}
			if (this._showVolume) {
				this._playerTime._x += VOLUME_WIDTH;
			}
			if (this._showSwitchSubtitles) {
				this._playerTime._x += BUTTON_WIDTH;
			}
			if (this._showFullscreen) {
				this._playerTime._x += BUTTON_WIDTH;
			}
			
			// Champ de texte
			this._playerTime.createTextField("time_txt", this._playerTime.getNextHighestDepth(), 0, 0, 0, 0);
			this._playerTime.time_txt.selectable = false;
			this._playerTime.time_txt.textColor = this._buttonColor;
			this._playerTime.time_txt.setNewTextFormat(this._timeFormat);
			this._playerTime.time_txt.text = "00:00:00";
			this._playerTime.time_txt.autoSize = "left";
			this._playerTime.time_txt._y = PLAYER_HEIGHT/2 - this._playerTime.time_txt._height/2;
			this._playerTime.time_txt._x = 6;
			this._playerTime.type = (this._showTime == 2)?"duration":"position";
			this._playerTime.onEnterFrame = this.delegate(this, function()
			{
				var vPosition:Number;
				if (this._playerTime.type == "position") {
					vPosition = this.controller.getPosition();
				} else {
					vPosition = this.controller.getDuration() - this.controller.getPosition();
				}
				if (isNaN(vPosition)) {
					vPosition = 0;
				}
				
				var sec:Number = Math.floor(vPosition) % 60;
				var min:Number = Math.floor(vPosition / 60) % 60;
				var hour:Number = Math.floor(vPosition / (60 * 60)) % 24;
				this._playerTime.time_txt.text = ((hour < 10)?"0"+hour:hour) + ":" + ((min < 10)?"0"+min:min) + ":" + ((sec < 10)?"0"+sec:sec);

			});
		
			// le bouton
			var vArea:MovieClip = this._playerTime.createEmptyMovieClip("area_mc", this._playerTime.getNextHighestDepth());
			vArea.beginFill(0, 0);
			vArea.moveTo(2, 2);
			vArea.lineTo(2, PLAYER_HEIGHT - 4);
			vArea.lineTo(this._playerTime.time_txt._width + 10 - 4, PLAYER_HEIGHT - 4);
			vArea.lineTo(this._playerTime.time_txt._width + 10 - 4, 2);
			vArea.endFill();
			vArea.tabEnabled = false;
			
			vArea.onRelease = this.delegate(this, function()
			{
				if (this._playerTime.type == "position") {
					this._playerTime.type = "duration";
				} else {
					this._playerTime.type = "position";
				}
			});
		}
	}
	/**
	 * Initialisation de la barre de lecture
	 * 
	 * @param pMargin La marge gauche de la barre
	 */
	private function _initPlayerSlider(pMargin:Number)
	{
		var vDepth:Number;
		if (this._playerSlider) {
			vDepth = this._playerSlider.getDepth();
			this._playerSlider.removeMovieClip();
		} else {
			vDepth = this._player.getNextHighestDepth();
		}
		this._playerSlider = this._player.createEmptyMovieClip("slider_mc", vDepth);
		
		// calcul de la taille
		var vMargin:Number = pMargin;
		vMargin += 10;
		
		this._playerSlider._x = vMargin;
		this._playerSlider.width = this._swfWidth - vMargin - 10 - this._videoMargin*2;
		
		// grand bouton
		var vBarButton:MovieClip = this._playerSlider.createEmptyMovieClip("barButton_mc", this._playerSlider.getNextHighestDepth()); 
		vBarButton.beginFill(0xff0000, 0);
		vBarButton.moveTo(-10, 0);
		vBarButton.lineTo(this._playerSlider.width + 20, 0);
		vBarButton.lineTo(this._playerSlider.width + 20, PLAYER_HEIGHT);
		vBarButton.lineTo(-10, PLAYER_HEIGHT);
		vBarButton.endFill();
		vBarButton.tabEnabled = false;
		vBarButton.onRelease = this.delegate(this, function()
		{
			var vPosition:Number = this._playerSlider._xmouse;
			if (vPosition < 0) {
				vPosition = 0;
			}
			if (vPosition > this._playerSlider.width - this._playerSlider.bar_mc._width) {
				vPosition = this._playerSlider.width - this._playerSlider.bar_mc._width;
			}
			
			this._playerSlider.bar_mc._x = vPosition;
			
			var vPositionTime:Number = this._playerSlider.bar_mc._x / (this._playerSlider.width - this.SLIDER_WIDTH) * this.controller.getDuration(); 
			this.controller.setPosition(vPositionTime);
		});
		
		// barre
		var vBarBg:MovieClip = this._playerSlider.createEmptyMovieClip("barBg_mc", this._playerSlider.getNextHighestDepth()); 
		vBarBg.beginFill(0xcccccc, 25);
		vBarBg.lineTo(this._playerSlider.width, 0);
		vBarBg.lineTo(this._playerSlider.width, 1);
		vBarBg.lineTo(0, 1);
		vBarBg.endFill();
		vBarBg.beginFill(0x666666, 25);
		vBarBg.moveTo(0, 0);
		vBarBg.lineTo(0, -1);
		vBarBg.lineTo(this._playerSlider.width, -1);
		vBarBg.lineTo(this._playerSlider.width, 0);
		vBarBg.endFill();
		vBarBg._y = PLAYER_HEIGHT / 2;
		
		// barre de chargement
		this._loadingBar = this._playerSlider.createEmptyMovieClip("loading_mc", this._playerSlider.getNextHighestDepth());
		this._loadingBar.beginFill(_loadingColor, 75);
		this._loadingBar.lineTo(_playerSlider.width, 0);
		this._loadingBar.lineTo(_playerSlider.width, 2);
		this._loadingBar.lineTo(0, 2);
		this._loadingBar.endFill();
		this._loadingBar._y = PLAYER_HEIGHT / 2;
		this._loadingBar._xscale = 0;
		this._loadingBar._visible = false;
		
		// barre slider 
		var vSlider:MovieClip = this._playerSlider.createEmptyMovieClip("bar_mc", this._playerSlider.getNextHighestDepth()); 
		vSlider.parent = this;
		vSlider.margin = vMargin;
		vSlider.width = SLIDER_WIDTH;
		vSlider.barWidth = this._playerSlider.width;
		vSlider.color = new Color(vSlider);
		vSlider.tabEnabled = false;
		vSlider.onRollOver = function(){
			this.color.setRGB(this.parent._sliderOverColor);
		}; 
		vSlider.onRollOut = function(){  
			var transform:Object = {ra: 100, rb: 0, ga: 100, gb: 0, ba: 100, bb: 0, aa: 100, ab: 0}; 
			this.color.setTransform(transform); 
		}; 
		vSlider.onPress = this.delegate(this, function(){
			this._playerSlider.bar_mc.startDrag(false, 0, this._playerSlider.bar_mc._y, this._playerSlider.width - this._playerSlider.bar_mc._width, this._playerSlider.bar_mc._y);
			this._playerSlider.bar_mc.onEnterFrame = this.delegate(this, this._sliderMoving);
		});
		vSlider.onRelease = vSlider.onReleaseOutside = this.delegate(this, function(){ 
			this._playerSlider.bar_mc.stopDrag();
			this._playerSlider.bar_mc.onEnterFrame = this.delegate(this, this._sliderEnterFrame);
		});
		
		vSlider.beginGradientFill("linear",  
							[_sliderColor1, _sliderColor2],  
							[100,100],  
							[50,150],  
							{matrixType:"box", x:0, y:0, w:SLIDER_WIDTH, h:SLIDER_HEIGHT, r:Math.PI/2}); 
		vSlider.moveTo(0, 4);
		vSlider.lineTo(0, SLIDER_HEIGHT - 4);
		vSlider.curveTo(0, SLIDER_HEIGHT, 4, SLIDER_HEIGHT);
		vSlider.lineTo(SLIDER_WIDTH - 4, SLIDER_HEIGHT);
		vSlider.curveTo(SLIDER_WIDTH, SLIDER_HEIGHT, SLIDER_WIDTH, SLIDER_HEIGHT - 4);
		vSlider.lineTo(SLIDER_WIDTH, 4);
		vSlider.curveTo(SLIDER_WIDTH, 0, SLIDER_WIDTH - 4, 0);
		vSlider.lineTo(4, 0);
		vSlider.curveTo(0, 0, 0, 4);
		vSlider.endFill();
		vSlider._y = PLAYER_HEIGHT/2 - SLIDER_HEIGHT / 2;
		
		vSlider.onEnterFrame = this.delegate(this, this._sliderEnterFrame);
	}
	/** 
	 * Le enterFrame du slider 
	 */ 
	private function _sliderEnterFrame()
	{
		var max:Number;
		var time:Number;
		var position:Number; 
		
		// Le maximum
		if (this._loadingBar._visible) {
			max = this._loadingBar._width - SLIDER_WIDTH;
		} else {
			max = this._playerSlider.width - SLIDER_WIDTH;
		}
		if (max < 0) {
			max = 0;
		} else if (max > this._playerSlider.width) {
			max = this._playerSlider.width;
		}
		
		// Le temps
		time = this.controller.getPosition();
		
		// La position
		position = Math.round(time/this.controller.getDuration() * max)
		if (isNaN(position)) {
			position = 0;
		}
		this._playerSlider.bar_mc._x = position;
		if (this._stopped) {
			this._playerSlider.bar_mc._x = 0;
		}
		
		// Buffer message
		var buffer:Number = Math.min(Math.round(this.controller.getBufferLength()/this.controller.getBufferTime() * 100), 100);
		if (!this.controller.streamStarted && buffer >= this._lastBuffer && this.controller.getDuration() != undefined && buffer != 100) {
			var message:String = this._bufferMessage;
			message = message.split("_n_").join(String(buffer)+"%");
			this._buffering.message_txt.text = message;
			
			this._buffering._visible = true;
		} else {
			this._buffering._visible = false;
		}
		this._lastBuffer = buffer;
		
		if (this.controller.isPlaying) {
			this.video.title_txt._visible = false;
			this.video.image_mc._visible = false;
		}
	}
	/**
	 * Déplacement du slider
	 */
	private function _sliderMoving()
	{
		var position:Number = this._playerSlider.bar_mc._x / (this._playerSlider.width - SLIDER_WIDTH) * this.controller.getDuration(); 
		this.controller.setPosition(position);
	}
	/**
	 * Chargement
	 */
	private function _loading()
	{
		var objLoading:Object = this.controller.getLoading();
		this._loadingBar._xscale = (objLoading.percent >= 1)?objLoading.percent:0; 
		if (objLoading.percent == 100) { 
			if (this._showLoading != "always") {
				this._loadingBar._visible = false;
			}
			delete this._loadingBar.onEnterFrame; 
		}
	}
	/**
	 * Exécuté lorsque le mode plein écran est activé	 */
	private function _onStageFullscreen()
	{
		this._isFullscreen = true;
		this._stageNormalParams = new Object();
		
		this._stageNormalParams.player_x = this._player._x;
		this._player._x = 0;
		
		this._stageNormalParams.player_y = this._player._y;
		this._player._y = Stage.height - PLAYER_HEIGHT;
		
		this._stageNormalParams.root_width = _root.width;
		_root.width = Stage.width;
		
		this._stageNormalParams.root_height = _root.height;
		_root.height = Stage.height;
		
		this._stageNormalParams.swfWidth = this._swfWidth;
		this._swfWidth = Stage.width;
		
		this._stageNormalParams.swfHeight = this._swfHeight;
		this._swfHeight = Stage.height;
		
		this._stageNormalParams.videoMargin = this._videoMargin;
		this._videoMargin = 0;
		
		this._initFlash();
		this._initVideo();
		
		this._initTitle();
		this._initSubtitles();
		
		this._initPlayerBackground();
		this._initPlayerSlider(this._marginSlider);
		
		resizeVideo();
	}
	/**
	 * Exécuté lorsque le mode plein écran est désactivé	 */
	private function _onStageNormal()
	{
		this._isFullscreen = false;
		
		this._player._x = this._stageNormalParams.player_x;
		this._player._y = this._stageNormalParams.player_y;
		_root.width = this._stageNormalParams.root_width;
		_root.height = this._stageNormalParams.root_height;
		this._swfWidth = this._stageNormalParams.swfWidth;
		this._swfHeight = this._stageNormalParams.swfHeight;
		this._videoMargin = this._stageNormalParams.videoMargin;
		
		this._initFlash();
		this._initTitle();
		this._initSubtitles();
		this._initVideo();
		this._initPlayerBackground();
		this._initPlayerSlider(this._marginSlider);
		
		resizeVideo();
	}
	/*===================== FIN = METHODES PRIVEES = FIN =====================*/
	/*========================================================================*/
	
	/*========================== METHODES PUBLIQUES ==========================*/
	/*========================================================================*/
	/**
	 * Redimensionne la video
	 * 
	 * @param pWidth (optional) La largeur de la vidéo
	 * @param pHeight (optional) La hauteur de la vidéo
	 */
	public function resizeVideo(pWidth:Number, pHeight:Number)
	{
		// On redimensinone la vidéo à la taille du flash en gardant les proportions
		var originWidth:Number = (pWidth !== undefined)?pWidth:this.video.video.width;
		var originHeight:Number = (pHeight !== undefined)?pHeight:this.video.video.height;
		var newWidth:Number = this._swfWidth - this._videoMargin*2;
		var newHeight:Number = newWidth * originHeight / originWidth;
		var swfWidth:Number = this._swfWidth - this._videoMargin*2;
		var swfHeight:Number = this._swfHeight - this._videoMargin*2;
		
		if (this._showPlayer === "always") {
			swfHeight -= this.PLAYER_HEIGHT;
		}
		if (newHeight > swfHeight) {
			newHeight = swfHeight;
			newWidth = newHeight * originWidth / originHeight;
		}
		
		if (this._forceSize) {
			newWidth = swfWidth;
			newHeight = swfHeight;
		}
		
		this.video.video._width = newWidth;
		this.video.video._height = newHeight;
		this.video.video._x = (swfWidth - newWidth) / 2;
		this.video.video._y = (swfHeight - newHeight) / 2;
	}
	/**
	 * Action sur le bouton Play
	 */
	public function playRelease()
	{
		super.playRelease();
		
		this._stopped = false;
		
		this.video.freeze_mc._visible = false;
		this.video.title_txt._visible = false;
		this.video.image_mc._visible = false;
		
		this._enableButton(this._playerPlay, false, true);
		this._enableButton(this._playerPause, true);
		this._enableButton(this._playerStop, true);
		
		if (this._showPlayer === "autohide") {
			this._player._visible = false;
			Mouse.removeListener(this._mouse);
			Mouse.addListener(this._mouse);
		}
		
		this.controller.setVolume(this._volume);
	}
	/**
	 * Action sur le bouton Pause
	 */
	public function pauseRelease()
	{
		super.pauseRelease();
		
		this._enableButton(this._playerPause, false, true);
		this._enableButton(this._playerPlay, true);
	}
	/**
	 * Action sur le bouton Stop
	 */
	public function stopRelease()
	{
		Mouse.removeListener(this._mouse);
		clearInterval(this._playerItv);
		
		super.stopRelease();
		
		this._stopped = true;
		
		this.video.freeze_mc._visible = true;
		this.video.title_txt._visible = true;
		this.video.image_mc._visible = true;
		
		this._enableButton(this._playerStop, false);
		this._enableButton(this._playerPause, false, true);
		this._enableButton(this._playerPlay, true);
		
		if (this._showPlayer !== "never") {
			this._player._visible = true;
		}
		
	}
	/**
	 * Action sur le bouton Fullscreen	 */
	public function fullscreenRelease()
	{
		Stage["displayState"] = (!this._isFullscreen)?"fullscreen":"normal";
	}
	/**
	 * Action sur le bouton ShowSubtitles	 */
	public function showSubtitlesRelease()
	{
		this._subtitles.hide = (this._subtitles.hide)?false:true;
		this._subtitles._visible = this._subtitles.hide;
	}
	/**
	 * Action sur le bouton HideSubtitles	 */
	public function hideSubtitlesRelease()
	{
		
	}
	/**
	 * Affichage du chargement
	 */
	public function startLoading():Void
	{
		super.startLoading();
		this._loadingBar.onEnterFrame = this.delegate(this, this._loading);
		if (this._showLoading != "never") {
			this._loadingBar._visible = true;
		}
	}
	/**
	 * Load jpg or swf on top of the video
	 * 
	 * @param pUrl The url
	 */
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
	/*==================== FIN = METHODES PUBLIQUES = FIN ====================*/
	/*========================================================================*/
	
	/*========================= CONTROLES JAVASCRIPT =========================*/
	/*========================================================================*/
	public function set jsPlay(n:String)
	{
		if (!this.controller.isPlaying) {
			this.playRelease();
		}
	}
	public function set jsPause(n:String)
	{
		if (this.controller.isPlaying) {
			this.pauseRelease();
		}
	}
	public function set jsStop(n:String)
	{
		this.stopRelease();
	}
	public function set jsVolume(n:String)
	{
		this.controller.setVolume(Number(n));
		this._volume = Number(n);
		this._updateVolume();
	}
	public function set jsUrl(n:String)
	{
		this.controller.setUrl(n);
	}
	public function set jsStartImage(n:String)
	{
		this._startImage = n;
		this._initStartImage();
	}
	public function set jsSetPosition(n:String)
	{
		this.controller.setPosition(Number(n));
	}
	/**
	 * Load jpg or swf on top of the video
	 * 
	 * @param pUrl The url
	 */
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
	/*=================== FIN = CONTROLES JAVASCRIPT = FIN ===================*/
	/*========================================================================*/
}