// Decompiled by AS3 Sorcerer 4.04
// www.as3sorcerer.com

//Shared.IMenu

package Shared
{
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.display.InteractiveObject;
    import flash.text.TextFormat;
    import flash.text.TextField;

    public class IMenu extends MovieClip 
    {

        private var _uiPlatform:uint;
        private var _bPS3Switch:Boolean;
        private var _bRestoreLostFocus:Boolean;
        private var safeX:Number = 0;
        private var safeY:Number = 0;
        private var textFieldSizeMap:Object;

        public function IMenu()
        {
            this.textFieldSizeMap = new Object();
            super();
            this._uiPlatform = PlatformChangeEvent.PLATFORM_INVALID;
            this._bPS3Switch = false;
            this._bRestoreLostFocus = false;
            GlobalFunc.MaintainTextFormat();
            addEventListener(Event.ADDED_TO_STAGE, this.onStageInit);
            addEventListener(Event.REMOVED_FROM_STAGE, this.onStageDestruct);
            addEventListener(PlatformRequestEvent.PLATFORM_REQUEST, this.onPlatformRequestEvent, true);
        }

        public function get uiPlatform():uint
        {
            return (this._uiPlatform);
        }

        public function get bPS3Switch():Boolean
        {
            return (this._bPS3Switch);
        }

        public function get SafeX():Number
        {
            return (this.safeX);
        }

        public function get SafeY():Number
        {
            return (this.safeY);
        }

        protected function onPlatformRequestEvent(_arg_1:Event)
        {
            if (this.uiPlatform != PlatformChangeEvent.PLATFORM_INVALID)
            {
                (_arg_1 as PlatformRequestEvent).RespondToRequest(this.uiPlatform, this.bPS3Switch);
            };
        }

        protected function onStageInit(_arg_1:Event)
        {
            stage.stageFocusRect = false;
            stage.addEventListener(FocusEvent.FOCUS_OUT, this.onFocusLost);
            stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, this.onMouseFocus);
        }

        protected function onStageDestruct(_arg_1:Event)
        {
            stage.removeEventListener(FocusEvent.FOCUS_OUT, this.onFocusLost);
            stage.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, this.onMouseFocus);
        }

        public function SetPlatform(_arg_1:uint, _arg_2:Boolean)
        {
            this._uiPlatform = _arg_1;
            this._bPS3Switch = this.bPS3Switch;
            dispatchEvent(new PlatformChangeEvent(this.uiPlatform, this.bPS3Switch));
        }

        public function SetSafeRect(_arg_1:Number, _arg_2:Number)
        {
            this.safeX = _arg_1;
            this.safeY = _arg_2;
            this.onSetSafeRect();
        }

        protected function onSetSafeRect():void
        {
        }

        private function onFocusLost(_arg_1:FocusEvent)
        {
            if (this._bRestoreLostFocus)
            {
                this._bRestoreLostFocus = false;
                stage.focus = (_arg_1.target as InteractiveObject);
            };
        }

        protected function onMouseFocus(_arg_1:FocusEvent)
        {
            if ((((_arg_1.target == null)) || ((!((_arg_1.target is InteractiveObject))))))
            {
                stage.focus = null;
            } else
            {
                this._bRestoreLostFocus = true;
            };
        }

        public function ShrinkFontToFit(_arg_1:TextField, _arg_2:int)
        {
            var _local_5:int;
            var _local_3:TextFormat = _arg_1.getTextFormat();
            if (this.textFieldSizeMap[_arg_1] == null)
            {
                this.textFieldSizeMap[_arg_1] = _local_3.size;
            };
            _local_3.size = this.textFieldSizeMap[_arg_1];
            _arg_1.setTextFormat(_local_3);
            var _local_4:int = _arg_1.maxScrollV;
            while ((((_local_4 > _arg_2)) && ((_local_3.size > 4))))
            {
                _local_5 = (_local_3.size as int);
                _local_3.size = (_local_5 - 1);
                _arg_1.setTextFormat(_local_3);
                _local_4 = _arg_1.maxScrollV;
            };
        }


    }
}//package Shared

