// Decompiled by AS3 Sorcerer 4.04
// www.as3sorcerer.com

//Shared.GlobalFunc

package Shared
{
    import flash.text.TextField;
    import flash.text.TextFormat;
    import scaleform.gfx.Extensions;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.events.Event;

    public class GlobalFunc 
    {

        public static const PIPBOY_GREY_OUT_ALPHA:Number = 0.5;
        public static const SELECTED_RECT_ALPHA:Number = 1;
        public static const DIMMED_ALPHA:Number = 0.65;
        public static const NUM_DAMAGE_TYPES:uint = 6;
        protected static const CLOSE_ENOUGH_EPSILON:Number = 0.001;
        public static const MAX_TRUNCATED_TEXT_LENGTH = 42;
        public static const PLAY_FOCUS_SOUND:String = "GlobalFunc::playFocusSound";


        public static function Lerp(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:Boolean):Number
        {
            var _local_7:Number = (_arg_1 + (((_arg_5 - _arg_3) / (_arg_4 - _arg_3)) * (_arg_2 - _arg_1)));
            if (_arg_6)
            {
                if (_arg_1 < _arg_2)
                {
                    _local_7 = Math.min(Math.max(_local_7, _arg_1), _arg_2);
                } else
                {
                    _local_7 = Math.min(Math.max(_local_7, _arg_2), _arg_1);
                };
            };
            return (_local_7);
        }

        public static function RoundDecimal(_arg_1:Number, _arg_2:Number):Number
        {
            var _local_3:Number = Math.pow(10, _arg_2);
            return ((Math.round((_local_3 * _arg_1)) / _local_3));
        }

        public static function CloseToNumber(_arg_1:Number, _arg_2:Number):Boolean
        {
            return ((Math.abs((_arg_1 - _arg_2)) < CLOSE_ENOUGH_EPSILON));
        }

        public static function MaintainTextFormat()
        {
            TextField.prototype.SetText = function (_arg_1:String, _arg_2:Boolean, _arg_3:Boolean=false)
            {
                var _local_5:Number;
                var _local_6:Boolean;
                if ((((!(_arg_1))) || ((_arg_1 == ""))))
                {
                    _arg_1 = " ";
                };
                if (((_arg_3) && ((!((_arg_1.charAt(0) == "$"))))))
                {
                    _arg_1 = _arg_1.toUpperCase();
                };
                var _local_4:TextFormat = this.getTextFormat();
                if (_arg_2)
                {
                    _local_5 = Number(_local_4.letterSpacing);
                    _local_6 = _local_4.kerning;
                    this.htmlText = _arg_1;
                    _local_4 = this.getTextFormat();
                    _local_4.letterSpacing = _local_5;
                    _local_4.kerning = _local_6;
                    this.setTextFormat(_local_4);
                    this.htmlText = _arg_1;
                } else
                {
                    this.text = _arg_1;
                    this.setTextFormat(_local_4);
                    this.text = _arg_1;
                };
            };
        }

        public static function SetText(_arg_1:TextField, _arg_2:String, _arg_3:Boolean, _arg_4:Boolean=false, _arg_5:*=false)
        {
            var _local_6:TextFormat;
            var _local_7:Number;
            var _local_8:Boolean;
            if ((((!(_arg_2))) || ((_arg_2 == ""))))
            {
                _arg_2 = " ";
            };
            if (((_arg_4) && ((!((_arg_2.charAt(0) == "$"))))))
            {
                _arg_2 = _arg_2.toUpperCase();
            };
            if (_arg_3)
            {
                _local_6 = _arg_1.getTextFormat();
                _local_7 = Number(_local_6.letterSpacing);
                _local_8 = _local_6.kerning;
                _arg_1.htmlText = _arg_2;
                _local_6 = _arg_1.getTextFormat();
                _local_6.letterSpacing = _local_7;
                _local_6.kerning = _local_8;
                _arg_1.setTextFormat(_local_6);
            } else
            {
                _arg_1.text = _arg_2;
            };
            if (((_arg_5) && ((_arg_1.text.length > MAX_TRUNCATED_TEXT_LENGTH))))
            {
                _arg_1.text = (_arg_1.text.slice(0, (MAX_TRUNCATED_TEXT_LENGTH - 3)) + "...");
            };
        }

        public static function LockToSafeRect(_arg_1:DisplayObject, _arg_2:String, _arg_3:Number=0, _arg_4:Number=0)
        {
            var _local_5:Rectangle = Extensions.visibleRect;
            var _local_6:Point = new Point((_local_5.x + _arg_3), (_local_5.y + _arg_4));
            var _local_7:Point = new Point(((_local_5.x + _local_5.width) - _arg_3), ((_local_5.y + _local_5.height) - _arg_4));
            var _local_8:Point = _arg_1.parent.globalToLocal(_local_6);
            var _local_9:Point = _arg_1.parent.globalToLocal(_local_7);
            var _local_10:Point = Point.interpolate(_local_8, _local_9, 0.5);
            if ((((((((_arg_2 == "T")) || ((_arg_2 == "TL")))) || ((_arg_2 == "TR")))) || ((_arg_2 == "TC"))))
            {
                _arg_1.y = _local_8.y;
            };
            if ((((((_arg_2 == "CR")) || ((_arg_2 == "CC")))) || ((_arg_2 == "CL"))))
            {
                _arg_1.y = _local_10.y;
            };
            if ((((((((_arg_2 == "B")) || ((_arg_2 == "BL")))) || ((_arg_2 == "BR")))) || ((_arg_2 == "BC"))))
            {
                _arg_1.y = _local_9.y;
            };
            if ((((((((_arg_2 == "L")) || ((_arg_2 == "TL")))) || ((_arg_2 == "BL")))) || ((_arg_2 == "CL"))))
            {
                _arg_1.x = _local_8.x;
            };
            if ((((((_arg_2 == "TC")) || ((_arg_2 == "CC")))) || ((_arg_2 == "BC"))))
            {
                _arg_1.x = _local_10.x;
            };
            if ((((((((_arg_2 == "R")) || ((_arg_2 == "TR")))) || ((_arg_2 == "BR")))) || ((_arg_2 == "CR"))))
            {
                _arg_1.x = _local_9.x;
            };
        }

        public static function AddMovieExploreFunctions()
        {
            MovieClip.prototype.getMovieClips = function ():Array
            {
                var _local_2:*;
                var _local_1:* = new Array();
                for (_local_2 in this)
                {
                    if ((((this[_local_2] is MovieClip)) && ((!((this[_local_2] == this))))))
                    {
                        _local_1.push(this[_local_2]);
                    };
                };
                return (_local_1);
            };
            MovieClip.prototype.showMovieClips = function ()
            {
                var _local_1:*;
                for (_local_1 in this)
                {
                    if ((((this[_local_1] is MovieClip)) && ((!((this[_local_1] == this))))))
                    {
                        trace(this[_local_1]);
                        this[_local_1].showMovieClips();
                    };
                };
            };
        }

        public static function AddReverseFunctions()
        {
            MovieClip.prototype.PlayReverseCallback = function (_arg_1:Event)
            {
                if (_arg_1.currentTarget.currentFrame > 1)
                {
                    _arg_1.currentTarget.gotoAndStop((_arg_1.currentTarget.currentFrame - 1));
                } else
                {
                    _arg_1.currentTarget.removeEventListener(Event.ENTER_FRAME, _arg_1.currentTarget.PlayReverseCallback);
                };
            };
            MovieClip.prototype.PlayReverse = function ()
            {
                if (this.currentFrame > 1)
                {
                    this.gotoAndStop((this.currentFrame - 1));
                    this.addEventListener(Event.ENTER_FRAME, this.PlayReverseCallback);
                } else
                {
                    this.gotoAndStop(1);
                };
            };
            MovieClip.prototype.PlayForward = function (_arg_1:String)
            {
                delete this.onEnterFrame;
                this.gotoAndPlay(_arg_1);
            };
            MovieClip.prototype.PlayForward = function (_arg_1:Number)
            {
                delete this.onEnterFrame;
                this.gotoAndPlay(_arg_1);
            };
        }

        public static function StringTrim(_arg_1:String):String
        {
            var _local_5:String;
            var _local_2:Number = 0;
            var _local_3:Number = 0;
            var _local_4:Number = _arg_1.length;
            while ((((((((_arg_1.charAt(_local_2) == " ")) || ((_arg_1.charAt(_local_2) == "\n")))) || ((_arg_1.charAt(_local_2) == "\r")))) || ((_arg_1.charAt(_local_2) == "\t"))))
            {
                _local_2++;
            };
            _local_5 = _arg_1.substring(_local_2);
            _local_3 = (_local_5.length - 1);
            while ((((((((_local_5.charAt(_local_3) == " ")) || ((_local_5.charAt(_local_3) == "\n")))) || ((_local_5.charAt(_local_3) == "\r")))) || ((_local_5.charAt(_local_3) == "\t"))))
            {
                _local_3--;
            };
            _local_5 = _local_5.substring(0, (_local_3 + 1));
            return (_local_5);
        }


    }
}//package Shared

