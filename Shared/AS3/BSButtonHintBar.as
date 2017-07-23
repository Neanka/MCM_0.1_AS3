// Decompiled by AS3 Sorcerer 4.04
// www.as3sorcerer.com

//Shared.AS3.BSButtonHintBar

package Shared.AS3
{
    import flash.display.MovieClip;
    import __AS3__.vec.Vector;
    import flash.events.Event;
    import Shared.AS3.COMPANIONAPP.CompanionAppMode;
    import Shared.AS3.COMPANIONAPP.MobileButtonHint;
    import flash.geom.Rectangle;
    import flash.display.Graphics;
    import __AS3__.vec.*;

    public dynamic class BSButtonHintBar extends BSUIComponent 
    {

        public var ButtonBracket_Left_mc:MovieClip;
        public var ButtonBracket_Right_mc:MovieClip;
        public var ShadedBackground_mc:MovieClip;
        private var ButtonHintBarInternal_mc:MovieClip;
        private var _buttonHintDataV:Vector.<BSButtonHintData>;
        private var ButtonPoolV:Vector.<BSButtonHint>;
        private var _bRedirectToButtonBarMenu:Boolean = true;
        private var _backgroundColor:uint = 0;
        private var _backgroundAlpha:Number = 1;
        private var _bShowBrackets_Override:Boolean = true;
        private var _bUseShadedBackground_Override:Boolean = true;
        public var SetButtonHintData:Function;

        public function BSButtonHintBar()
        {
            this.SetButtonHintData = this.SetButtonHintData_Impl;
            super();
            visible = false;
            this.ButtonHintBarInternal_mc = new MovieClip();
            addChild(this.ButtonHintBarInternal_mc);
            this._buttonHintDataV = new Vector.<BSButtonHintData>();
            this.ButtonPoolV = new Vector.<BSButtonHint>();
        }

        public function get bRedirectToButtonBarMenu():Boolean
        {
            return (this._bRedirectToButtonBarMenu);
        }

        public function set bRedirectToButtonBarMenu(_arg_1:Boolean)
        {
            if (this._bRedirectToButtonBarMenu != _arg_1)
            {
                this._bRedirectToButtonBarMenu = _arg_1;
                SetIsDirty();
            };
        }

        public function get BackgroundColor():uint
        {
            return (this._backgroundColor);
        }

        public function set BackgroundColor(_arg_1:uint)
        {
            if (this._backgroundColor != _arg_1)
            {
                this._backgroundColor = _arg_1;
                SetIsDirty();
            };
        }

        public function get BackgroundAlpha():Number
        {
            return (this._backgroundAlpha);
        }

        public function set BackgroundAlpha(_arg_1:Number)
        {
            if (this._backgroundAlpha != _arg_1)
            {
                this._backgroundAlpha = _arg_1;
            };
        }

        override public function get bShowBrackets():Boolean
        {
            return (this._bShowBrackets_Override);
        }

        override public function set bShowBrackets(_arg_1:Boolean)
        {
            this._bShowBrackets_Override = _arg_1;
            SetIsDirty();
        }

        override public function get bUseShadedBackground():Boolean
        {
            return (this._bUseShadedBackground_Override);
        }

        override public function set bUseShadedBackground(_arg_1:Boolean)
        {
            this._bUseShadedBackground_Override = _arg_1;
            SetIsDirty();
        }

        private function CanBeVisible():Boolean
        {
            return ((((!(this.bRedirectToButtonBarMenu))) || ((!(bAcquiredByNativeCode)))));
        }

        override public function onAcquiredByNativeCode()
        {
            var _local_1:Vector.<BSButtonHintData>;
            super.onAcquiredByNativeCode();
            if (this.bRedirectToButtonBarMenu)
            {
                this.SetButtonHintData(this._buttonHintDataV);
                _local_1 = new Vector.<BSButtonHintData>();
                this.SetButtonHintData_Impl(_local_1);
                SetIsDirty();
            };
        }

        private function SetButtonHintData_Impl(abuttonHintDataV:Vector.<BSButtonHintData>):void
        {
            this._buttonHintDataV.forEach(function (_arg_1:BSButtonHintData, _arg_2:int, _arg_3:Vector.<BSButtonHintData>)
            {
                if (_arg_1)
                {
                    _arg_1.removeEventListener(BSButtonHintData.BUTTON_HINT_DATA_CHANGE, this.onButtonHintDataDirtyEvent);
                };
            }, this);
            this._buttonHintDataV = abuttonHintDataV;
            this._buttonHintDataV.forEach(function (_arg_1:BSButtonHintData, _arg_2:int, _arg_3:Vector.<BSButtonHintData>)
            {
                if (_arg_1)
                {
                    _arg_1.addEventListener(BSButtonHintData.BUTTON_HINT_DATA_CHANGE, this.onButtonHintDataDirtyEvent);
                };
            }, this);
            this.CreateButtonHints();
        }

        public function onButtonHintDataDirtyEvent(_arg_1:Event):void
        {
            SetIsDirty();
        }

        private function CreateButtonHints()
        {
            visible = false;
            while (this.ButtonPoolV.length < this._buttonHintDataV.length)
            {
                if (CompanionAppMode.isOn)
                {
                    this.ButtonPoolV.push(new MobileButtonHint());
                } else
                {
                    this.ButtonPoolV.push(new BSButtonHint());
                };
            };
            var _local_1:int;
            while (_local_1 < this.ButtonPoolV.length)
            {
                this.ButtonPoolV[_local_1].ButtonHintData = (((_local_1 < this._buttonHintDataV.length)) ? this._buttonHintDataV[_local_1] : null);
                _local_1++;
            };
            SetIsDirty();
        }

        override public function redrawUIComponent():void
        {
            var _local_6:BSButtonHint;
            var _local_7:Rectangle;
            var _local_8:Graphics;
            super.redrawUIComponent();
            if (((this.ShadedBackground_mc) && (contains(this.ShadedBackground_mc))))
            {
                removeChild(this.ShadedBackground_mc);
            };
            var _local_1:* = false;
            var _local_2:Number = 0;
            var _local_3:Number = 0;
            if (CompanionAppMode.isOn)
            {
                _local_3 = (stage.stageWidth - 75);
            };
            var _local_4:Number = 0;
            while (_local_4 < this.ButtonPoolV.length)
            {
                _local_6 = this.ButtonPoolV[_local_4];
                if (((_local_6.ButtonVisible) && (this.CanBeVisible())))
                {
                    _local_1 = true;
                    if (!this.ButtonHintBarInternal_mc.contains(_local_6))
                    {
                        this.ButtonHintBarInternal_mc.addChild(_local_6);
                    };
                    if (_local_6.bIsDirty)
                    {
                        _local_6.redrawUIComponent();
                    };
                    if (((CompanionAppMode.isOn) && ((_local_6.Justification == BSButtonHint.JUSTIFY_RIGHT))))
                    {
                        _local_3 = (_local_3 - _local_6.width);
                        _local_6.x = _local_3;
                    } else
                    {
                        _local_6.x = _local_2;
                        _local_2 = (_local_2 + (_local_6.width + 20));
                    };
                } else
                {
                    if (this.ButtonHintBarInternal_mc.contains(_local_6))
                    {
                        this.ButtonHintBarInternal_mc.removeChild(_local_6);
                    };
                };
                _local_4++;
            };
            if (this.ButtonPoolV.length > this._buttonHintDataV.length)
            {
                this.ButtonPoolV.splice(this._buttonHintDataV.length, (this.ButtonPoolV.length - this._buttonHintDataV.length));
            };
            if (!CompanionAppMode.isOn)
            {
                this.ButtonHintBarInternal_mc.x = (-(this.ButtonHintBarInternal_mc.width) / 2);
            };
            var _local_5:Rectangle = this.ButtonHintBarInternal_mc.getBounds(this);
            this.ButtonBracket_Left_mc.x = (_local_5.left - this.ButtonBracket_Left_mc.width);
            this.ButtonBracket_Right_mc.x = _local_5.right;
            this.ButtonBracket_Left_mc.visible = ((this.bShowBrackets) && ((!(CompanionAppMode.isOn))));
            this.ButtonBracket_Right_mc.visible = ((this.bShowBrackets) && ((!(CompanionAppMode.isOn))));
            if ((((ShadedBackgroundMethod == "Flash")) && (this.bUseShadedBackground)))
            {
                if (!this.ShadedBackground_mc)
                {
                    this.ShadedBackground_mc = new MovieClip();
                };
                _local_7 = getBounds(this);
                addChildAt(this.ShadedBackground_mc, 0);
                _local_8 = this.ShadedBackground_mc.graphics;
                _local_8.clear();
                _local_8.beginFill(this.BackgroundColor, this.BackgroundAlpha);
                _local_8.drawRect(_local_7.x, _local_7.y, _local_7.width, _local_7.height);
                _local_8.endFill();
            };
            visible = _local_1;
        }


    }
}//package Shared.AS3

