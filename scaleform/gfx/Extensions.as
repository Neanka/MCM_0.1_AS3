﻿package scaleform.gfx
{
    import flash.display.DisplayObject;
    import flash.geom.Rectangle;
    import flash.text.TextField;

    public final class Extensions 
    {

        public static const EDGEAA_INHERIT:uint = 0;
        public static const EDGEAA_ON:uint = 1;
        public static const EDGEAA_OFF:uint = 2;
        public static const EDGEAA_DISABLE:uint = 3;

        public static var isGFxPlayer:Boolean = false;
        public static var CLIK_addedToStageCallback:Function;
        public static var gfxProcessSound:Function;


        public static function set enabled(value:Boolean):void
        {
        }

        public static function get enabled():Boolean
        {
            return (false);
        }

        public static function set noInvisibleAdvance(value:Boolean):void
        {
        }

        public static function get noInvisibleAdvance():Boolean
        {
            return (false);
        }

        public static function getTopMostEntity(x:Number, y:Number, testAll:Boolean=true):DisplayObject
        {
            return (null);
        }

        public static function getMouseTopMostEntity(testAll:Boolean=true, mouseIndex:uint=0):DisplayObject
        {
            return (null);
        }

        public static function setMouseCursorType(cursor:String, mouseIndex:uint=0):void
        {
        }

        public static function getMouseCursorType(mouseIndex:uint=0):String
        {
            return ("");
        }

        public static function get numControllers():uint
        {
            return (1);
        }

        public static function get visibleRect():Rectangle
        {
            return (new Rectangle(0, 0, 0, 0));
        }

        public static function getEdgeAAMode(dispObj:DisplayObject):uint
        {
            return (EDGEAA_INHERIT);
        }

        public static function setEdgeAAMode(dispObj:DisplayObject, mode:uint):void
        {
        }

        public static function setIMEEnabled(textField:TextField, isEnabled:Boolean):void
        {
        }

        public static function get isScaleform():Boolean
        {
            return (false);
        }


    }
}//package scaleform.gfx
