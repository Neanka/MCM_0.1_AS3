// Decompiled by AS3 Sorcerer 4.04
// www.as3sorcerer.com

//Shared.AS3.BSUIComponent

package Shared.AS3
{
    import flash.display.MovieClip;
    import Shared.PlatformChangeEvent;
    import flash.events.Event;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import Shared.PlatformRequestEvent;

    public dynamic class BSUIComponent extends MovieClip 
    {

        private var _bIsDirty:Boolean;
        private var _iPlatform:Number;
        private var _bPS3Switch:Boolean;
        private var _bAcquiredByNativeCode:Boolean;
        private var _bShowBrackets:Boolean = false;
        private var _bUseShadedBackground:Boolean = false;
        private var _shadedBackgroundType:String = "normal";
        private var _shadedBackgroundMethod:String = "Shader";
        private var _bracketPair:BSBracketClip;
        private var _bracketLineWidth:Number = 1.5;
        private var _bracketCornerLength:Number = 6;
        private var _bracketPaddingX:Number = 0;
        private var _bracketPaddingY:Number = 0;
        private var _bracketStyle:String = "horizontal";

        public function BSUIComponent()
        {
            this._bIsDirty = false;
            this._iPlatform = PlatformChangeEvent.PLATFORM_INVALID;
            this._bPS3Switch = false;
            this._bAcquiredByNativeCode = false;
            this._bracketPair = new BSBracketClip();
            addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStageEvent);
        }

        public function get bIsDirty():Boolean
        {
            return (this._bIsDirty);
        }

        public function get iPlatform():Number
        {
            return (this._iPlatform);
        }

        public function get bPS3Switch():Boolean
        {
            return (this._bPS3Switch);
        }

        public function get bAcquiredByNativeCode():Boolean
        {
            return (this._bAcquiredByNativeCode);
        }

        public function get bShowBrackets():Boolean
        {
            return (this._bShowBrackets);
        }

        public function set bShowBrackets(_arg_1:Boolean)
        {
            if (this.bShowBrackets != _arg_1)
            {
                this._bShowBrackets = _arg_1;
                this.SetIsDirty();
            };
        }

        public function get bracketLineWidth():Number
        {
            return (this._bracketLineWidth);
        }

        public function set bracketLineWidth(_arg_1:Number):void
        {
            if (this._bracketLineWidth != _arg_1)
            {
                this._bracketLineWidth = _arg_1;
                this.SetIsDirty();
            };
        }

        public function get bracketCornerLength():Number
        {
            return (this._bracketCornerLength);
        }

        public function set bracketCornerLength(_arg_1:Number):void
        {
            if (this._bracketCornerLength != _arg_1)
            {
                this._bracketCornerLength = _arg_1;
                this.SetIsDirty();
            };
        }

        public function get bracketPaddingX():Number
        {
            return (this._bracketPaddingX);
        }

        public function set bracketPaddingX(_arg_1:Number):void
        {
            if (this._bracketPaddingX != _arg_1)
            {
                this._bracketPaddingX = _arg_1;
                this.SetIsDirty();
            };
        }

        public function get bracketPaddingY():Number
        {
            return (this._bracketPaddingY);
        }

        public function set bracketPaddingY(_arg_1:Number):void
        {
            if (this._bracketPaddingY != _arg_1)
            {
                this._bracketPaddingY = _arg_1;
                this.SetIsDirty();
            };
        }

        public function get BracketStyle():String
        {
            return (this._bracketStyle);
        }

        public function set BracketStyle(_arg_1:String)
        {
            if (this._bracketStyle != _arg_1)
            {
                this._bracketStyle = _arg_1;
                this.SetIsDirty();
            };
        }

        public function get bUseShadedBackground():Boolean
        {
            return (this._bUseShadedBackground);
        }

        public function set bUseShadedBackground(_arg_1:Boolean)
        {
            if (this._bUseShadedBackground != _arg_1)
            {
                this._bUseShadedBackground = _arg_1;
                this.SetIsDirty();
            };
        }

        public function get ShadedBackgroundType():String
        {
            return (this._shadedBackgroundType);
        }

        public function set ShadedBackgroundType(_arg_1:String)
        {
            if (this._shadedBackgroundType != _arg_1)
            {
                this._shadedBackgroundType = _arg_1;
                this.SetIsDirty();
            };
        }

        public function get ShadedBackgroundMethod():String
        {
            return (this._shadedBackgroundMethod);
        }

        public function set ShadedBackgroundMethod(_arg_1:String)
        {
            if (this._shadedBackgroundMethod != _arg_1)
            {
                this._shadedBackgroundMethod = _arg_1;
                this.SetIsDirty();
            };
        }

        public function SetIsDirty():void
        {
            this._bIsDirty = true;
            this.requestRedraw();
        }

        final private function ClearIsDirty():void
        {
            this._bIsDirty = false;
        }

        public function onAcquiredByNativeCode()
        {
            this._bAcquiredByNativeCode = true;
        }

        final private function onEnterFrameEvent(_arg_1:Event):void
        {
            removeEventListener(Event.ENTER_FRAME, this.onEnterFrameEvent, false);
            if (this.bIsDirty)
            {
                this.requestRedraw();
            };
        }

        final private function onAddedToStageEvent(_arg_1:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStageEvent);
            this.onAddedToStage();
            addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStageEvent);
        }

        private function requestRedraw():void
        {
            if (stage)
            {
                stage.addEventListener(Event.RENDER, this.onRenderEvent);
                addEventListener(Event.ENTER_FRAME, this.onEnterFrameEvent, false, 0, true);
                stage.invalidate();
            };
        }

        final private function onRemovedFromStageEvent(_arg_1:Event):void
        {
            removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStageEvent);
            this.onRemovedFromStage();
            addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStageEvent);
        }

        final private function onRenderEvent(arEvent:Event):void
        {
            var bBracketsDrawn:* = undefined;
            var preDrawBounds:Rectangle;
            var postDrawBounds:Rectangle;
            removeEventListener(Event.ENTER_FRAME, this.onEnterFrameEvent, false);
            if (stage)
            {
                stage.removeEventListener(Event.RENDER, this.onRenderEvent);
            };
            if (this.bIsDirty)
            {
                this.ClearIsDirty();
                try
                {
                    bBracketsDrawn = contains(this._bracketPair);
                    if (bBracketsDrawn)
                    {
                        removeChild(this._bracketPair);
                    };
                    preDrawBounds = getBounds(this);
                    this.redrawUIComponent();
                    postDrawBounds = getBounds(this);
                    this.UpdateBrackets((((!(bBracketsDrawn))) || ((!((preDrawBounds == postDrawBounds))))));
                } catch(e:Error)
                {
                    trace(((((this + " ") + this.name) + ": ") + e.getStackTrace()));
                };
            };
            if (this.bIsDirty)
            {
                addEventListener(Event.ENTER_FRAME, this.onEnterFrameEvent, false, 0, true);
            };
        }

        final private function onSetPlatformEvent(_arg_1:Event)
        {
            var _local_2:PlatformChangeEvent = (_arg_1 as PlatformChangeEvent);
            this.SetPlatform(_local_2.uiPlatform, _local_2.bPS3Switch);
        }

        public function UpdateBrackets(_arg_1:Boolean)
        {
            if (((((this._bShowBrackets) && ((width > this.bracketCornerLength)))) && ((height > this._bracketCornerLength))))
            {
                if (_arg_1)
                {
                    this._bracketPair.redrawUIComponent(this, this.bracketLineWidth, this.bracketCornerLength, new Point(this._bracketPaddingX, this.bracketPaddingY), this.BracketStyle);
                };
                addChild(this._bracketPair);
            } else
            {
                this._bracketPair.ClearBrackets();
            };
        }

        public function onAddedToStage():void
        {
            dispatchEvent(new PlatformRequestEvent(this));
            if (stage)
            {
                stage.addEventListener(PlatformChangeEvent.PLATFORM_CHANGE, this.onSetPlatformEvent);
            };
            if (this.bIsDirty)
            {
                this.requestRedraw();
            };
        }

        public function onRemovedFromStage():void
        {
            if (stage)
            {
                stage.removeEventListener(PlatformChangeEvent.PLATFORM_CHANGE, this.onSetPlatformEvent);
                stage.removeEventListener(Event.RENDER, this.onRenderEvent);
            };
        }

        public function redrawUIComponent():void
        {
        }

        public function SetPlatform(_arg_1:Number, _arg_2:Boolean):void
        {
            if ((((!((this._iPlatform == _arg_1)))) || ((!((this._bPS3Switch == _arg_2))))))
            {
                this._iPlatform = _arg_1;
                this._bPS3Switch = _arg_2;
                this.SetIsDirty();
            };
        }


    }
}//package Shared.AS3

