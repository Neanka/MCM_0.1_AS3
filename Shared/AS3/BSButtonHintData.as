// Decompiled by AS3 Sorcerer 4.04
// www.as3sorcerer.com

//Shared.AS3.BSButtonHintData

package Shared.AS3
{
    import flash.events.EventDispatcher;
    import flash.events.Event;

    public dynamic class BSButtonHintData extends EventDispatcher 
    {

        public static const BUTTON_HINT_DATA_CHANGE:String = "ButtonHintDataChange";

        private var _strButtonText:String;
        private var _strPCKey:String;
        private var _strPSNButton:String;
        private var _strXenonButton:String;
        private var _uiJustification:uint;
        private var _callbackFunction:Function;
        private var _bButtonDisabled:Boolean;
        private var _bSecondaryButtonDisabled:Boolean;
        private var _bButtonVisible:Boolean;
        private var _bButtonFlashing:Boolean;
        private var _hasSecondaryButton:Boolean;
        private var _strSecondaryPCKey:String;
        private var _strSecondaryXenonButton:String;
        private var _strSecondaryPSNButton:String;
        private var _secondaryButtonCallback:Function;
        private var _strDynamicMovieClipName:String;
        public var onAnnounceDataChange:Function;
        public var onTextClick:Function;
        public var onSecondaryButtonClick:Function;

        public function BSButtonHintData(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:String, _arg_5:uint, _arg_6:Function)
        {
            this.onAnnounceDataChange = this.onAnnounceDataChange_Impl;
            this.onTextClick = this.onTextClick_Impl;
            this.onSecondaryButtonClick = this.onSecondaryButtonClick_Impl;
            super();
            this._strPCKey = _arg_2;
            this._strButtonText = _arg_1;
            this._strXenonButton = _arg_4;
            this._strPSNButton = _arg_3;
            this._uiJustification = _arg_5;
            this._callbackFunction = _arg_6;
            this._bButtonDisabled = false;
            this._bButtonVisible = true;
            this._bButtonFlashing = false;
            this._hasSecondaryButton = false;
            this._strSecondaryPCKey = "";
            this._strSecondaryPSNButton = "";
            this._strSecondaryXenonButton = "";
            this._secondaryButtonCallback = null;
            this._strDynamicMovieClipName = "";
        }

        public function get PCKey():String
        {
            return (this._strPCKey);
        }

        public function get PSNButton():String
        {
            return (this._strPSNButton);
        }

        public function get XenonButton():String
        {
            return (this._strXenonButton);
        }

        public function get Justification():uint
        {
            return (this._uiJustification);
        }

        public function get SecondaryPCKey():String
        {
            return (this._strSecondaryPCKey);
        }

        public function get SecondaryPSNButton():String
        {
            return (this._strSecondaryPSNButton);
        }

        public function get SecondaryXenonButton():String
        {
            return (this._strSecondaryXenonButton);
        }

        public function get DynamicMovieClipName():String
        {
            return (this._strDynamicMovieClipName);
        }

        public function set DynamicMovieClipName(_arg_1:String):void
        {
            if (this._strDynamicMovieClipName != _arg_1)
            {
                this._strDynamicMovieClipName = _arg_1;
                this.AnnounceDataChange();
            };
        }

        public function get ButtonDisabled():Boolean
        {
            return (this._bButtonDisabled);
        }

        public function set ButtonDisabled(_arg_1:Boolean)
        {
            if (this._bButtonDisabled != _arg_1)
            {
                this._bButtonDisabled = _arg_1;
                this.AnnounceDataChange();
            };
        }

        public function get ButtonEnabled():Boolean
        {
            return ((!(this.ButtonDisabled)));
        }

        public function set ButtonEnabled(_arg_1:Boolean):void
        {
            this.ButtonDisabled = (!(_arg_1));
        }

        public function get SecondaryButtonDisabled():Boolean
        {
            return (this._bSecondaryButtonDisabled);
        }

        public function set SecondaryButtonDisabled(_arg_1:Boolean)
        {
            if (this._bSecondaryButtonDisabled != _arg_1)
            {
                this._bSecondaryButtonDisabled = _arg_1;
                this.AnnounceDataChange();
            };
        }

        public function get SecondaryButtonEnabled():Boolean
        {
            return ((!(this.SecondaryButtonDisabled)));
        }

        public function set SecondaryButtonEnabled(_arg_1:Boolean):void
        {
            this.SecondaryButtonDisabled = (!(_arg_1));
        }

        public function get ButtonText():String
        {
            return (this._strButtonText);
        }

        public function set ButtonText(_arg_1:String):void
        {
            if (this._strButtonText != _arg_1)
            {
                this._strButtonText = _arg_1;
                this.AnnounceDataChange();
            };
        }

        public function get ButtonVisible():Boolean
        {
            return (this._bButtonVisible);
        }

        public function set ButtonVisible(_arg_1:Boolean):void
        {
            if (this._bButtonVisible != _arg_1)
            {
                this._bButtonVisible = _arg_1;
                this.AnnounceDataChange();
            };
        }

        public function get ButtonFlashing():Boolean
        {
            return (this._bButtonFlashing);
        }

        public function set ButtonFlashing(_arg_1:Boolean):void
        {
            if (this._bButtonFlashing != _arg_1)
            {
                this._bButtonFlashing = _arg_1;
                this.AnnounceDataChange();
            };
        }

        public function get hasSecondaryButton():Boolean
        {
            return (this._hasSecondaryButton);
        }

        private function AnnounceDataChange():void
        {
            dispatchEvent(new Event(BUTTON_HINT_DATA_CHANGE));
            if ((this.onAnnounceDataChange is Function))
            {
                this.onAnnounceDataChange();
            };
        }

        private function onAnnounceDataChange_Impl():void
        {
        }

        public function SetButtons(_arg_1:String, _arg_2:String, _arg_3:String)
        {
            var _local_4:Boolean;
            if (this._strPCKey != _arg_1)
            {
                this._strPCKey = _arg_1;
                _local_4 = true;
            };
            if (this._strPSNButton != _arg_2)
            {
                this._strPSNButton = _arg_2;
                _local_4 = true;
            };
            if (this._strXenonButton != _arg_3)
            {
                this._strXenonButton = _arg_3;
                _local_4 = true;
            };
            if (_local_4)
            {
                this.AnnounceDataChange();
            };
        }

        public function SetSecondaryButtons(_arg_1:String, _arg_2:String, _arg_3:String)
        {
            this._hasSecondaryButton = true;
            var _local_4:Boolean;
            if (this._strSecondaryPCKey != _arg_1)
            {
                this._strSecondaryPCKey = _arg_1;
                _local_4 = true;
            };
            if (this._strSecondaryPSNButton != _arg_2)
            {
                this._strSecondaryPSNButton = _arg_2;
                _local_4 = true;
            };
            if (this._strSecondaryXenonButton != _arg_3)
            {
                this._strSecondaryXenonButton = _arg_3;
                _local_4 = true;
            };
            if (_local_4)
            {
                this.AnnounceDataChange();
            };
        }

        public function set secondaryButtonCallback(_arg_1:Function)
        {
            this._secondaryButtonCallback = _arg_1;
        }

        private function onTextClick_Impl():void
        {
            if ((this._callbackFunction is Function))
            {
                this._callbackFunction.call();
            };
        }

        private function onSecondaryButtonClick_Impl():void
        {
            if ((this._secondaryButtonCallback is Function))
            {
                this._secondaryButtonCallback.call();
            };
        }


    }
}//package Shared.AS3

