//Created by Action Script Viewer - http://www.buraks.com/asv
package scaleform.clik.ui
{
    public class InputDetails 
    {

        public var type:String;
        public var code:Number;
        public var value;
        public var navEquivalent:String;
        public var controllerIndex:uint;
        public var ctrlKey:Boolean;
        public var altKey:Boolean;
        public var shiftKey:Boolean;

        public function InputDetails(type:String, code:Number, value, navEquivalent:String=null, controllerIndex:uint=0, ctrlKey:Boolean=false, altKey:Boolean=false, shiftKey:Boolean=false)
        {
            this.type = type;
            this.code = code;
            this.value = value;
            this.navEquivalent = navEquivalent;
            this.controllerIndex = controllerIndex;
            this.ctrlKey = ctrlKey;
            this.altKey = altKey;
            this.shiftKey = shiftKey;
        }

        public function toString():String
        {
            return ((((((((((((((((("[InputDetails code=" + this.code) + ", type=") + this.type) + " value=") + this.value) + ", navEquivalent=") + this.navEquivalent) + ", controllerIndex=") + this.controllerIndex) + ", ctrlKey=") + this.ctrlKey) + ", altKey=") + this.altKey) + ", shiftKey=") + this.shiftKey) + "]"));
        }


    }
}//package scaleform.clik.ui
