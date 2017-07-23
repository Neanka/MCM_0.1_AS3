//Created by Action Script Viewer - http://www.buraks.com/asv
package scaleform.clik.utils
{
    import flash.display.DisplayObject;

    public class ConstrainedElement 
    {

        public var clip:DisplayObject;
        public var edges:uint;
        public var left:Number;
        public var top:Number;
        public var right:Number;
        public var bottom:Number;
        public var scaleX:Number;
        public var scaleY:Number;

        public function ConstrainedElement(clip:DisplayObject, edges:uint, left:Number, top:Number, right:Number, bottom:Number, scaleX:Number, scaleY:Number)
        {
            this.clip = clip;
            this.edges = edges;
            this.left = left;
            this.top = top;
            this.right = right;
            this.bottom = bottom;
            this.scaleX = scaleX;
            this.scaleY = scaleY;
        }

        public function toString():String
        {
            return ((((((((((((((((("[ConstrainedElement " + this.clip) + ", edges=") + this.edges) + ", left=") + this.left) + ", right=") + this.right) + ", top=") + this.top) + ", bottom=") + this.bottom) + ", scaleX=") + this.scaleX) + ", scaleY=") + this.scaleY) + "]"));
        }


    }
}//package scaleform.clik.utils
