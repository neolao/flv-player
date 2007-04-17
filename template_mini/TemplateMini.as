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
 * Thème mini du lecteur flv
 * 
 * @author		neolao <neo@neolao.com> 
 * @version 	0.2.1 (17/04/2007)
 * @license		http://creativecommons.org/licenses/by-sa/3.0/deed.fr
 */ 
class TemplateMini extends ATemplate
{
	// ----------------------------- CONSTANTES --------------------------------
	static var PLAYER_HEIGHT:Number = 20;
	static var PLAYER_TIMEOUT:Number = 1500;
	static var BUTTON_WIDTH:Number = 26;
	static var SLIDER_WIDTH:Number = 20;
	static var SLIDER_HEIGHT:Number = 10;
	
	// ------------------------------ VARIABLES --------------------------------
	/**
	 * Le fond du lecteur	 */
	private var _playerBackground:MovieClip;
	/**
	 * La couleur du lecteur	 */
	private var _playerColor:Number = 0x111111;
	/**
	 * Le bouton Play du lecteur	 */
	private var _playerPlay:MovieClip;
	/**
	 * Le bouton Pause du lecteur	 */
	private var _playerPause:MovieClip;
	/**
	 * Le bouton Stop du lecteur	 */
	private var _playerStop:MovieClip;
	/**
	 * La barre de lecture	 */
	private var _playerSlider:MovieClip;
	/**
	 * La barre de chargement
	 */	private var _loadingBar:MovieClip;
	/**
	 * L'indicateur du tampon
	 */	private var _buffering:MovieClip;
	/**
	 * La couleur des boutons	 */
	private var _buttonColor:Number = 0xffffff;
	/**
	 * La couleur de la barre de lecture	 */
	private var _sliderColor:Number = 0xcccccc;
	/**
	 * La couleur de la barre de chargement	 */
	private var _loadingColor:Number = 0xffff00;
	/**
	 * La dernière valeur du buffer
	 */
	private var _lastBuffer:Number = 0;
	
	/*============================= CONSTRUCTEUR =============================*/
	/*========================================================================*/
	/**
	 * Initialisation
	 */
	public function TemplateMini()
	{
		super();
	}
	/**
	 * Lancé par mtasc
	 */
	static function main():Void
	{
		// Initialisation du lecteur
		var player:PlayerBasic = new PlayerBasic(new TemplateMini());
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
		
		if (_root.playercolor != undefined) {
			this._playerColor = parseInt(_root.playercolor, 16);
		}
		if (_root.buttoncolor != undefined) {
			this._buttonColor = parseInt(_root.buttoncolor, 16);
		}
		if (_root.slidercolor != undefined) {
			this._sliderColor = parseInt(_root.slidercolor, 16);
		}
		if (_root.loadingcolor != undefined) {
			this._loadingColor = parseInt(_root.loadingcolor, 16);
		}
	}
	/**
	 * Initialisation de la vidéo
	 */
	private function _initVideo()
	{
		super._initVideo();
		
		// On réduit la video pour que le lecteur rentre en bas
		if (this.video.video._height > this._swfHeight - PLAYER_HEIGHT) {
			var ratio:Number = this.video.video._width / this.video.video._height;
			this.video.video._height = this._swfHeight - PLAYER_HEIGHT;
			this.video.video._width = this.video.video._height * ratio;
		}
		
		this.video.video._x = (this._swfWidth - this.video.video._width) / 2;
		this.video.video._y = (this._swfHeight - PLAYER_HEIGHT - this.video.video._height) / 2;
		
		this._initBuffering();
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
	 * Initialisation du lecteur
	 */
	private function _initPlayer(){
		super._initPlayer();
		
		this._player._y = this._swfHeight - PLAYER_HEIGHT;
		
		this._initPlayerBackground();
		this._initPlayerPlay();
		this._initPlayerPause();
		this._initPlayerSlider(BUTTON_WIDTH);
	}
	/**
	 * Initialisation du fond du lecteur
	 */
	private function _initPlayerBackground(){
		this._playerBackground = this._player.createEmptyMovieClip("background_mc", this._player.getNextHighestDepth()); 
		
		this._playerBackground.beginFill(this._playerColor);
		this._playerBackground.lineTo(0, PLAYER_HEIGHT);
		this._playerBackground.lineTo(this.video._width, PLAYER_HEIGHT);
		this._playerBackground.lineTo(this.video._width, 0);
		this._playerBackground.endFill();
	}
	/**
	 * Initialisation d'un bouton
	 * @param pTarget Le bouton à initialiser
	 */
	private function _initButton(pTarget:MovieClip){
		var vArea:MovieClip = pTarget.createEmptyMovieClip("area_mc", pTarget.getNextHighestDepth());
		var vIcon:MovieClip = pTarget.createEmptyMovieClip("icon_mc", pTarget.getNextHighestDepth());
		
		vArea.beginFill(0, 0);
		vArea.moveTo(2, 2);
		vArea.lineTo(2, PLAYER_HEIGHT - 4);
		vArea.lineTo(BUTTON_WIDTH - 4, PLAYER_HEIGHT - 4);
		vArea.lineTo(BUTTON_WIDTH - 4, 2);
		vArea.endFill();
		
		vArea.icon = vIcon;
		vArea.onRollOver = function(){ 
			this.icon._alpha = 75;
		}; 
		vArea.onRollOut = vArea.onDragOut = vArea.onPress = function(){ 
			this.icon._alpha = 100
		}; 
	}
	/** 
	 * Change l'état d'un bouton 
	 * @param pButton L'instance du bouton 
	 * @param pStatus true pour activer le bouton, sinon false 
	 * @param pMask (optional) pour masquer complètement le bouton
	 */ 
	private function _enableButton(pButton:MovieClip, pStatus:Boolean, pMask:Boolean){ 
		pButton.area_mc.enabled = pStatus; 
		pButton._visible = !pMask; 
		if(!pStatus) pButton.icon_mc._alpha = 30; 
		else pButton.icon_mc._alpha = 100; 
	}
	/**
	 * Initialisation du bouton play
	 */
	private function _initPlayerPlay(){
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
	private function _initPlayerPause(){
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
	 * Initialisation de la barre de lecture
	 * 
	 * @param pMargin La marge gauche de la barre
	 */
	private function _initPlayerSlider(pMargin:Number){
		this._playerSlider = this._player.createEmptyMovieClip("slider_mc", this._player.getNextHighestDepth());
		
		// calcul de la taille
		var vMargin:Number = pMargin;
		vMargin += 10;
		
		this._playerSlider._x = vMargin;
		this._playerSlider.width = this._swfWidth - vMargin - 10;
		
		// barre
		var vBarBg:MovieClip = this._playerSlider.createEmptyMovieClip("barBg_mc", this._playerSlider.getNextHighestDepth()); 
		vBarBg.beginFill(0xcccccc, 25);
		vBarBg.moveTo(0, -1);
		vBarBg.lineTo(this._playerSlider.width, -1);
		vBarBg.lineTo(this._playerSlider.width, 2);
		vBarBg.lineTo(0, 2);
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
		vSlider.onRollOver = function(){
			this._alpha = 75;
		};
		vSlider.onRollOut = function(){  
			this._alpha = 100
		};
		vSlider.onPress = this.delegate(this, function(){
			this._playerSlider.bar_mc.startDrag(false, 0, this._playerSlider.bar_mc._y, this._playerSlider.width - this._playerSlider.bar_mc._width, this._playerSlider.bar_mc._y);
			this._playerSlider.bar_mc.onEnterFrame = this.delegate(this, this._sliderMoving);
		});
		vSlider.onRelease = vSlider.onReleaseOutside = this.delegate(this, function(){ 
			this._playerSlider.bar_mc.stopDrag();
			this._playerSlider.bar_mc.onEnterFrame = this.delegate(this, this._sliderEnterFrame);
		});
		
		vSlider.beginFill(this._sliderColor); 
		vSlider.lineTo(0, SLIDER_HEIGHT);
		vSlider.lineTo(SLIDER_WIDTH, SLIDER_HEIGHT);
		vSlider.lineTo(SLIDER_WIDTH, 0);
		vSlider.endFill();
		vSlider._y = PLAYER_HEIGHT / 2 - SLIDER_HEIGHT / 2;
		
		vSlider.onEnterFrame = this.delegate(this, this._sliderEnterFrame);
	}
	/** 
	 * Le enterFrame du slider 
	 */ 
	private function _sliderEnterFrame(){
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
			this._buffering.message_txt.text = "buffering "+buffer+"%";
			
			if (buffer >= this._lastBuffer) {
				this._buffering._visible = true;
			} else {
				this._buffering._visible = false;
			}
		}else{
			this._buffering._visible = false;
		}
		this._lastBuffer = buffer;
	}
	/**
	 * Déplacement du slider	 */
	private function _sliderMoving()
	{
		var position:Number = this._playerSlider.bar_mc._x / (this._playerSlider.width - SLIDER_WIDTH) * this.controller.getDuration(); 
		this.controller.setPosition(position);
	}
	/**
	 * Chargement
	 */
	private function _loading(){
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
	 * Action sur le bouton Play
	 */
	public function playRelease()
	{
		super.playRelease();
		
		this._enableButton(this._playerPlay, false, true);
		this._enableButton(this._playerPause, true);
		this._enableButton(this._playerStop, true);
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
	}
	/**
	 * Affichage du chargement
	 */
	public function startLoading():Void
	{
		super.startLoading();
		this._loadingBar.onEnterFrame = delegate(this, this._loading);
		this._loadingBar._visible = true;
	}
	/*==================== FIN = METHODES PUBLIQUES = FIN ====================*/
	/*========================================================================*/
}