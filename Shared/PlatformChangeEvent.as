// Decompiled by AS3 Sorcerer 4.04
// www.as3sorcerer.com

//Shared.PlatformChangeEvent

package Shared
{
    import flash.events.Event;

    public class PlatformChangeEvent extends Event 
    {

        public static const PLATFORM_PC_KB_MOUSE:uint = 0;
        public static const PLATFORM_PC_GAMEPAD:uint = 1;
        public static const PLATFORM_XB1:uint = 2;
        public static const PLATFORM_PS4:uint = 3;
        public static const PLATFORM_MOBILE:uint = 4;
        public static const PLATFORM_INVALID:uint = uint.MAX_VALUE;//0xFFFFFFFF
        public static const PLATFORM_CHANGE:String = "SetPlatform";

        var _uiPlatform:uint = 0xFFFFFFFF;
        var _bPS3Switch:Boolean = false;

        public function PlatformChangeEvent(_arg_1:uint, _arg_2:Boolean)
        {
            super(PLATFORM_CHANGE, true, true);
            this.uiPlatform = _arg_1;
            this.bPS3Switch = _arg_2;
        }

        public function get uiPlatform()
        {
            return (this._uiPlatform);
        }

        public function set uiPlatform(_arg_1:uint)
        {
            this._uiPlatform = _arg_1;
        }

        public function get bPS3Switch()
        {
            return (this._bPS3Switch);
        }

        public function set bPS3Switch(_arg_1:Boolean)
        {
            this._bPS3Switch = _arg_1;
        }


    }
}//package Shared

