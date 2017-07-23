//Created by Action Script Viewer - http://www.buraks.com/asv
package scaleform.clik.layout
{
    import flash.utils.Dictionary;

    public class LayoutData 
    {

        public static const ASPECT_RATIO_4_3:String = "4:3";
        public static const ASPECT_RATIO_16_9:String = "16:9";
        public static const ASPECT_RATIO_16_10:String = "16:10";

        public var alignH:String = null;
        public var alignV:String = null;
        public var offsetH:int = -1;
        public var offsetV:int = -1;
        public var offsetHashH:Dictionary = null;
        public var offsetHashV:Dictionary = null;
        public var relativeToH:String = null;
        public var relativeToV:String = null;
        public var layoutIndex:int = -1;
        public var layoutIdentifier:String = null;

        public function LayoutData(_alignH:String="none", _alignV:String="none", _offsetH:int=-1, _offsetV:int=-1, _relativeToH:String=null, _relativeToV:String=null, _layoutIndex:int=-1, _layoutIdentifer:String=null)
        {
            this.alignH = _alignH;
            this.alignV = _alignV;
            this.offsetH = _offsetH;
            this.offsetV = _offsetV;
            this.relativeToH = _relativeToH;
            this.relativeToV = _relativeToV;
            this.layoutIndex = _layoutIndex;
            this.layoutIdentifier = _layoutIdentifer;
            this.offsetHashH = new Dictionary();
            this.offsetHashV = new Dictionary();
        }

        public function toString():String
        {
            return ((((((((((((((("[LayoutData, h: " + this.alignH) + ", v: ") + this.alignV) + ", oh: ") + this.offsetH) + ", ov: ") + this.offsetV) + ", relh: ") + this.relativeToH) + ", relv: ") + this.relativeToV) + ", idx: ") + this.layoutIndex) + "]"));
        }


    }
}//package scaleform.clik.layout
