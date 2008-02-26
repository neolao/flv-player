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
 * Template multi
 * 
 * @author		neolao <neo@neolao.com> 
 * @version 	1.5.0 (16/02/2008) 
 * @license		http://creativecommons.org/licenses/by-sa/3.0/deed.fr
 */ 
class TemplateMulti extends TemplateMultiBase
{
	// ----------------------------- CONSTANTES --------------------------------
	
	// ------------------------------ VARIABLES --------------------------------
	
	
	/*============================= CONSTRUCTEUR =============================*/
	/*========================================================================*/
	/**
	 * Initialisation
	 */
	public function TemplateMulti()
	{
		super();
		
		// Javascript object listener
		if (_root.listener) {
			_listener = _root.listener + ".";
		}
		
		this._initBackground();
		this._initFont();
		this._initSubtitles();
		this._initTitle();
		var vMarginSlider:Number = 0;
		
		var vSeparators:Array = [];
		// bouton Open
		if (this._showOpen) {
			vMarginSlider += BUTTON_WIDTH;
			vSeparators.push(BUTTON_WIDTH);
		}
		// bouton Previous
		if (this._showPrevious) {
			vMarginSlider += BUTTON_WIDTH;
			vSeparators.push(BUTTON_WIDTH);
		}
		// bouton Play
		vMarginSlider += BUTTON_WIDTH;
		vSeparators.push(BUTTON_WIDTH);
		// bouton Stop
		if (this._showStop) {
			vMarginSlider += BUTTON_WIDTH;
			vSeparators.push(BUTTON_WIDTH);
		}
		// bouton Next
		if (this._showNext) {
			vMarginSlider += BUTTON_WIDTH;
			vSeparators.push(BUTTON_WIDTH);
		}
		// bouton Volume
		if (this._showVolume) {
			vMarginSlider += VOLUME_WIDTH;
			vSeparators.push(VOLUME_WIDTH);
		}
		// CloseCaption button
		if (this._showSwitchSubtitles) {
			vMarginSlider += BUTTON_WIDTH;
			vSeparators.push(BUTTON_WIDTH);
		}
		// Fullscreen button
		if (this._showFullscreen) {
			vMarginSlider += BUTTON_WIDTH;
			vSeparators.push(BUTTON_WIDTH);
		}
		this._initPlayerTime();
		if (this._showTime > 0) {
			vMarginSlider += this._playerTime._width + 10;
			vSeparators.push(this._playerTime._width + 10);
		}
		this._marginSlider = vMarginSlider;
		this._initPlayerSlider(vMarginSlider);
		this._createSeparators(vSeparators);
		
		// Initialize Fullscreen events
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
		
		// Initialize the top container
		_root.createEmptyMovieClip("top", _root.getNextHighestDepth());
		
		// Load top containers
		for (var i:Number = 0; i < this._topContainers.length; i++) {
			this.loadUrl(this._topContainers[i].depth, this._topContainers[i].url, this._topContainers[i].verticalAlign, this._topContainers[i].horizontalAlign);
		}
		
		// Auto resize
		var stageListener:Object = new Object();
		stageListener.onResize = this.delegate(this, function () {
			if (!this._isFullscreen) {
				this._onStageNormal();
			}
		});
		Stage.addListener(stageListener);
		
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
				_root.player = new TemplateMulti();
				var player:PlayerBasic = new PlayerMulti(_root.player);
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
				_root.player = new TemplateMulti();
				var player:PlayerBasic = new PlayerMulti(_root.player);
			};
			vConfigLoad.load(_root.configxml);
		} else {
			// Aucun fichier de configuration
			// Initialisation du lecteur
			_root.player = new TemplateMulti();
			var player:PlayerBasic = new PlayerMulti(_root.player);
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
			// touche flèche haut
			this._addShortcut(38, this.delegate(this, function()
			{
				if (this.controller.hasPrevious) {
					this.previousRelease();
				}
			}));
			// touche flèche bas
			this._addShortcut(40, this.delegate(this, function()
			{
				if (this.controller.hasNext) {
					this.nextRelease(true);
				}
			}));
			
			// touche "-"
			this._addShortcut(109, vDecreaseVolume);
			this._addShortcut(189, vDecreaseVolume);
			// touche "+"
			this._addShortcut(107, vIncreaseVolume);
			this._addShortcut(187, vIncreaseVolume);
			// touche "C"
			this._addShortcut(67, this.delegate(this, function()
			{
				this.showSubtitlesRelease();
			}));
		
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
	 * Initialize the background
	 */
	private function _initBackground(){
		// The skin
		if(this._backgroundSkin != undefined){
			// An image is defined
			this._background.loadMovie(this._backgroundSkin);
		}else{
			var vWidth:Number = this._swfWidth;
			var vHeight:Number = this._swfHeight;
			
			this._background.clear();
			
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
		/*super._initVideo();
		
		this.video._width -= this._videoMargin*2;
		this.video._height -= this._videoMargin*2;
		this.video._x += this._videoMargin;
		this.video._y += this._videoMargin;*/
		// Je n'utilise pas la méthode parente parce que je veux personnaliser la couleur de fond
		// Fond de la vidéo
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
		vButton._xscale = vButton._xscale * (100 / this.video._xscale);
		vButton._yscale = vButton._yscale * (100 / this.video._yscale);
		vButton._height -= PLAYER_HEIGHT;
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
		
		// Dimension du conteneur vidéo
		this.video._xscale = 100;
		this.video._yscale = 100;
		this.video._x = this._videoMargin;
		this.video._y = this._videoMargin;
		
		this._initBuffering();
	}
	/**
	 * The user click on the video
	 */
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
	 * The user double click on the video
	 */
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
	 * Initialisation de la police
	 */
	private function _initFont()
	{
		var vFontList:Array = TextField.getFontList();
		var vFontListString:String = "|" + vFontList.join("|") + "|";
		var vFont:String = "_sans";
		
		// Recherche de la police Verdana si elle existe
		if(vFontListString.indexOf("|Verdana|") != -1){
			vFont = "Verdana";
		}
		
		this._font = vFont;
		
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
		
		this._playlistFormat = new TextFormat();
		this._playlistFormat.size = 11;
		this._playlistFormat.align = "left";
		this._playlistFormat.font = vFont;
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
		var vTitle:String = "";
		var vImage:MovieClip;
		if (this._title[this._currentIndex] != undefined) {
			vTitle = this._title[this._currentIndex];
		}
		
		// New line fix
		vTitle = vTitle.split("\\n").join("\n");
		vTitle = vTitle.split("/n").join("\n"); // for IE
		
		// Transparent background
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
		
		// The start image
		this.video.image_mc.removeMovieClip();
		if(this._startImage[this._currentIndex] != undefined){
			vImage = this.video.createEmptyMovieClip("image_mc", this.video.getNextHighestDepth());
			vImage.loadMovie(this._startImage[this._currentIndex]);
			
			// Resize the image when its loaded
			this.video.onEnterFrame = this.delegate(this, function()
			{
				if (this.video.image_mc._width > 0) {
					this.video.image_mc._width = this.video.freeze_mc._width;
					this.video.image_mc._height = this.video.freeze_mc._height;
					delete this.video.onEnterFrame;
				}
			});
		}
		
		// Title
		this.video.title_txt.removeMovieClip();
		if (this._showTitleAndStartimage || this._startImage[this._currentIndex] == undefined) {
			this.video.createEmptyMovieClip("title_txt", this.video.getNextHighestDepth());
			this.video.title_txt.createTextField("field", this.video.getNextHighestDepth(), 0, 0, this._swfWidth - this._videoMargin*2, 0);
			this.video.title_txt.field.multiline = true;
			this.video.title_txt.field.wordWrap = true;
			this.video.title_txt.field.selectable = false;
			this.video.title_txt.field.textColor = this._titleColor;
			this.video.title_txt.field.text = vTitle;
			this.video.title_txt.field.autoSize = "center";
			this.video.title_txt.field.setTextFormat(this._titleFormat);
			this.video.title_txt.field._width = this._swfWidth;
			this.video.title_txt._x = -this._videoMargin;
			this.video.title_txt._y = (this._swfHeight - this._videoMargin*2) / 2 - this.video.title_txt._height / 2;
		}
		
		// Icon play
		if (this._showIconPlay) {
			this.video.iconplay_mc.removeMovieClip();
			if (!this.video.iconplay_mc) {
				var vIconPlay:MovieClip = this.video.createEmptyMovieClip("iconplay_mc", this.video.getNextHighestDepth());
				var iconWidth:Number = 50;
				var iconHeight:Number = 50;
				var iconCorner:Number = 10;
				var iconPadding:Number = 14;
				
				vIconPlay.moveTo(iconCorner, 0);
				vIconPlay.beginFill(this._iconPlayBackgroundColor, this._iconPlayBackgroundAlpha);
				vIconPlay.lineTo(	iconWidth - iconCorner, 	0);
				vIconPlay.curveTo(	iconWidth, 					0, 							iconWidth, 	iconCorner);
				vIconPlay.lineTo(	iconWidth, 					iconHeight - iconCorner);
				vIconPlay.curveTo(	iconWidth, 					iconHeight, 				iconWidth - iconCorner, 	iconHeight);
				vIconPlay.lineTo(	iconCorner, 				iconHeight);
				vIconPlay.curveTo(	0, 							iconHeight, 				0, 							iconHeight - iconCorner);
				vIconPlay.lineTo(	0, 							iconCorner);
				vIconPlay.curveTo(	0, 							0, 							iconCorner, 				0);
				vIconPlay.endFill();
				
				vIconPlay.moveTo(iconPadding, iconPadding);
				vIconPlay.beginFill(this._iconPlayColor);
				vIconPlay.lineTo(iconPadding, iconHeight - iconPadding);
				vIconPlay.lineTo(iconWidth - iconPadding, iconHeight / 2);
				vIconPlay.endFill();
			}
			this.video.iconplay_mc._x = (this._swfWidth - this._videoMargin*2 - this.video.iconplay_mc._width) / 2;
			this.video.iconplay_mc._y = (this._swfHeight - this._videoMargin*2 - this.video.iconplay_mc._height) / 2;
		}
	}
	/**
	 * Initialize the player
	 */
	private function _initPlayer()
	{
		super._initPlayer();
		
		if (this._showMouse == "never") {
			Mouse.hide();
		}
		
		if (this._showPlayer !== "never") {
			this._player._y = this._swfHeight - PLAYER_HEIGHT - this._videoMargin;
			this._player._x = this._videoMargin;
			
			this._initPlayerBackground();
			this._initPlayerPlaylist();
			this._initPlayerPrevious();
			this._initPlayerPlay();
			this._initPlayerPause();
			this._initPlayerStop();
			this._initPlayerNext();
			this._initPlayerVolume();
			this._initPlayerSwitchSubtitles();
			this._initPlayerFullscreen();
			
			// Open the playlist the first time
			if (this._showOpen === 2) {
				this._playlist._visible = true;
			}
			
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
	 * Initialize the button "open playlist"
	 */
	private function _initPlayerPlaylist()
	{
		if (this._showOpen && !this._playerPlaylist) {
			this._playerPlaylist = this._player.createEmptyMovieClip("playlist_btn", this._player.getNextHighestDepth()); 
			this._initButton(this._playerPlaylist);
			
			//action
			this._playerPlaylist.area_mc.onRelease = function()
			{
				this._parent.list_mc._visible = !this._parent.list_mc._visible;
			}; 
			
			// icone
			this._playerPlaylist.icon_mc.beginFill(this._buttonColor);
			this._playerPlaylist.icon_mc.moveTo(4, 0);
			this._playerPlaylist.icon_mc.lineTo(0, 5);
			this._playerPlaylist.icon_mc.lineTo(8, 5);
			this._playerPlaylist.icon_mc.endFill();
			this._playerPlaylist.icon_mc.beginFill(this._buttonColor);
			this._playerPlaylist.icon_mc.moveTo(0, 6);
			this._playerPlaylist.icon_mc.lineTo(8, 6);
			this._playerPlaylist.icon_mc.lineTo(8, 8);
			this._playerPlaylist.icon_mc.lineTo(0, 8);
			this._playerPlaylist.icon_mc.endFill();
			this._playerPlaylist.icon_mc._y = PLAYER_HEIGHT/2 - this._playerPlaylist.icon_mc._height/2;
			this._playerPlaylist.icon_mc._x = BUTTON_WIDTH/2 - this._playerPlaylist.icon_mc._width/2;
		}
		
		if (!this._playlist) {
			this._playlist = this._playerPlaylist.createEmptyMovieClip("list_mc", this._playerPlaylist.getNextHighestDepth()); 
			this._playlist._y -= 1;
			this._playlist._visible = false;
			
			// create the background panel
			this._playlist.createEmptyMovieClip("bg_mc", this._playerPlaylist.list_mc.getNextHighestDepth());
		}
		
		// fill the background panel
		this._playlist.bg_mc.clear();
		this._playlist.bg_mc.beginFill(this._playerColor);
		this._playlist.bg_mc.lineTo(0, -100);
		this._playlist.bg_mc.lineTo(this._swfWidth - this._videoMargin*2, -100);
		this._playlist.bg_mc.lineTo(this._swfWidth - this._videoMargin*2, 0);
		this._playlist.bg_mc.endFill();
		
		// Champ de test pour vérifier si un texte scrolle ou pas (je sais, c'est pas top)
		if (!this._playlist.list_txt_tmp) {
			this._playlist.createTextField("list_txt_tmp", -1, 0, -100, this._swfWidth - this._videoMargin*2 - this._playlistScrollbarSize, 100);
		}
		this._playlist.list_txt_tmp._width = this._swfWidth - this._videoMargin*2 - this._playlistScrollbarSize;
		
		// champ de texte
		var totalFlv:Number = _root.flv.split("|").length;
		var version:String = System.capabilities.version;
		if (version.indexOf("MAC") != -1) {
			totalFlv += 2;
		}
		if (!this._playlist.list_txt) {
			this._playlist.createTextField("list_txt", this._playlist.getNextHighestDepth(), 0, -100, this._swfWidth - this._videoMargin*2 - this._playlistScrollbarSize, 100);
			this._playlist.list_txt.multiline = true;
			this._playlist.list_txt.wordWrap = false;
			this._playlist.list_txt.selectable = true;
			this._playlist.list_txt.html = true;
			this._playlist.list_txt.textColor = 0xffffff;
			this._playlist.list_txt.setNewTextFormat(this._playlistFormat);
			for (var i:Number=0; i<totalFlv; i++) {
				this._playlist.list_txt.text += i + "\n";
			}
		}
		this._playlist.list_txt._width = this._swfWidth - this._videoMargin*2 - this._playlistScrollbarSize;
		
		// asfunction
		this._playlist.parent = this;
		this._playlist.play = function(pIndex:String)
		{
			this.parent.controller.setIndex(Number(pIndex));
			this.parent.stopRelease();
			if (this.parent._playOnLoad) {
				clearInterval(this.parent._videoDelayItv);
				this.parent._videoDelayItv = setInterval(this.parent, "playRelease", this.parent._videoDelay);
			}
			this.parent._playlist._visible = false;
		};
		
		// Scrollbar
		if (this._playlist.list_txt.maxscroll > 1) {
			if (!this._playlistScrollbar) {
				this._playlistScrollbar = this._playlist.createEmptyMovieClip("scrollbar_mc", this._playlist.getNextHighestDepth());
			}
			this._playlistScrollbar.clear();
			this._playlistScrollbar.beginFill(this._scrollbarColor);
			this._playlistScrollbar.lineTo(this._playlistScrollbarSize, 0);
			this._playlistScrollbar.lineTo(this._playlistScrollbarSize, 100);
			this._playlistScrollbar.lineTo(0, 100);
			this._playlistScrollbar.endFill();
			this._playlistScrollbar._x = this._swfWidth - this._videoMargin*2 - this._playlistScrollbarSize;
			this._playlistScrollbar._y = -100;
			this._playlistScrollbar._yscale = (totalFlv - this._playlist.list_txt.maxscroll + 1)/totalFlv * 100;
			this._playlistScrollbar.max = - this._playlistScrollbar._height;
			this._playlistScrollbar.step = (100 + this._playlistScrollbar.max) / (this._playlist.list_txt.maxscroll - 1);
			this._playlistScrollbar.color = new Color(this._playlistScrollbar);
			this._playlistScrollbar.colorOver = this._scrollbarOverColor;
			this._playlistScrollbar.onRollOver = function()
			{ 
				this.color.setRGB(this.colorOver); 
			}; 
			this._playlistScrollbar.onRollOut = function()
			{  
				var transform:Object = {ra: 100, rb: 0, ga: 100, gb: 0, ba: 100, bb: 0, aa: 100, ab: 0}; 
				this.color.setTransform(transform); 
			}; 
			this._playlistScrollbar.onPress = function()
			{
				this.onEnterFrameAuto = this.onEnterFrame;
				this.startDrag(false, this._x, -100, this._x, this.max);
				this.onEnterFrame = function()
				{
					this._parent.list_txt.scroll = Math.floor((100 + this._y+1) / this.step) + 1;
				}
			}
			this._playlistScrollbar.onRelease = this._playlistScrollbar.onReleaseOutside = function()
			{
				this.stopDrag();
				this.onEnterFrame = this.onEnterFrameAuto;
			}
			this._playlistScrollbar.onEnterFrame = function()
			{
				if (this._parent.list_txt.scroll == this._parent.list_txt.maxscroll) {
					this._y = this.max;
				} else {
					this._y = -100 + (this._parent.list_txt.scroll - 1) * this.step;
				}
			}
		}
		
		// Mise à jour de la playlist en permanence
		this._playlist.waitScroll = 0;
		this._playlist.intervalScroll = 0;
		this._playlist.scrollMemo = 0;
		this._playlist.onEnterFrame = this.delegate(this, this.updatePlaylist);
	}
	/**
	 * Initialisation du bouton Previous
	 */
	private function _initPlayerPrevious()
	{
		if (this._showPrevious) {
			this._playerPrevious = this._player.createEmptyMovieClip("previous_btn", this._player.getNextHighestDepth()); 
			this._initButton(this._playerPrevious);
			
			// position
			this._playerPrevious._x = 0;
			if (this._showOpen) {
				this._playerPrevious._x += BUTTON_WIDTH;
			}
				
			// action
			this._playerPrevious.area_mc.onRelease = this.delegate(this, this.previousRelease);
			
			// icone
			this._playerPrevious.icon_mc.beginFill(this._buttonColor);
			this._playerPrevious.icon_mc.lineTo(0, 8);
			this._playerPrevious.icon_mc.lineTo(2, 8);
			this._playerPrevious.icon_mc.lineTo(2, 0);
			this._playerPrevious.icon_mc.endFill();
			this._playerPrevious.icon_mc.moveTo(2, 4);
			this._playerPrevious.icon_mc.beginFill(this._buttonColor);
			this._playerPrevious.icon_mc.lineTo(8, 8);
			this._playerPrevious.icon_mc.lineTo(8, 0);
			this._playerPrevious.icon_mc.endFill();
			this._playerPrevious.icon_mc._y = PLAYER_HEIGHT/2 - _playerPrevious.icon_mc._height/2;
			this._playerPrevious.icon_mc._x = BUTTON_WIDTH/2 - _playerPrevious.icon_mc._width/2;
		}
	}
	/**
	 * Initialisation du bouton Play
	 */
	private function _initPlayerPlay()
	{
		this._playerPlay = this._player.createEmptyMovieClip("play_btn", this._player.getNextHighestDepth()); 
		this._initButton(this._playerPlay);
		
		// position
		this._playerPlay._x = 0;
		if (this._showOpen) {
			this._playerPlay._x += BUTTON_WIDTH;
		}
		if (this._showPrevious) {
			this._playerPlay._x += BUTTON_WIDTH;
		}
			
		// action
		this._playerPlay.area_mc.onRelease = this.delegate(this, this.playRelease);
		
		// icone
		this._playerPlay.icon_mc.beginFill(this._buttonColor);
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
		
		// position
		this._playerPause._x = 0;
		if (this._showOpen) {
			this._playerPause._x += BUTTON_WIDTH;
		}
		if (this._showPrevious) {
			this._playerPause._x += BUTTON_WIDTH;
		}
			
		// action
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
			
			// position
			this._playerStop._x = BUTTON_WIDTH;
			if (this._showOpen) {
				this._playerStop._x += BUTTON_WIDTH;
			}
			if (this._showPrevious) {
				this._playerStop._x += BUTTON_WIDTH;
			}
			
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
	 * Initialisation du bouton Next
	 */
	private function _initPlayerNext()
	{
		if (this._showNext) {
			this._playerNext = this._player.createEmptyMovieClip("next_btn", this._player.getNextHighestDepth()); 
			this._initButton(this._playerNext);
			
			// position
			this._playerNext._x = BUTTON_WIDTH;
			if (this._showOpen) {
				this._playerNext._x += BUTTON_WIDTH;
			}
			if (this._showPrevious) {
				this._playerNext._x += BUTTON_WIDTH;
			}
			if (this._showStop) {
				this._playerNext._x += BUTTON_WIDTH;
			}
				
			// action
			this._playerNext.area_mc.onRelease = this.delegate(this, this.nextRelease, true);
			
			// icone
			this._playerNext.icon_mc.beginFill(this._buttonColor);
			this._playerNext.icon_mc.lineTo(0, 8);
			this._playerNext.icon_mc.lineTo(6, 4);
			this._playerNext.icon_mc.endFill();
			this._playerNext.icon_mc.moveTo(6, 0);
			this._playerNext.icon_mc.beginFill(this._buttonColor);
			this._playerNext.icon_mc.lineTo(8, 0);
			this._playerNext.icon_mc.lineTo(8, 8);
			this._playerNext.icon_mc.lineTo(6, 8);
			this._playerNext.icon_mc.endFill();
			this._playerNext.icon_mc._y = PLAYER_HEIGHT/2 - _playerNext.icon_mc._height/2;
			this._playerNext.icon_mc._x = BUTTON_WIDTH/2 - _playerNext.icon_mc._width/2;
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
			if (this._showOpen) {
				this._playerVolume._x += BUTTON_WIDTH;
			}
			if (this._showPrevious) {
				this._playerVolume._x += BUTTON_WIDTH;
			}
			if (this._showStop) {
				this._playerVolume._x += BUTTON_WIDTH;
			}
			if (this._showNext) {
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
			if (this._showOpen) {
				this._playerShowSubtitles._x += BUTTON_WIDTH;
			}
			if (this._showPrevious) {
				this._playerShowSubtitles._x += BUTTON_WIDTH;
			}
			if (this._showStop) {
				this._playerShowSubtitles._x += BUTTON_WIDTH;
			}
			if (this._showNext) {
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
	 * Initialize the Fullscreen button
	 */
	private function _initPlayerFullscreen()
	{
		if (this._showFullscreen) {
			this._playerFullscreen = this._player.createEmptyMovieClip("fullscreen_btn", this._player.getNextHighestDepth()); 
			this._initButton(this._playerFullscreen);
			
			this._playerFullscreen._x = BUTTON_WIDTH;
			if (this._showOpen) {
				this._playerFullscreen._x += BUTTON_WIDTH;
			}
			if (this._showPrevious) {
				this._playerFullscreen._x += BUTTON_WIDTH;
			}
			if (this._showStop) {
				this._playerFullscreen._x += BUTTON_WIDTH;
			}
			if (this._showNext) {
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
			
			this._playerFullscreen.icon_mc._y = PLAYER_HEIGHT/2 - this._playerFullscreen.icon_mc._height/2;
			this._playerFullscreen.icon_mc._x = BUTTON_WIDTH/2 - this._playerFullscreen.icon_mc._width/2;
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
			if (this._showOpen) {
				this._playerTime._x += BUTTON_WIDTH;
			}
			if (this._showPrevious) {
				this._playerTime._x += BUTTON_WIDTH;
			}
			if (this._showStop) {
				this._playerTime._x += BUTTON_WIDTH;
			}
			if (this._showNext) {
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
		if( (this.controller.getDuration() == undefined && this.controller.isPlaying && buffer != 100) || (buffer != 100 && this.controller.isPlaying && this.controller.getDuration() - this.controller.getPosition() > this.controller.getBufferTime()) ){
			// if the duration is not defined, the video is playing and the buffer is not to 100
			// if the video is not at the end
			var message:String = this._bufferMessage;
			message = message.split("_n_").join(String(buffer)+"%");
			
			this._buffering.message_txt.text = message;
			
			if (buffer >= this._lastBuffer) {
				this._buffering._visible = true;
			} else {
				this._buffering._visible = false;
			}
		}else{
			this._buffering._visible = false;
		}
		this._lastBuffer = buffer;
		
		if (this.controller.isPlaying) {
			this.video.title_txt._visible = false;
			this.video.image_mc._visible = false;
			this.video.iconplay_mc._visible = false;
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
	/**
	 * Executed when the Fullscreen is on
	 */
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
		this._initPlayerPlaylist();
		this._initPlayerSlider(this._marginSlider);
		
		resizeVideo();
	}
	/**
	 * Executed when the Fullscreen is off
	 */
	private function _onStageNormal()
	{
		this._isFullscreen = false;
		
		this._videoMargin = (_root.margin === undefined)?5:parseInt(_root.margin, 10);
		this._player._x = this._videoMargin;
		this._player._y = Stage.height - PLAYER_HEIGHT - this._videoMargin;
		_root.width = Stage.width;
		_root.height = Stage.height;
		this._swfWidth = Stage.width;
		this._swfHeight = Stage.height;
		
		this._initFlash();
		this._initBackground();
		this._initTitle();
		this._initSubtitles();
		this._initVideo();
		this._initPlayerBackground();
		this._initPlayerPlaylist();
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
		clearInterval(this._videoDelayItv);
		super.playRelease();
		
		this.video.freeze_mc._visible = false;
		this.video.title_txt._visible = false;
		this.video.image_mc._visible = false;
		this.video.iconplay_mc._visible = false;
		
		this._enableButton(this._playerPlay, false, true);
		this._enableButton(this._playerPause, true);
		this._enableButton(this._playerStop, true);
		
		if (this._showPlayer === "autohide") {
			Mouse.addListener(this._mouse);
		}
		
		this.updatePlaylist(true);
		this.controller.setVolume(this._volume);
		
		// hide the playlist
		this._playlist._visible = false;
		
		// javascript event
		this.sendToJavascript(this._listener+"onPlay", this._listener+"onPlay('"+this.controller.playlist[this.controller.index]+"');");
	}
	/**
	 * Action sur le bouton Pause
	 */
	public function pauseRelease()
	{
		clearInterval(this._videoDelayItv);
		super.pauseRelease();
		
		this._enableButton(this._playerPause, false, true);
		this._enableButton(this._playerPlay, true);
		
		this.updatePlaylist();
		
		// javascript event
		this.sendToJavascript(this._listener+"onPause", this._listener+"onPause('"+this.controller.playlist[this.controller.index]+"');");
	}
	/**
	 * Action sur le bouton Stop
	 */
	public function stopRelease()
	{
		Mouse.removeListener(this._mouse);
		clearInterval(this._videoDelayItv);
		clearInterval(this._playerItv);
		
		super.stopRelease();
		
		switch (this._showTitleBackground) {
			default:
			case "auto":
				this.video.freeze_mc._visible = (this.video.title_txt.field.text != "");
				break;
			case "always":
				this.video.freeze_mc._visible = true;
				break;
			case "never":
				this.video.freeze_mc._visible = false;
				break;
		}
		this.video.title_txt._visible = true;
		this.video.image_mc._visible = true;
		this.video.iconplay_mc._visible = true;
		
		this._enableButton(this._playerStop, false);
		this._enableButton(this._playerPause, false, true);
		this._enableButton(this._playerPlay, true);
		
		this.updatePlaylist();
		this._currentIndex = this.controller.index;
		this._initTitle();
		
		if (this._showPlayer !== "never") {
			this._player._visible = true;
		}
		
		// javascript event
		this.sendToJavascript(this._listener+"onStop", this._listener+"onStop('"+this.controller.playlist[this.controller.index]+"');");
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
	/**
	 * Action sur le bouton Next
	 * 
	 * @param pForce Force to play next
	 */
	public function nextRelease(pForce:Boolean)
	{
		if (this.controller.hasNext && (this._autoNext || pForce === true) ) {
			this.controller.next();
			
			this._currentIndex = this.controller.index;
			if (!this.controller.isPlaying && this._playOnLoad) {
				this._initTitle();
			} else {
				this.stopRelease();
				if (this._showPlayer === "autohide") {
					this._player._visible = false;
				}
			}
			clearInterval(this._videoDelayItv);
			this._videoDelayItv = setInterval(this, "playRelease", this._videoDelay);
			this.updatePlaylist();
		} else {
			this.stopRelease();
			
			// Open the playlist at the end
			if (this._showOpen === 2) {
				this._playlist._visible = true;
			}
		}
		
		this._enableButton(this._playerPrevious, this.controller.hasPrevious);
		this._enableButton(this._playerNext, this.controller.hasNext);
		
		// javascript event
		this.sendToJavascript(this._listener+"onNext", this._listener+"onNext('"+this.controller.playlist[this.controller.index]+"');");
	}
	/**
	 * Action sur le bouton Previous
	 */
	public function previousRelease()
	{
		this.controller.previous();
		
		this._currentIndex = this.controller.index;
		if (!this.controller.isPlaying && this._playOnLoad) {
			this._initTitle();
			this.playRelease();
			
		} else {
			this.stopRelease();
			clearInterval(this._videoDelayItv);
			this._videoDelayItv = setInterval(this, "playRelease", this._videoDelay);
		}
		this.updatePlaylist();
		
		this._enableButton(this._playerNext, this.controller.hasNext);
		this._enableButton(this._playerPrevious, this.controller.hasPrevious);
		
		// javascript event
		this.sendToJavascript(this._listener+"onPrevious", this._listener+"onPrevious('"+this.controller.playlist[this.controller.index]+"');");
	}
	/**
	 * Mise à jour de la playlist
	 * 
	 * @param pAutoScroll Indique qu'il faut scroller au bon endroit de la liste
	 */
	public function updatePlaylist(pAutoScroll:Boolean)
	{
		var text:String = ""
		var color:String = this._buttonColor.toString(16);
		var vTitle:String;
		
		// S'il n'y a aucun élément, on affiche "Liste Vide"
		if (this.controller.playlist.length > 0) {
			text = "";
		} else {
			text = "<font color=\"#"+color+"\" face=\""+this._font+"\">Liste vide</font>";
		}
		
		// Pour chaque élément, on affiche le titre
		for (var i:Number=0; i<this.controller.playlist.length; i++) {
			// Couleur de l'élément
			if (i == this.controller.index) {
				color = this._currentFlvColor.toString(16)
			} else {
				color = this._playlistTextColor.toString(16);
			}
			
			// Début : couleur et lien
			text += "<font color=\"#"+color+"\" face=\""+this._font+"\">";
			text += "<a href=\"asfunction:play," + i + "\">";
			text += (i+1) + " - ";
			
			// Titre
			if (this._title[i] != undefined) {
				vTitle = this._title[i];
			} else {
				vTitle = this.controller.playlist[i];
			}
			vTitle = vTitle.split("\\n").join(", ");
			vTitle = vTitle.split("/n").join(", "); // pour IE
			
			// Défilement automatique pour la piste sélectionnée
			this._playlist.list_txt_tmp.text = vTitle;
			if (i == this.controller.index && this._playlist.list_txt_tmp.maxhscroll > 0) {
				// On peut scroller
				vTitle += " - ";
				var textLength:Number = vTitle.length;
				
				if (++this._playlist.waitScroll < 40) {
					this._playlist.intervalScroll = 0;
				}
				
				vTitle = vTitle.substring(this._playlist.scrollMemo, textLength) + vTitle.substring(0, this._playlist.scrollMemo - 1);
				if (++this._playlist.intervalScroll > 5) {
					this._playlist.scrollMemo += 1;
					this._playlist.intervalScroll = 0;
				}
				this._playlist.scrollMemo = this._playlist.scrollMemo % (textLength);
			}
			this._playlist.list_txt_tmp.text = "";
			text += vTitle
			
			// Fin : lien et couleur
			text += "\n";
			text += "</a>";
			text += "</font>";
		}
		
		// Affichage du texte
		this._playlist.list_txt.htmlText = text;
		
		// Scroll automatique sur l'élément
		if (pAutoScroll && this._playlist.list_txt.maxscroll > 1) {
			this._playlist.list_txt.scroll = this._playlist.list_txt.maxscroll - (this.controller.playlist.length - 1 - this.controller.index);
		}
		
		// Modification des états des boutons
		this._enableButton(this._playerPrevious, this.controller.hasPrevious);
		this._enableButton(this._playerNext, this.controller.hasNext);
	}
	/**
	 * Action on the Fullscreen button
	 */
	public function fullscreenRelease()
	{
		Stage["displayState"] = (!this._isFullscreen)?"fullscreen":"normal";
	}
	/**
	 * Action sur le bouton ShowSubtitles
	 */
	public function showSubtitlesRelease()
	{
		this._subtitles.hide = (this._subtitles.hide)?false:true;
		this._subtitles._visible = this._subtitles.hide;
	}
	/**
	 * Action sur le bouton HideSubtitles
	 */
	public function hideSubtitlesRelease()
	{
		
	}
	/**
	 * Load jpg or swf on top of the video
	 * 
	 * @param pDepth The depth
	 * @param pUrl The url
	 * @param pVerticalAlign Vertical align
	 * @param pHorizontalAlign Horizontal align
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
	/**
	 * Lecture
	 * 
	 * @param pIndex (optional) L'index de la vidéo	 */
	public function set jsPlay(pIndex:String)
	{
		if (pIndex != "") {
			this.controller.setIndex(Number(pIndex));
			this.playRelease();
		} else if (!this.controller.isPlaying) {
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
	public function set jsNext(n:String)
	{
		this.nextRelease(true);
	}
	public function set jsPrevious(n:String)
	{
		this.previousRelease();
	}
	public function set jsVolume(n:String)
	{
		this.controller.setVolume(Number(n));
		this._updateVolume();
	}
	
	/**
	 * Send command to javascript
	 * 
	 * @param pTest The javascript object to test
	 * @param pCommand The javascript command
	 */
	public function sendToJavascript(pTest:String, pCommand:String)
	{
		var command:String = "if("+pTest+"){"+pCommand+"}";
		if (this._listener) {
			getURL("javascript:"+command);
		}
	}
	/*=================== FIN = CONTROLES JAVASCRIPT = FIN ===================*/
	/*========================================================================*/
}