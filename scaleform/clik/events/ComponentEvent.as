//Created by Action Script Viewer - http://www.buraks.com/asv
package scaleform.clik.events
{
    import flash.events.Event;

    public class ComponentEvent extends Event 
    {

        public static const STATE_CHANGE:String = "stateChange";
        public static const SHOW:String = "show";
        public static const HIDE:String = "hide";

        public function ComponentEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=true)
        {
            super(type, bubbles, cancelable);
        }

    }
}//package scaleform.clik.events
