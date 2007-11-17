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
 * Classe abstraite pour un thème
 * 
 * @author		neolao <neo@neolao.com> 
 * @version 	0.8.0 (17/11/2007)
 * @license		http://creativecommons.org/licenses/by-sa/3.0/deed.fr
 */
class ATemplate
{
	// ----------------------------- CONSTANTES --------------------------------
	static var SWF_MINWIDTH:Number = 20;
	static var SWF_MINHEIGHT:Number = 20;
	
	// ------------------------------ VARIABLES --------------------------------
	/**
	 * La largeur du Flash	 */
	private var _swfWidth:Number;
	/**
	 * La haueur du Flash	 */
	private var _swfHeight:Number;
	/**
	 * Les raccourcis clavier
	 */
	private var _shortcuts:Array;
	
	/**
	 * L'instance du fond
	 */	private var _background:MovieClip = _root.background_mc;
	/**
	 * L'instance du clip contenant l'objet Video	 */
	public var video:MovieClip = _root.video_mc;
	/**
	 * L'instance du lecteur	 */
	private var _player:MovieClip;
	/**
	 * L'instance du controleur de la vidéo
	 */
	public var controller:PlayerBasic;
	/**
	 * 	 */
	private var _lastFocus:String;
	
	
	/*============================= CONSTRUCTEUR =============================*/
	/*========================================================================*/
	/**
	 * Initialisation
	 */
	private function ATemplate()
	{
		this._initFlash();
		this._initVars();
		this._initKey();
		this._initVideo();
		this._initPlayer();
	}
	/*======================= FIN = CONSTRUCTEUR = FIN =======================*/
	/*========================================================================*/
	
	/*=========================== METHODES PRIVEES ===========================*/
	/*========================================================================*/
	/**
	 * Initialisation du Flash
	 */
	private function _initFlash()
	{
		Stage.scaleMode = "noScale";
		Stage.align = "TL";
		
		if (_root.width != undefined) {
			this._swfWidth = Number(_root.width);
		} else {
			this._swfWidth = Stage.width;
		}
		if (this._swfWidth < SWF_MINWIDTH) {
			this._swfWidth = SWF_MINWIDTH;
		}
		
		if (_root.height != undefined) {
			this._swfHeight = Number(_root.height);
		} else {
			this._swfHeight = Stage.height;
		}
		if (this._swfHeight < SWF_MINHEIGHT) {
			this._swfHeight = SWF_MINHEIGHT;
		}
	}
	/**
	 * Initialisation des variables 
	 */
	private function _initVars()
	{
		
	}
	/**
	 * Initialisation du gestionnaire de clavier
	 */
	private function _initKey()
	{
		this._shortcuts = new Array();
		
		var o:Object = new Object();
		o.onKeyDown = this.delegate(this, function() 
		{
		    var currentSelection:String = Selection.getFocus();
		    switch (Key.getCode()) {
		     	case Key.LEFT:
		     	case Key.RIGHT:
		     	case Key.UP:
		     	case Key.DOWN:
		     		if (currentSelection) {
		     			this._lastFocus = currentSelection;
		 			 	Selection.setFocus(null);
		     			return;
		     		}
		    }
 			this._lastFocus = null;
		});
		o.onKeyUp = this.delegate(this, function() 
		{
 			 if (this._lastFocus) {
 			 	Selection.setFocus(this._lastFocus);
 			 }
		     
		     if (Key.getCode() == Key.ESCAPE) {
		     	// Remove the focus on buttons when the user press the Esc key
		     	Selection.setFocus(null);
		     } else if (this._shortcuts[Key.getCode()]) {
		     	this._shortcuts[Key.getCode()]();
		     }
		});
		Key.addListener(o);
	}
	/**
	 * Ajouter un raccourci clavier
	 * 
	 * @param pKeyCode Le code de la touche
	 * @param pFunction La fonction à exécuter
	 */
	private function _addShortcut(pKeyCode:Number, pFunction:Function)
	{
		this._shortcuts[pKeyCode] = pFunction;
	}
	/**
	 * Initialisation de la vidéo	 */
	private function _initVideo()
	{
		// Fond noir de la taille de la vidéo
		this.video.beginFill(0);
		this.video.lineTo(0, this._swfHeight);
		this.video.lineTo(this._swfWidth, this._swfHeight);
		this.video.lineTo(this._swfWidth, 0);
		this.video.endFill();
		
		
		this.video.video._width = this._swfWidth;
		this.video.video._height = this._swfHeight;
		this.video.video._x = 0;
		this.video.video._y = 0;
	}
	/**
	 * Initialisation du lecteur
	 */
	private function _initPlayer(){
		this._player = _root.createEmptyMovieClip("player_mc", _root.getNextHighestDepth()); 
	}
	
	/*===================== FIN = METHODES PRIVEES = FIN =====================*/
	/*========================================================================*/
	
	/*========================== METHODES PUBLIQUES ==========================*/
	/*========================================================================*/
	/**
	 * Délégation de fonction
	 * 
	 * @param pTarget La cible
	 * @param pFunc La fonction
	 * @return La même fonction avec un scope fixe
	 */
	public function delegate(pTarget:Object, pFunc:Function):Function
	{
		var f:Function = function(){
			var target:Object = arguments.callee.target;
			var func:Function = arguments.callee.func;
			var args:Array = arguments.callee.args.concat(arguments);

			return func.apply(target, args);
		};

		f.target = arguments.shift(); // pTarget
		f.func = arguments.shift(); // pFunc
		f.args = arguments; // pArg1, pArg2, ...
 
		return f;
	}
	/**
	 * Redimensionne la video
	 * 
	 * @param pWidth (optional) La largeur de la vidéo
	 * @param pHeight (optional) La hauteur de la vidéo	 */
	public function resizeVideo(pWidth:Number, pHeight:Number)
	{
		// On redimensinone la vidéo à la taille du flash en gardant les proportions
		var originWidth:Number = (pWidth !== undefined)?pWidth:this.video.video.width;
		var originHeight:Number = (pHeight !== undefined)?pHeight:this.video.video.height;
		var newWidth:Number = this._swfWidth;
		var newHeight:Number = newWidth * originHeight / originWidth;
		
		if (newHeight > this._swfHeight) {
			newHeight = this._swfHeight;
			newWidth = newHeight * originWidth / originHeight;
		}
		
		this.video.video._width = newWidth;
		this.video.video._height = newHeight;
		this.video.video._x = (this._swfWidth - newWidth) / 2;
		this.video.video._y = (this._swfHeight - newHeight) / 2;
	}
	/**
	 * Action sur le bouton Play
	 */
	public function playRelease()
	{
		this.controller.play();
		if (this.controller.getLoading().percent != 100) {
			this.startLoading();
		}
		this.resizeVideo();
	}
	/**
	 * Action sur le bouton Pause
	 */
	public function pauseRelease()
	{
		this.controller.pause();
	}
	/**
	 * Action sur le bouton Stop
	 */
	public function stopRelease()
	{
		this.controller.stop();
	}
	/**
	 * Affichage du chargement
	 */
	public function startLoading()
	{
		
	}
	/*==================== FIN = METHODES PUBLIQUES = FIN ====================*/
	/*========================================================================*/
}