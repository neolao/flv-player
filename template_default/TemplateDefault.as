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
 * Template default
 * 
 * @author		neolao <neo@neolao.com> 
 * @version 	1.2.0 (03/08/2007)
 * @license		http://creativecommons.org/licenses/by-sa/3.0/deed.fr
 */ 
class TemplateDefault extends ATemplate
{
	// ----------------------------- CONSTANTES --------------------------------
	public var PLAYER_HEIGHT:Number = 20;
	public var PLAYER_TIMEOUT:Number = 1500;
	public var BUTTON_WIDTH:Number = 26;
	public var SLIDER_WIDTH:Number = 20;
	public var SLIDER_HEIGHT:Number = 10;
	public var VOLUME_WIDTH:Number = 30;
	public var VOLUME_HEIGHT:Number = 6;
	
	// ------------------------------ VARIABLES --------------------------------
	/**
	 * la marge de la vidéo	 */
	private var _videoMargin:Number = 5;
	/**
	 * la couleur des sous-titres	 */
	private var _subtitleColor:Number = 0xffffff;
	/**
	 * la couleur du fond des sous-titres	 */
	private var _subtitleBackgroundColor:Number;
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
	 * Le bouton Time	 */
	private var _showTime:Boolean = false;
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
	 * La dernière valeur du buffer
	 */
	private var _lastBuffer:Number = 0;
	/**
	 * L'instance du controleur de la vidéo
	 */
	public var controller:PlayerDefault;
	
	/*============================= CONSTRUCTEUR =============================*/
	/*========================================================================*/
	/**
	 * Initialisation
	 */
	public function TemplateDefault()
	{
		super();
		
		this._initBackground();
		this._initFont();
		this._initSubtitles();
		this._initTitle();
		
		var vMarginSlider:Number = BUTTON_WIDTH;
		var vSeparators:Array = [BUTTON_WIDTH]; // Premier séparateur pour le bouton Play
		if (this._showStop) {
			vMarginSlider += BUTTON_WIDTH;
			vSeparators.push(BUTTON_WIDTH);
		}
		if (this._showVolume) {
			vMarginSlider += VOLUME_WIDTH;
			vSeparators.push(VOLUME_WIDTH);
		}
		this._initPlayerTime();
		if (this._showTime) {
			vMarginSlider += this._playerTime._width + 10;
			vSeparators.push(this._playerTime._width + 10);
		}
		this._initPlayerSlider(vMarginSlider);
		this._createSeparators(vSeparators);
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
				_root.player = new TemplateDefault();
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
				_root.player = new TemplateDefault();
				var player:PlayerBasic = new PlayerDefault(_root.player);
			};
			vConfigLoad.load(_root.configxml);
		} else {
			// Aucun fichier de configuration
			// Initialisation du lecteur
			_root.player = new TemplateDefault();
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
		
		// touche "P"
		this._addShortcut(80, this.delegate(this, function()
		{
			if (this.controller.isPlaying) {
				this.pauseRelease();
			} else {
				this.playRelease();
			}
		}));
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
	}
	/**
	 * Initialisation des variables 
	 */
	private function _initVars()
	{
		super._initVars();
		
		if (_root.title != undefined) {
			this._title = _root.title;
		}
		if (_root.startimage != undefined) {
			this._startImage = _root.startimage;
		}
		if (_root.skin != undefined) {
			this._backgroundSkin = _root.skin;
		}
		if (_root.bgcolor != undefined) {
			this._backgroundColor = parseInt(_root.bgcolor, 16);
		}
		if (_root.bgcolor1 != undefined) {
			this._backgroundColor1 = parseInt(_root.bgcolor1, 16);
		}
		if (_root.bgcolor2 != undefined) {
			this._backgroundColor2 = parseInt(_root.bgcolor2, 16);
		}
		if (_root.showstop != undefined) {
			this._showStop = _root.showstop;
		}
		if (_root.showvolume != undefined) {
			this._showVolume = _root.showvolume;
		}
		if (_root.showtime != undefined) {
			this._showTime = _root.showtime;
		}
		if (_root.margin != undefined) {
			this._videoMargin = Number(_root.margin);
		}
		if (_root.srtcolor != undefined) {
			this._subtitleColor = parseInt(_root.srtcolor, 16);
		}
		if (_root.srtbgcolor != undefined) {
			this._subtitleBackgroundColor = parseInt(_root.srtbgcolor, 16);
		}
		if (_root.playercolor != undefined) {
			this._playerColor = parseInt(_root.playercolor, 16);
		}
		if (_root.buttoncolor != undefined) {
			this._buttonColor = parseInt(_root.buttoncolor, 16);
		}
		if (_root.buttonovercolor != undefined) {
			this._buttonOverColor = parseInt(_root.buttonovercolor, 16);
		}
		if (_root.slidercolor1 != undefined) {
			this._sliderColor1 = parseInt(_root.slidercolor1, 16);
		}
		if (_root.slidercolor2 != undefined) {
			this._sliderColor2 = parseInt(_root.slidercolor2, 16);
		}
		if (_root.sliderovercolor != undefined) {
			this._sliderOverColor = parseInt(_root.sliderovercolor, 16);
		}
		if (_root.loadingcolor != undefined) {
			this._loadingColor = parseInt(_root.loadingcolor, 16);
		}
	}
	/**
	 * Initialisation du buffering
	 */
	private function _initBuffering(){		
		this._buffering = this.video.createEmptyMovieClip("buffering_mc", this.video.getNextHighestDepth());
		
		this._buffering.createTextField("message_txt", this._buffering.getNextHighestDepth(), 0, 0, 0, 0);
		this._buffering.message_txt.selectable = false;
		this._buffering.message_txt.textColor = 0xffffff;
		this._buffering.message_txt.background = true;
		this._buffering.message_txt.backgroundColor = 0;
		this._buffering.message_txt.text = "buffering ...";
		this._buffering.message_txt.autoSize = "left";
		this._buffering._visible = false;
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
		// Dimension du conteneur vidéo
		this.video.clear();
		this.video.beginFill(0);
		this.video.lineTo(0, this._swfHeight - this._videoMargin*2);
		this.video.lineTo(this._swfWidth - this._videoMargin*2, this._swfHeight - this._videoMargin*2);
		this.video.lineTo(this._swfWidth - this._videoMargin*2, 0);
		this.video.endFill();
		this.video._xscale = 100;
		this.video._yscale = 100;
		this.video._x = this._videoMargin;
		this.video._y = this._videoMargin;
		
		// Initialisation du buffer
		this._initBuffering();
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
		this._subtitleFormat.size = 11;
		this._subtitleFormat.bold = true;
		this._subtitleFormat.align = "center";
		this._subtitleFormat.font = vFont;
		
		this._titleFormat = new TextFormat();
		this._titleFormat.size = 20;
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
		this._subtitles = this.video.createEmptyMovieClip("subtitles_mc", this.video.getNextHighestDepth());
		
		this._subtitles.createTextField("message_txt", this._subtitles.getNextHighestDepth(), 0, 0, this._swfWidth, 0);
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
			this._subtitles._visible = !(this._subtitles.message_txt.text == "");
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
		
		if(this._startImage != undefined){
			var vImage:MovieClip = this.video.createEmptyMovieClip("image_mc", this.video.getNextHighestDepth());
			this._initStartImage();
		}
		
		this.video.createTextField("title_txt", this.video.getNextHighestDepth(), 0, 0, this.video._width, 0);
		this.video.title_txt.multiline = true;
		this.video.title_txt.wordWrap = true;
		this.video.title_txt.selectable = false;
		this.video.title_txt.textColor = 0xffffff;
		this.video.title_txt.text = _title;
		this.video.title_txt.autoSize = "center";
		this.video.title_txt.setTextFormat(this._titleFormat);
		this.video.title_txt._y = this.video._height / 2 - this.video.title_txt._height / 2;
		
	}
	/**
	 * Initialisation de l'image de départ
	 */
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
					
					
					if (this.video.image_mc._yscale > this.video.image_mc._xscale) {
						this.video.image_mc._yscale = this.video.image_mc._xscale;
					} else {
						this.video.image_mc._xscale = this.video.image_mc._yscale;
					}
					this.video.image_mc._x = Math.floor((this._swfWidth - this._videoMargin*2 - this.video.image_mc._width) / 2);
					this.video.image_mc._y = Math.floor((this._swfHeight - this._videoMargin*2 - this.video.image_mc._height) / 2);
					
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
		super._initPlayer();
		
		this._player._y = this._swfHeight - PLAYER_HEIGHT - this._videoMargin;
		this._player._x = this._videoMargin;
		
		this._initPlayerBackground();
		this._initPlayerPlay();
		this._initPlayerPause();
		this._initPlayerStop();
		this._initPlayerVolume();
		
		this._mouse = new Object();
		this._mouse.onMouseMove = this.delegate(this, function(){
			this._player._visible = true;
			clearInterval(this._playerItv);
			this._playerItv = setInterval(this, "_playerInterval", 1500); // this.PLAYER_TIMEOUT ne marche pas, bizarre
		});
	}
	/** 
	 * Affichage du lecteur lorsque la souris est sur la video
	 */ 
	private function _playerInterval()
	{
		this._player._visible = false;
		clearInterval(this._playerItv);
	}
	/**
	 * Initialisation du fond du lecteur
	 */
	private function _initPlayerBackground()
	{
		this._playerBackground = this._player.createEmptyMovieClip("background_mc", this._player.getNextHighestDepth()); 
		
		this._playerBackground.beginFill(this._playerColor);
		this._playerBackground.lineTo(0, PLAYER_HEIGHT);
		this._playerBackground.lineTo(this.video._width, PLAYER_HEIGHT);
		this._playerBackground.lineTo(this.video._width, 0);
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
		vArea.moveTo(2, 2);
		vArea.lineTo(2, PLAYER_HEIGHT - 4);
		vArea.lineTo(pWidth - 4, PLAYER_HEIGHT - 4);
		vArea.lineTo(pWidth - 4, 2);
		vArea.endFill();
		
		vArea.parent = this;
		vArea.color = new Color(vIcon);
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
	 * Initialisation du bouton Time
	 */
	private function _initPlayerTime()
	{
		if (this._showTime) {
			this._playerTime = this._player.createEmptyMovieClip("time_btn", this._player.getNextHighestDepth());
			
			// position
			this._playerTime._x = BUTTON_WIDTH;
			if (this._showStop) {
				this._playerTime._x += BUTTON_WIDTH;
			}
			if (this._showVolume) {
				this._playerTime._x += VOLUME_WIDTH;
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
			this._playerTime.type = "position";
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
		this._playerSlider = this._player.createEmptyMovieClip("slider_mc", this._player.getNextHighestDepth());
		
		// calcul de la taille
		var vMargin:Number = pMargin;
		vMargin += 10;
		
		this._playerSlider._x = vMargin;
		this._playerSlider.width = this._swfWidth - vMargin - 10 - this._videoMargin*2;
		
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
		
		// Buffer message
		var buffer:Number = Math.min(Math.round(this.controller.getBufferLength()/this.controller.getBufferTime() * 100), 100);
		if (!this.controller.streamStarted && buffer >= this._lastBuffer && this.controller.getDuration() != undefined && buffer != 100) {
			this._buffering.message_txt.text = "buffering "+buffer+"%";
			this._buffering._visible = true;
		} else {
			this._buffering._visible = false;
		}
		this._lastBuffer = buffer;
		
		/*//debug
		this._buffering.message_txt.text = "buffer: "+buffer+"%, position: "+this.controller.getPosition()+", duration: "+this.controller.getDuration();
		this._buffering._visible = true;
		//*/
		
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
			this._loadingBar._visible = false; 
			delete this._loadingBar.onEnterFrame; 
		}
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
		
		if (newHeight > swfHeight) {
			newHeight = swfHeight;
			newWidth = newHeight * originWidth / originHeight;
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
		
		this.video.title_txt._visible = false;
		this.video.image_mc._visible = false;
		
		this._enableButton(this._playerPlay, false, true);
		this._enableButton(this._playerPause, true);
		this._enableButton(this._playerStop, true);
		
		// Hide the control bar
		this._player._visible = false;
		
		// Add mouse listener
		Mouse.removeListener(this._mouse);
		Mouse.addListener(this._mouse);
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
		super.stopRelease();
		
		this._enableButton(this._playerStop, false);
		this._enableButton(this._playerPause, false, true);
		this._enableButton(this._playerPlay, true);
		
		// Remove mouse listener
		Mouse.removeListener(this._mouse);
		clearInterval(this._playerItv);
		
		// Show the control bar
		this._player._visible = true;
	}
	/**
	 * Affichage du chargement
	 */
	public function startLoading():Void
	{
		super.startLoading();
		this._loadingBar.onEnterFrame = this.delegate(this, this._loading);
		this._loadingBar._visible = true;
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
	/*=================== FIN = CONTROLES JAVASCRIPT = FIN ===================*/
	/*========================================================================*/
}