package
{
import flash.display.*;
import flash.events.*;
import flash.utils.*;

/**
 * The preload
 */
public class Preload extends MovieClip
{
    /**
     * Constructor
     */
    public function Preload()
    {
        super();
        this.addEventListener(Event.ENTER_FRAME, this._enterFrame);
    }

    /**
     * The enterframe event handler
     * 
     * @param   event       The event
     */
    protected function _enterFrame(event:Event):void
    {
        if (!(stage.stageWidth > 0)) {
            return;
        }

        //var bytesLoaded:Number = this.root.loaderInfo.bytesLoaded;
        //var bytesTotal:Number = this.root.loaderInfo.bytesTotal;

        if (this.framesLoaded == this.totalFrames) {
            this.removeEventListener(Event.ENTER_FRAME, this._enterFrame);
            this.nextFrame();
            var mainClass:Class = getDefinitionByName("FLVPlayer") as Class;
            var app:Object = new mainClass();
            this.addChild(DisplayObject(app));
        }
    }
}
}
