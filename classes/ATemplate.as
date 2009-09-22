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
 * @author      neolao <neo@neolao.com>
 * @version     0.9.0 (22/09/2009)
 * @license     http://creativecommons.org/licenses/by-sa/3.0/deed.fr
 */
class ATemplate
{
    // CONSTANTS
    static var SWF_MINWIDTH:Number = 20;
    static var SWF_MINHEIGHT:Number = 20;

    /**
     * Flash width
     */
    private var _swfWidth:Number;
    /**
     * Flash height
     */
    private var _swfHeight:Number;
    /**
     * Shortcuts
     */
    private var _shortcuts:Array;
    /**
     * The background
     */
    private var _background:MovieClip = _root.background_mc;
    /**
     * The video container
     */
    public var video:MovieClip = _root.video_mc;
    /**
     * The player instance
     */
    private var _player:MovieClip;
    /**
     * The player controller
     */
    public var controller:PlayerBasic;
    /**
     * The last focus
     */
    private var _lastFocus:String;


    /**
     * Constructor
     */
    private function ATemplate()
    {
        System.security.allowDomain("*");

        this._initFlash();
        this._initKey();
        this._initVideo();
        this._initPlayer();
    }

    /*============================ PUBLIC METHODS ============================*/
    /*========================================================================*/
    /**
     * Delegate function
     *
     * @param pTarget La cible
     * @param pFunc La fonction
     * @return La même fonction avec un scope fixe
     */
    public function delegate(pTarget:Object, pFunc:Function):Function
    {
        var f:Function = function():Object{
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
     * @param pHeight (optional) La hauteur de la vidéo	 */
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
    /*======================= END = PUBLIC METHODS = END =====================*/
    /*========================================================================*/

    /*============================ PRIVATE METHODS ===========================*/
    /*========================================================================*/
    /**
     * Flash initialisation
     */
    private function _initFlash()
    {
        Stage.scaleMode = "noScale";
        Stage.align = "TL";
        var percentage:Number = 100;

        if (_root.width != undefined) {
            if (_root.width.charAt(_root.width.length - 1) == "%") {
                percentage = Number(_root.width.substring(0, _root.width.length - 1));
                this._swfWidth = Stage.width * percentage / 100;
            } else {
                this._swfWidth = Number(_root.width);
            }
        } else {
            this._swfWidth = Stage.width;
        }
        if (this._swfWidth < SWF_MINWIDTH) {
            this._swfWidth = SWF_MINWIDTH;
        }

        if (_root.height != undefined) {
            if (_root.height.charAt(_root.height.length - 1) == "%") {
                percentage = Number(_root.height.substring(0, _root.height.length - 1));
                this._swfHeight = Stage.height * percentage / 100;
            } else {
                this._swfHeight = Number(_root.height);
            }
        } else {
            this._swfHeight = Stage.height * percentage / 100;
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
     * Shortcuts initialisation
     */
    private function _initKey()
    {
        this._shortcuts = new Array();

        var o:Object = new Object();
        o.onKeyDown = this.delegate(this, this._onKeyDown);
        o.onKeyUp = this.delegate(this, this._onKeyUp);
        Key.addListener(o);
    }

    /**
     * Key down handler
     */
    private function _onKeyDown()
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
    }

    /**
     * Key up handler
     */
    private function _onKeyUp()
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

    }

    /**
     * Add a shortcut
     *
     * @param   keyCode     The code of the key
     * @param   func        The handler
     */
    private function _addShortcut( keyCode:Number, func:Function )
    {
        this._shortcuts[keyCode] = func;
    }

    /**
     * Video initialisation
     */
    private function _initVideo()
    {
        // Black background
        this.video.beginFill(0);
        this.video.lineTo(0, this._swfHeight);
        this.video.lineTo(this._swfWidth, this._swfHeight);
        this.video.lineTo(this._swfWidth, 0);
        this.video.endFill();

        // Size and position
        this.video.video._width = this._swfWidth;
        this.video.video._height = this._swfHeight;
        this.video.video._x = 0;
        this.video.video._y = 0;
    }

    /**
     * Player initialisation
     */
    private function _initPlayer()
    {
        this._player = _root.createEmptyMovieClip("player_mc", _root.getNextHighestDepth());
    }

    /*====================== END = PRIVATE METHODS = END =====================*/
    /*========================================================================*/

}
