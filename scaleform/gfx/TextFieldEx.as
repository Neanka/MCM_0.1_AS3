package scaleform.gfx
{
    import flash.text.TextField;
    import flash.display.BitmapData;

    public final class TextFieldEx extends InteractiveObjectEx 
    {

        public static const VALIGN_NONE:String = "none";
        public static const VALIGN_TOP:String = "top";
        public static const VALIGN_CENTER:String = "center";
        public static const VALIGN_BOTTOM:String = "bottom";
        public static const TEXTAUTOSZ_NONE:String = "none";
        public static const TEXTAUTOSZ_SHRINK:String = "shrink";
        public static const TEXTAUTOSZ_FIT:String = "fit";
        public static const VAUTOSIZE_NONE:String = "none";
        public static const VAUTOSIZE_TOP:String = "top";
        public static const VAUTOSIZE_CENTER:String = "center";
        public static const VAUTOSIZE_BOTTOM:String = "bottom";


        public static function appendHtml(textField:TextField, newHtml:String):void
        {
        }

        public static function setIMEEnabled(textField:TextField, isEnabled:Boolean):void
        {
        }

        public static function setVerticalAlign(textField:TextField, valign:String):void
        {
        }

        public static function getVerticalAlign(textField:TextField):String
        {
            return ("none");
        }

        public static function setVerticalAutoSize(textField:TextField, vautoSize:String):void
        {
        }

        public static function getVerticalAutoSize(textField:TextField):String
        {
            return ("none");
        }

        public static function setTextAutoSize(textField:TextField, autoSz:String):void
        {
        }

        public static function getTextAutoSize(textField:TextField):String
        {
            return ("none");
        }

        public static function setImageSubstitutions(textField:TextField, substInfo:Object):void
        {
        }

        public static function updateImageSubstitution(textField:TextField, id:String, image:BitmapData):void
        {
        }

        public static function setNoTranslate(textField:TextField, noTranslate:Boolean):void
        {
        }

        public static function getNoTranslate(textField:TextField):Boolean
        {
            return (false);
        }

        public static function setBidirectionalTextEnabled(textField:TextField, en:Boolean):void
        {
        }

        public static function getBidirectionalTextEnabled(textField:TextField):Boolean
        {
            return (false);
        }

        public static function setSelectionTextColor(textField:TextField, selColor:uint):void
        {
        }

        public static function getSelectionTextColor(textField:TextField):uint
        {
            return (0xFFFFFFFF);
        }

        public static function setSelectionBkgColor(textField:TextField, selColor:uint):void
        {
        }

        public static function getSelectionBkgColor(textField:TextField):uint
        {
            return (0xFF000000);
        }

        public static function setInactiveSelectionTextColor(textField:TextField, selColor:uint):void
        {
        }

        public static function getInactiveSelectionTextColor(textField:TextField):uint
        {
            return (0xFFFFFFFF);
        }

        public static function setInactiveSelectionBkgColor(textField:TextField, selColor:uint):void
        {
        }

        public static function getInactiveSelectionBkgColor(textField:TextField):uint
        {
            return (0xFF000000);
        }


    }
}//package scaleform.gfx
