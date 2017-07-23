// Decompiled by AS3 Sorcerer 4.04
// www.as3sorcerer.com

//Shared.PlatformRequestEvent

package Shared
{
    import flash.events.Event;
    import flash.display.MovieClip;

    public class PlatformRequestEvent extends Event 
    {

        public static const PLATFORM_REQUEST:String = "GetPlatform";

        var _target:MovieClip;

        public function PlatformRequestEvent(_arg_1:MovieClip)
        {
            super(PLATFORM_REQUEST);
            this._target = _arg_1;
        }

        public function RespondToRequest(_arg_1:uint, _arg_2:Boolean)
        {
            this._target.SetPlatform(_arg_1, _arg_2);
        }


    }
}//package Shared

