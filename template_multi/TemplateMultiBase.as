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
 * Template multi control bar
 * 
 * @author		neolao <neo@neolao.com> 
 * @license		http://creativecommons.org/licenses/by-sa/3.0/deed.fr
 */ 
class TemplateMultiBase extends ATemplate
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
	 * La taille de la police des sous-titres	 */
	private var _subtitleSize:Number = 11;
	/**
	 * L'instance du clip des sous-titres
	 */
	private var _subtitles:MovieClip;
	/**
	 * La police
	 */
	private var _font:String;
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
	 * Le format de la police de la playlist
	 */
	private var _playlistFormat:TextFormat;
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
	 * Le bouton Playlist
	 */
	private var _playerPlaylist:MovieClip;
	/**
	 * La liste des vidéos
	 */
	private var _playlist:MovieClip;
	/**
	 * La scrollbar de la playlist
	 */
	private var _playlistScrollbar:MovieClip;
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
	 * Le bouton Previous du lecteur
	 */
	private var _playerPrevious:MovieClip;
	/**
	 * Le bouton Next du lecteur
	 */
	private var _playerNext:MovieClip;
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
	 * The Fullscreen button
	 */
	private var _playerFullscreen:MovieClip;
	/**
	 * Le bouton "Close Captions" du lecteur pour afficher les sous-titres
	 */
	private var _playerShowSubtitles:MovieClip;
	/**
	 * Le bouton "Close Captions" du lecteur pour cacher les sous-titres
	 */
	private var _playerHideSubtitles:MovieClip;
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
	 * La liste des image de titre des vidéos
	 */
	private var _startImage:Array;
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
	 * Le bouton Previous
	 */
	private var _showPrevious:Boolean = false;
	/**
	 * Le bouton Next
	 */
	private var _showNext:Boolean = false;
	/**
	 * The Open button
	 */
	private var _showOpen:Number = 1;
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
	 * L'instance du controleur de la vidéo
	 */
	public var controller:PlayerMulti;
	/**
	 * L'index du flv en cours de lecture
	 */	private var _currentIndex:Number = 0;
	/**
	 * La couleur du flv en cours de lecture
	 */
	private var _currentFlvColor:Number = 0xffff00;
	/**
	 * La couleur de la scrollbar
	 */
	private var _scrollbarColor:Number = 0xffffff;
	/**
	 * La couleur de la scrollbar au survol
	 */
	private var _scrollbarOverColor:Number = 0xffff00;
	/**
	 * La liste des titres des flv
	 */
	private var _title:Array;
	/**
	 * Le volume
	 */
	private var _volume:Number = 100;
	/**
	 * Le volume maximum
	 */
	private var _volumeMax:Number = 200;
	/**
	 * Action au click sur la vidéo
	 * 
	 * - "playpause" : basculer entre play et pause
	 * - "none" : ne rien faire
	 * - url : l'url de destination
	 */
	private var _onClick:String = "playpause";
	/**
	 * La cible du onclick
	 */
	private var _onClickTarget:String = "_self";
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
	 * Délai entre le titre et le début de la vidéo
	 */
	private var _videoDelay:Number = 1;
	/**
	 * L'interval pour le délai entre le titre et le début de la vidéo
	 */
	private var _videoDelayItv:Number;
	/**
	 * Lecture de la vidéo suivante automatiquement	 */
	private var _autoNext:Boolean = true;
	/**
	 * Activation des raccourcis clavier	 */
	private var _shortcut:Boolean = true;
	/**
	 * La couleur de fond de la vidéo (quand il n'y a pas de vidéo ^.^;)
	 */
	private var _videoBackgroundColor:Number = 0;
	/**
	 * La couleur du titre de la vidéo
	 */
	private var _titleColor:Number = 0xffffff;
	/**
	 * La couleur du text de la playlist
	 */
	private var _playlistTextColor:Number = 0xffffff;
	/**
	 * La dernière valeur du buffer
	 */
	private var _lastBuffer:Number = 0;
	/**
	 * Fullscreen button display
	 */
	private var _showFullscreen:Boolean = false;
	/**
	 * Fullscreen flag
	 */
	private var _isFullscreen:Boolean = false;
	/**
	 * The slider margin left
	 */
	private var _marginSlider:Number = 0;
	/**
	 * Memorise stage parameters when fullscreen is off
	 */
	private var _stageNormalParams:Object;
	/**
	 * Play the video on load
	 */
	private var _playOnLoad:Boolean = true;
	/**
	 * Affichage du bouton "Close Captions"
	 */
	private var _showSwitchSubtitles:Boolean = false;
	/**
	 * Scrollbar size
	 */
	private var _playlistScrollbarSize:Number = 4;
	/**
	 * Show title background
	 */
	private var _showTitleBackground:String = "auto";
	/**
	 * Javascript object listener
	 */
	private var _listener:String = "";
	
	
	/*============================= CONSTRUCTEUR =============================*/
	/*========================================================================*/
	/**
	 * Initialisation
	 */
	public function TemplateMultiBase()
	{
		super();
	}
	/*======================= FIN = CONSTRUCTEUR = FIN =======================*/
	/*========================================================================*/
	
	/*=========================== METHODES PRIVEES ===========================*/
	/*========================================================================*/
	/*===================== FIN = METHODES PRIVEES = FIN =====================*/
	/*========================================================================*/
	
	/*========================== METHODES PUBLIQUES ==========================*/
	/*========================================================================*/
	
	/*==================== FIN = METHODES PUBLIQUES = FIN ====================*/
	/*========================================================================*/
	
	/*========================= CONTROLES JAVASCRIPT =========================*/
	/*========================================================================*/
	
	/*=================== FIN = CONTROLES JAVASCRIPT = FIN ===================*/
	/*========================================================================*/
}