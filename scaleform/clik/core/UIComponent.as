//Created by Action Script Viewer - http://www.buraks.com/asv
package scaleform.clik.core
{
    import flash.display.MovieClip;
    import scaleform.clik.layout.LayoutData;
    import scaleform.clik.utils.Constraints;
    import flash.events.Event;
    import scaleform.gfx.Extensions;
    import scaleform.clik.events.ComponentEvent;
    import scaleform.gfx.FocusManager;
    import scaleform.clik.events.InputEvent;
    import flash.external.ExternalInterface;
    import scaleform.clik.constants.InvalidationType;

    [Event(name="SHOW", type="scaleform.clik.events.ComponentEvent")]
    [Event(name="HIDE", type="scaleform.clik.events.ComponentEvent")]
    public class UIComponent extends MovieClip 
    {

        public var initialized:Boolean = false;
        protected var _invalidHash:Object;
        protected var _invalid:Boolean = false;
        protected var _width:Number = 0;
        protected var _height:Number = 0;
        protected var _originalWidth:Number = 0;
        protected var _originalHeight:Number = 0;
        protected var _focusTarget:UIComponent;
        protected var _focusable:Boolean = true;
        protected var _focused:Number = 0;
        protected var _displayFocus:Boolean = false;
        protected var _mouseWheelEnabled:Boolean = true;
        protected var _inspector:Boolean = false;
        protected var _labelHash:Object;
        protected var _layoutData:LayoutData;
        protected var _enableInitCallback:Boolean = false;
        public var constraints:Constraints;

        public function UIComponent()
        {
            this.preInitialize();
            super();
            this._invalidHash = {};
            this.initialize();
            addEventListener(Event.ADDED_TO_STAGE, this.addedToStage, false, 0, true);
        }

        public static function generateLabelHash(target:MovieClip):Object
        {
            var hash:Object = {};
            if (!(target))
            {
                return (hash);
            };
            var labels:Array = target.currentLabels;
            var l:uint = labels.length;
            var i:uint;
            while (i < l)
            {
                hash[labels[i].name] = true;
                i++;
            };
            return (hash);
        }


        protected function preInitialize():void
        {
        }

        protected function initialize():void
        {
            this._labelHash = UIComponent.generateLabelHash(this);
            this._originalWidth = (super.width / super.scaleX);
            this._originalHeight = (super.height / super.scaleY);
            if (this._width == 0)
            {
                this._width = super.width;
            };
            if (this._height == 0)
            {
                this._height = super.height;
            };
            this.invalidate();
        }

        protected function addedToStage(event:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.addedToStage, false);
            if (!(CLIK.initialized))
            {
                CLIK.initialize(stage, this);
            };
            if (((this._enableInitCallback) && (!((Extensions.CLIK_addedToStageCallback == null)))))
            {
                CLIK.queueInitCallback(this);
            };
        }

        public function get componentInspectorSetting():Boolean
        {
            return (this._inspector);
        }

        public function set componentInspectorSetting(value:Boolean):void
        {
            this._inspector = value;
            if (value)
            {
                this.beforeInspectorParams();
            }
            else
            {
                this.afterInspectorParams();
            };
        }

        override public function get width():Number
        {
            return (this._width);
        }

        override public function set width(value:Number):void
        {
            this.setSize(value, this._height);
        }

        override public function get height():Number
        {
            return (this._height);
        }

        override public function set height(value:Number):void
        {
            this.setSize(this._width, value);
        }

        override public function get scaleX():Number
        {
            return ((this._width / this._originalWidth));
        }

        override public function set scaleX(value:Number):void
        {
            super.scaleX = value;
            if (rotation == 0)
            {
                this.width = super.width;
            };
        }

        override public function get scaleY():Number
        {
            return ((this._height / this._originalHeight));
        }

        override public function set scaleY(value:Number):void
        {
            super.scaleY = value;
            if (rotation == 0)
            {
                this.height = super.height;
            };
        }

        [Inspectable(defaultValue="true")]
        override public function get enabled():Boolean
        {
            return (super.enabled);
        }

        override public function set enabled(value:Boolean):void
        {
            if (value == super.enabled)
            {
                return;
            };
            super.enabled = value;
            tabEnabled = ((!(this.enabled)) ? false : this._focusable);
            mouseEnabled = value;
        }

        [Inspectable(defaultValue="true")]
        override public function get visible():Boolean
        {
            return (super.visible);
        }

        override public function set visible(value:Boolean):void
        {
            super.visible = value;
            dispatchEvent(new ComponentEvent(((value) ? ComponentEvent.SHOW : ComponentEvent.HIDE)));
        }

        public function get hasFocus():Boolean
        {
            return ((this._focused > 0));
        }

        public function get focusable():Boolean
        {
            return (this._focusable);
        }

        public function set focusable(value:Boolean):void
        {
            var changed:Boolean = !((this._focusable == value));
            this._focusable = value;
            if (((!(this._focusable)) && (this.enabled)))
            {
                tabEnabled = (tabChildren = false);
            }
            else
            {
                if (((this._focusable) && (this.enabled)))
                {
                    tabEnabled = true;
                };
            };
            if (changed)
            {
                this.changeFocus();
            };
        }

        public function get focused():Number
        {
            return (this._focused);
        }

        public function set focused(value:Number):void
        {
            var numFocusGroups:uint;
            var numControllers:uint;
            var i:Number;
            var isFocused:Boolean;
            var controllerMask1:Number;
            var j:Number;
            var controllerValue1:Boolean;
            if ((((value == this._focused)) || (!(this._focusable))))
            {
                return;
            };
            this._focused = value;
            if (Extensions.isScaleform)
            {
                numFocusGroups = FocusManager.numFocusGroups;
                numControllers = Extensions.numControllers;
                i = 0;
                while (i < numFocusGroups)
                {
                    isFocused = !((((this._focused >> i) & 1) == 0));
                    if (isFocused)
                    {
                        controllerMask1 = FocusManager.getControllerMaskByFocusGroup(i);
                        j = 0;
                        while (j < numControllers)
                        {
                            controllerValue1 = !((((controllerMask1 >> j) & 1) == 0));
                            if (((controllerValue1) && (!((FocusManager.getFocus(j) == this)))))
                            {
                                FocusManager.setFocus(this, j);
                            };
                            j++;
                        };
                    };
                    i++;
                };
            }
            else
            {
                if (((!((stage == null))) && ((this._focused > 0))))
                {
                    stage.focus = this;
                };
            };
            this.changeFocus();
        }

        public function get displayFocus():Boolean
        {
            return (this._displayFocus);
        }

        public function set displayFocus(value:Boolean):void
        {
            if (value == this._displayFocus)
            {
                return;
            };
            this._displayFocus = value;
            this.changeFocus();
        }

        public function get focusTarget():UIComponent
        {
            return (this._focusTarget);
        }

        public function set focusTarget(value:UIComponent):void
        {
            this._focusTarget = value;
        }

        public function get layoutData():LayoutData
        {
            return (this._layoutData);
        }

        public function set layoutData(value:LayoutData):void
        {
            this._layoutData = value;
        }

        [Inspectable(defaultValue="false")]
        public function get enableInitCallback():Boolean
        {
            return (this._enableInitCallback);
        }

        public function set enableInitCallback(value:Boolean):void
        {
            if (value == this._enableInitCallback)
            {
                return;
            };
            this._enableInitCallback = value;
            if (((((this._enableInitCallback) && (!((stage == null))))) && (!((Extensions.CLIK_addedToStageCallback == null)))))
            {
                if (!(CLIK.initialized))
                {
                    CLIK.initialize(stage, this);
                };
                CLIK.queueInitCallback(this);
            };
        }

        final public function get actualWidth():Number
        {
            return (super.width);
        }

        final public function get actualHeight():Number
        {
            return (super.height);
        }

        final public function get actualScaleX():Number
        {
            return (super.scaleX);
        }

        final public function get actualScaleY():Number
        {
            return (super.scaleY);
        }

        public function setSize(width:Number, height:Number):void
        {
            this._width = width;
            this._height = height;
            this.invalidateSize();
        }

        public function setActualSize(newWidth:Number, newHeight:Number):void
        {
            if (((!((super.width == newWidth))) || (!((this._width == newWidth)))))
            {
                super.width = (this._width = newWidth);
            };
            if (((!((super.height == newHeight))) || (!((this._height == newHeight)))))
            {
                super.height = (this._height = newHeight);
            };
        }

        final public function setActualScale(scaleX:Number, scaleY:Number):void
        {
            super.scaleX = scaleX;
            super.scaleY = scaleY;
            this._width = (this._originalWidth * scaleX);
            this._height = (this._originalHeight * scaleY);
            this.invalidateSize();
        }

        public function handleInput(event:InputEvent):void
        {
        }

        public function dispatchEventToGame(event:Event):void
        {
            ExternalInterface.call("__handleEvent", name, event);
        }

        override public function toString():String
        {
            return ((("[CLIK UIComponent " + name) + "]"));
        }

        protected function configUI():void
        {
        }

        protected function draw():void
        {
        }

        protected function changeFocus():void
        {
        }

        protected function beforeInspectorParams():void
        {
        }

        protected function afterInspectorParams():void
        {
        }

        protected function initSize():void
        {
            var w:Number = (((this._width)==0) ? this.actualWidth : this._width);
            var h:Number = (((this._height)==0) ? this.actualHeight : this._height);
            var _local3:int = 1;
            super.scaleY = _local3;
            super.scaleX = _local3;
            this.setSize(w, h);
        }

        public function invalidate(... invalidTypes):void
        {
            var l:uint;
            var i:uint;
            if (invalidTypes.length == 0)
            {
                this._invalidHash[InvalidationType.ALL] = true;
            }
            else
            {
                l = invalidTypes.length;
                i = 0;
                while (i < l)
                {
                    this._invalidHash[invalidTypes[i]] = true;
                    i++;
                };
            };
            if (!(this._invalid))
            {
                this._invalid = true;
                if (stage == null)
                {
                    addEventListener(Event.ADDED_TO_STAGE, this.handleStageChange, false, 0, true);
                }
                else
                {
                    addEventListener(Event.ENTER_FRAME, this.handleEnterFrameValidation, false, 0, true);
                    addEventListener(Event.RENDER, this.validateNow, false, 0, true);
                    stage.invalidate();
                };
            }
            else
            {
                if (stage != null)
                {
                    stage.invalidate();
                };
            };
        }

        public function validateNow(event:Event=null):void
        {
            if (!(this.initialized))
            {
                this.initialized = true;
                this.configUI();
            };
            removeEventListener(Event.ENTER_FRAME, this.handleEnterFrameValidation, false);
            removeEventListener(Event.RENDER, this.validateNow, false);
            if (!(this._invalid))
            {
                return;
            };
            this.draw();
            this._invalidHash = {};
            this._invalid = false;
        }

        protected function isInvalid(... invalidTypes):Boolean
        {
            if (!(this._invalid))
            {
                return (false);
            };
            var l:uint = invalidTypes.length;
            if (l == 0)
            {
                return (this._invalid);
            };
            if (this._invalidHash[InvalidationType.ALL])
            {
                return (true);
            };
            var i:uint;
            while (i < l)
            {
                if (this._invalidHash[invalidTypes[i]])
                {
                    return (true);
                };
                i++;
            };
            return (false);
        }

        public function invalidateSize():void
        {
            this.invalidate(InvalidationType.SIZE);
        }

        public function invalidateData():void
        {
            this.invalidate(InvalidationType.DATA);
        }

        public function invalidateState():void
        {
            this.invalidate(InvalidationType.STATE);
        }

        protected function handleStageChange(event:Event):void
        {
            if (event.type == Event.ADDED_TO_STAGE)
            {
                removeEventListener(Event.ADDED_TO_STAGE, this.handleStageChange, false);
                addEventListener(Event.RENDER, this.validateNow, false, 0, true);
                if (stage != null)
                {
                    stage.invalidate();
                };
            };
        }

        protected function handleEnterFrameValidation(event:Event):void
        {
            this.validateNow();
        }

        protected function getInvalid():String
        {
            var n:String;
            var inv:Array = [];
            var check:Array = [InvalidationType.ALL, InvalidationType.DATA, InvalidationType.RENDERERS, InvalidationType.SIZE, InvalidationType.STATE];
            var i:uint;
            while (i < check.length)
            {
                inv.push(((("* " + check[i]) + ": ") + (this._invalidHash[check[i]] == true)));
                i++;
            };
            for (n in this._invalidHash)
            {
                if (!check.indexOf(n))
                {
                    inv.push((("* " + n) + ": true"));
                };
            };
            return (((("Invalid " + this) + ": \n") + inv.join("\n")));
        }

        public function dispatchEventAndSound(event:Event):Boolean
        {
            var ok:Boolean = super.dispatchEvent(event);
            return (ok);
        }


    }
}//package scaleform.clik.core
