//Created by Action Script Viewer - http://www.buraks.com/asv
package scaleform.clik.events
{
    import flash.events.Event;

    public final class FocusHandlerEvent extends Event 
    {

        public static const FOCUS_IN:String = "CLIK_focusIn";
        public static const FOCUS_OUT:String = "CLIK_focusOut";

        public var controllerIdx:uint = 0;

        public function FocusHandlerEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false, controllerIdx:uint=0)
        {
            super(type, bubbles, cancelable);
            this.controllerIdx = controllerIdx;
        }

        override public function clone():Event
        {
            return (new FocusHandlerEvent(type, bubbles, cancelable, this.controllerIdx));
        }

        override public function toString():String
        {
            return (formatToString("FocusHandlerEvent", "type", "bubbles", "cancelable", "controllerIdx"));
        }


    }
}//package scaleform.clik.events
