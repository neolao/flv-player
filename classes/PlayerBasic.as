/**
 * Lecteur FLV basique
 * 
 * @author		neolao <neo@neolao.com> 
 * @version 	0.8.1 (25/01/2007) 
 * @link		http://resources.neolao.com/flash/components/player_flv 
 * @license		http://creativecommons.org/licenses/by-sa/2.5/ 
 */
class PlayerBasic
{
	// ------------------------------ VARIABLES --------------------------------
	private var _nc:NetConnection;
	private var _ns:NetStream;
	
	/**
	 * L'instance du thème utilisé
	 */
	private var _template:ATemplate;
	/**
	 * Le temps de mise en tampon, en seconde	 */
	private var _bufferTime:Number = 5;
	/**
	 * Répéter la vidéo ?	 */
	private var _loop:Boolean = false;
	/**
	 * Le son	 */
	private var _sound:Sound;
	/**
	 * La durée de la vidéo	 */
	private var _videoDuration:Number;
	/**
	 * L'adresse du flv	 */
	private var _videoUrl:String;
	/**
	 * Indique si c'est la première lecture	 */
	private var _firstPlay:Boolean = false;
	/**
	 * Indique si on est en lecture	 */
	public var isPlaying:Boolean = false;
	
	/*============================= CONSTRUCTEUR =============================*/
	/*========================================================================*/
	/**
	 * Initialisation
	 * 
	 * @param pTemplate L'instance du thème à utiliser
	 */
	public function PlayerBasic(pTemplate:ATemplate)
	{
		
		this._template = pTemplate;
		this._template.controller = this;
		
		this._initVars();
		this._initVideo();
		
		// Lecture automatique
		if (_root.autoplay == "1") {
			this._template.playRelease();
		} else {
			if (_root.autoload == "1") {
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
		if (_root.flv != undefined) {
			this._videoUrl = _root.flv;
		}
		if (_root.buffer != undefined) {
			this._bufferTime = Number(_root.buffer);
		}
		if (_root.loop == "1") {
			this._loop = true;
		}
	}
	/**
	 * Initialisation de la video
	 */
	private function _initVideo()
	{
		this._nc = new NetConnection();
		this._nc.connect(null);
		
		this._ns = new NetStream(this._nc);
		this._ns.setBufferTime(this._bufferTime);
		_ns["parent"] = this;
		this._ns.onStatus = function(info:Object){
			switch(info.code){
				case "NetStream.Buffer.Empty":
					if(Math.abs(Math.floor(this.time) - Math.floor(this.parent._videoDuration)) < 2){
						// la vidéo est terminée
						this.parent._template.stopRelease();
						if(this.parent._loop){
							this.parent._template.playRelease();
						}
					}
					break;
				case 'NetStream.Buffer.Full' :
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
		
		// Lissage
		this._template.video.video.smoothing = true;
		
		// Gestion du son
		this._sound = new Sound();
		this._sound.attachSound(this._template.video.video);
	}
	/*===================== FIN = METHODES PRIVEES = FIN =====================*/
	/*========================================================================*/
	
	/*========================== METHODES PUBLIQUES ==========================*/
	/*========================================================================*/
	/**
	 * Jouer	 */
	public function play()
	{
		// Si le NetConnection et le NetStream ne sont pas encore créés
		if (!this._nc && !this._ns) {
			this._firstPlay = false;
			this._initVideo();
		}
		
		if (!this._firstPlay) {
			this._ns.play(this._videoUrl);
			
			this._firstPlay = true;
		} else {
			this._ns.pause();
		}
		
		this.isPlaying = true;
	}
	/**
	 * Pause
	 */
	public function pause()
	{
		this._ns.pause();
		this.isPlaying = false;
	}
	/**
	 * Stopper
	 */
	public function stop()
	{
		this._ns.seek(0);
		if (this.isPlaying) {
			this._ns.pause();
		}
		this.isPlaying = false;
		
		// Détruire le chargement de la vidéo
		if (_root.loadonstop == 0) {
			delete this._ns;
			delete this._nc;
		}
	}
	/**
	 * Déplacer la tête de lecture
	 * 
	 * @param pPosition La position	 */
	public function setPosition(pPosition:Number)
	{
		if (pPosition < 0) {
			pPosition = 0;
		}
		if (pPosition > this._videoDuration) {
			pPosition = this._videoDuration;
		}
		this._ns.seek(pPosition);
	}
	/**
	 * Récupère la position de la tête de lecture
	 * 
	 * @return La position	 */
	public function getPosition():Number
	{
		if (this._ns.time > this._videoDuration) {
			return this._videoDuration;
		} else if (this._ns.time < 0) {
			return 0;
		} else if (this._ns.time > this._videoDuration) {
			return this._videoDuration;
		} else {
			return this._ns.time;
		}
	}
	/**
	 * Récupère la durée de la vidéo
	 * 
	 * @return La durée	 */
	public function getDuration():Number
	{
		return this._videoDuration;
	}
	/**
	 * Récupère la taille du tampon
	 * 
	 * @return La taille du tampon	 */
	public function getBufferLength():Number
	{
		return this._ns.bufferLength;
	}
	/**
	 * Récupère la taille maximale du tampon
	 * 
	 * @return La taille maximale du tampon	 */
	public function getBufferTime():Number
	{
		return this._ns.bufferTime;
	}
	/**
	 * Récupère les informations sur le chargement de la video
	 * 
	 * - loaded: Le nombre de bytes chargés
	 * - total: Le nombre de bytes à chargés
	 * - precent: Le pourcentage entre les 2
	 * 
	 * @return L'objet contenant les informations
	 */
	public function getLoading():Object
	{
		var loaded:Number = this._ns.bytesLoaded;
		var total:Number = this._ns.bytesTotal;
		var percent:Number = Math.round(loaded / total * 100); 
		return {loaded:loaded, total:total, percent:percent};
	}
	/*==================== FIN = METHODES PUBLIQUES = FIN ====================*/
	/*========================================================================*/
}