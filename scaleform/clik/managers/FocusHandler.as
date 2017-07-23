//Created by Action Script Viewer - http://www.buraks.com/asv
package scaleform.clik.managers
{
    import flash.display.Stage;
    import flash.utils.Dictionary;
    import scaleform.gfx.FocusManager;
    import scaleform.clik.core.UIComponent;
    import scaleform.gfx.Extensions;
    import flash.events.MouseEvent;
    import flash.events.FocusEvent;
    import scaleform.clik.events.InputEvent;
    import flash.display.InteractiveObject;
    import flash.display.Sprite;
    import scaleform.clik.core.CLIK;
    import flash.display.DisplayObject;
    import scaleform.clik.events.FocusHandlerEvent;
    import flash.text.TextField;
    import flash.events.Event;
    import scaleform.clik.utils.WeakReference;
    import scaleform.clik.ui.InputDetails;
    import scaleform.clik.constants.InputValue;
    import scaleform.clik.constants.NavigationCode;
    import flash.display.DisplayObjectContainer;
    import scaleform.clik.constants.FocusMode;
    import scaleform.gfx.FocusEventEx;

    [Event(name="input", type="gfx.events.InputEvent")]
    public class FocusHandler 
    {

        protected static var initialized:Boolean = false;
        public static var instance:FocusHandler;

        protected var _stage:Stage;
        protected var currentFocusLookup:Dictionary;
        protected var actualFocusLookup:Dictionary;
        protected var preventStageFocusChanges:Boolean = false;
        protected var mouseDown:Boolean = false;

        public function FocusHandler()
        {
            this.currentFocusLookup = new Dictionary();
            this.actualFocusLookup = new Dictionary();
        }

        public static function getInstance():FocusHandler
        {
            if (instance == null)
            {
                instance = new (FocusHandler)();
            };
            return (instance);
        }

        public static function init(stage:Stage, component:UIComponent):void
        {
            if (initialized)
            {
                return;
            };
            var focusHandler:FocusHandler = FocusHandler.getInstance();
            focusHandler.stage = stage;
            FocusManager.alwaysEnableArrowKeys = true;
            FocusManager.disableFocusKeys = true;
            initialized = true;
        }


        public function set stage(value:Stage):void
        {
            if (this._stage == null)
            {
                this._stage = value;
            };
            this._stage.stageFocusRect = false;
            if (Extensions.enabled)
            {
                this._stage.addEventListener(MouseEvent.MOUSE_DOWN, this.trackMouseDown, false, 0, true);
                this._stage.addEventListener(MouseEvent.MOUSE_UP, this.trackMouseDown, false, 0, true);
            };
            this._stage.addEventListener(FocusEvent.FOCUS_IN, this.updateActualFocus, false, 0, true);
            this._stage.addEventListener(FocusEvent.FOCUS_OUT, this.updateActualFocus, false, 0, true);
            this._stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, this.handleMouseFocusChange, false, 0, true);
            this._stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, this.handleMouseFocusChange, false, 0, true);
            var inputDelegate:InputDelegate = InputDelegate.getInstance();
            inputDelegate.initialize(this._stage);
            inputDelegate.addEventListener(InputEvent.INPUT, this.handleInput, false, 0, true);
        }

        public function getFocus(focusGroupIdx:uint):InteractiveObject
        {
            return (this.getCurrentFocusDisplayObject(focusGroupIdx));
        }

        public function setFocus(focus:InteractiveObject, focusGroupIdx:uint=0, mouseChange:Boolean=false):void
        {
            var focusComponent:UIComponent;
            var controllerMask:Number;
            var numControllers:uint;
            var i:uint;
            var controllerValue:Boolean;
            var focusParam:InteractiveObject = focus;
            if (focus != null)
            {
                while (true)
                {
                    focusComponent = (focus as UIComponent);
                    if (focusComponent == null) break;
                    if (focusComponent.focusTarget != null)
                    {
                        focus = focusComponent.focusTarget;
                    }
                    else
                    {
                        break;
                    };
                };
            };
            if (focusComponent != null)
            {
                if (focusComponent.focusable == false)
                {
                    focus = null;
                };
            };
            var spr:Sprite = (focus as Sprite);
            if (((((spr) && (mouseChange))) && ((spr.tabEnabled == false))))
            {
                focus = null;
            };
            if (((CLIK.disableNullFocusMoves) && ((((focus == null)) || ((focus == this._stage))))))
            {
                return;
            };
            var actualFocus:DisplayObject = this.getActualFocusDisplayObject(focusGroupIdx);
            var currentFocus:DisplayObject = this.getCurrentFocusDisplayObject(focusGroupIdx);
            if (currentFocus != focus)
            {
                focusComponent = (currentFocus as UIComponent);
                if (focusComponent != null)
                {
                    focusComponent.focused = (focusComponent.focused & ~((1 << focusGroupIdx)));
                };
                if (currentFocus != null)
                {
                    currentFocus.dispatchEvent(new FocusHandlerEvent(FocusHandlerEvent.FOCUS_OUT, true, false, focusGroupIdx));
                };
                currentFocus = focus;
                this.setCurrentFocusDisplayObject(focusGroupIdx, focus);
                focusComponent = (currentFocus as UIComponent);
                if (focusComponent != null)
                {
                    focusComponent.focused = (focusComponent.focused | (1 << focusGroupIdx));
                };
                if (currentFocus != null)
                {
                    currentFocus.dispatchEvent(new FocusHandlerEvent(FocusHandlerEvent.FOCUS_IN, true, false, focusGroupIdx));
                };
            };
            var isActualFocusTextField:Boolean = (actualFocus is TextField);
            var isCurrentFocusUIComponent:Boolean = (currentFocus is UIComponent);
            if (((!((actualFocus == currentFocus))) && (((!(isActualFocusTextField)) || (((isActualFocusTextField) && (!(isCurrentFocusUIComponent))))))))
            {
                if ((((((focusParam is TextField)) && (!((focusParam == focus))))) && ((focus == null))))
                {
                    focus = focusParam;
                };
                this.preventStageFocusChanges = true;
                if (Extensions.isScaleform)
                {
                    controllerMask = FocusManager.getControllerMaskByFocusGroup(focusGroupIdx);
                    numControllers = Extensions.numControllers;
                    i = 0;
                    while (i < numControllers)
                    {
                        controllerValue = !((((controllerMask >> i) & 1) == 0));
                        if (controllerValue)
                        {
                            this.setSystemFocus((focus as InteractiveObject), i);
                        };
                        i++;
                    };
                }
                else
                {
                    this.setSystemFocus((focus as InteractiveObject));
                };
                this._stage.addEventListener(Event.ENTER_FRAME, this.clearFocusPrevention, false, 0, true);
            };
        }

        protected function getCurrentFocusDisplayObject(focusGroupIdx:uint):InteractiveObject
        {
            var ref:WeakReference = (this.currentFocusLookup[focusGroupIdx] as WeakReference);
            if (ref)
            {
                return ((ref.value as InteractiveObject));
            };
            return (null);
        }

        protected function setCurrentFocusDisplayObject(focusGroupIdx:uint, dobj:InteractiveObject):void
        {
            this.currentFocusLookup[focusGroupIdx] = new WeakReference(dobj);
        }

        protected function getActualFocusDisplayObject(focusGroupIdx:uint):InteractiveObject
        {
            var ref:WeakReference = (this.actualFocusLookup[focusGroupIdx] as WeakReference);
            if (ref)
            {
                return ((ref.value as InteractiveObject));
            };
            return (null);
        }

        protected function setActualFocusDisplayObject(focusGroupIdx:uint, dobj:InteractiveObject):void
        {
            this.actualFocusLookup[focusGroupIdx] = new WeakReference(dobj);
        }

        protected function setSystemFocus(newFocus:InteractiveObject, controllerIdx:uint=0):void
        {
            if (Extensions.isScaleform)
            {
                FocusManager.setFocus(newFocus, controllerIdx);
            }
            else
            {
                this._stage.focus = newFocus;
            };
        }

        protected function getSystemFocus(controllerIdx:uint=0):InteractiveObject
        {
            if (Extensions.isScaleform)
            {
                return (FocusManager.getFocus(controllerIdx));
            };
            return (this._stage.focus);
        }

        protected function clearFocusPrevention(e:Event):void
        {
            this.preventStageFocusChanges = false;
            this._stage.removeEventListener(Event.ENTER_FRAME, this.clearFocusPrevention, false);
        }

        public function input(details:InputDetails):void
        {
            var event:InputEvent = new InputEvent(InputEvent.INPUT, details);
            this.handleInput(event);
        }

        public function trackMouseDown(e:MouseEvent):void
        {
            this.mouseDown = e.buttonDown;
        }

        protected function handleInput(event:InputEvent):void
        {
            var focusProp:String;
            var controllerIdx:Number = event.details.controllerIndex;
            var focusGroupIdx:Number = FocusManager.getControllerFocusGroup(controllerIdx);
            var component:InteractiveObject = this.getCurrentFocusDisplayObject(focusGroupIdx);
            if (component == null)
            {
                component = this._stage;
            };
            var newEvent:InputEvent = (event.clone() as InputEvent);
            var ok:Boolean = component.dispatchEvent(newEvent);
            if (((!(ok)) || (newEvent.handled)))
            {
                return;
            };
            if (event.details.value == InputValue.KEY_UP)
            {
                return;
            };
            var nav:String = event.details.navEquivalent;
            if (nav == null)
            {
                return;
            };
            var focusedElement:InteractiveObject = this.getCurrentFocusDisplayObject(focusGroupIdx);
            var actualFocus:InteractiveObject = this.getActualFocusDisplayObject(focusGroupIdx);
            var stageFocusedElement:InteractiveObject = this.getSystemFocus(focusGroupIdx);
            if ((((((actualFocus is TextField)) && ((actualFocus == focusedElement)))) && (this.handleTextFieldInput(nav, controllerIdx))))
            {
                return;
            };
            if ((((actualFocus is TextField)) && (this.handleTextFieldInput(nav, controllerIdx))))
            {
                return;
            };
            var dirX:Boolean = (((nav == NavigationCode.LEFT)) || ((nav == NavigationCode.RIGHT)));
            var dirY:Boolean = (((nav == NavigationCode.UP)) || (NavigationCode.DOWN));
            if (focusedElement == null)
            {
                if (((stageFocusedElement) && ((stageFocusedElement is UIComponent))))
                {
                    focusedElement = (stageFocusedElement as UIComponent);
                };
            };
            if (focusedElement == null)
            {
                if (((actualFocus) && ((actualFocus is UIComponent))))
                {
                    focusedElement = (actualFocus as UIComponent);
                };
            };
            if (focusedElement == null)
            {
                return;
            };
            var focusContext:DisplayObjectContainer = focusedElement.parent;
            var focusMode:String = FocusMode.DEFAULT;
            if (((dirX) || (dirY)))
            {
                focusProp = ((dirX) ? FocusMode.HORIZONTAL : FocusMode.VERTICAL);
                while (focusContext != null)
                {
                    if ((focusProp in focusContext))
                    {
                        focusMode = focusContext[focusProp];
                        if (((!((focusMode == null))) && (!((focusMode == FocusMode.DEFAULT))))) break;
                        focusContext = focusContext.parent;
                    }
                    else
                    {
                        break;
                    };
                };
            }
            else
            {
                focusContext = null;
            };
            if ((((actualFocus is TextField)) && ((actualFocus.parent == focusedElement))))
            {
                focusedElement = this.getSystemFocus(controllerIdx);
            };
            var newFocus:InteractiveObject = FocusManager.findFocus(nav, null, (focusMode == FocusMode.LOOP), focusedElement, false, controllerIdx);
            if (newFocus != null)
            {
                this.setFocus(newFocus, focusGroupIdx);
            };
        }

        protected function handleMouseFocusChange(event:FocusEvent):void
        {
            this.handleFocusChange((event.target as InteractiveObject), (event.relatedObject as InteractiveObject), event);
        }

        protected function handleFocusChange(oldFocus:InteractiveObject, newFocus:InteractiveObject, event:FocusEvent):void
        {
            var focusTF:TextField;
            if (((this.mouseDown) && ((newFocus is TextField))))
            {
                event.preventDefault();
                return;
            };
            if (((CLIK.disableDynamicTextFieldFocus) && ((newFocus is TextField))))
            {
                focusTF = (newFocus as TextField);
                if (focusTF.type == "dynamic")
                {
                    event.stopImmediatePropagation();
                    event.stopPropagation();
                    event.preventDefault();
                    return;
                };
            };
            if ((newFocus is UIComponent))
            {
                event.preventDefault();
            };
            if ((((((oldFocus is TextField)) && ((newFocus == null)))) && (CLIK.disableTextFieldToNullFocusMoves)))
            {
                event.preventDefault();
                return;
            };
            var sfEvent:FocusEventEx = (event as FocusEventEx);
            var controllerIdx:uint = (((sfEvent == null)) ? 0 : sfEvent.controllerIdx);
            var focusGroupIdx:uint = FocusManager.getControllerFocusGroup(controllerIdx);
            this.setActualFocusDisplayObject(focusGroupIdx, newFocus);
            this.setFocus(newFocus, focusGroupIdx, (event.type == FocusEvent.MOUSE_FOCUS_CHANGE));
        }

        protected function updateActualFocus(event:FocusEvent):void
        {
            var oldFocus:InteractiveObject;
            var newFocus:InteractiveObject;
            if (event.type == FocusEvent.FOCUS_IN)
            {
                oldFocus = (event.relatedObject as InteractiveObject);
                newFocus = (event.target as InteractiveObject);
            }
            else
            {
                oldFocus = (event.target as InteractiveObject);
                newFocus = (event.relatedObject as InteractiveObject);
            };
            if (event.type == FocusEvent.FOCUS_OUT)
            {
                if (this.preventStageFocusChanges)
                {
                    event.stopImmediatePropagation();
                    event.stopPropagation();
                };
            };
            var sfEvent:FocusEventEx = (event as FocusEventEx);
            var controllerIdx:uint = (((sfEvent == null)) ? 0 : sfEvent.controllerIdx);
            var focusGroupIdx:uint = FocusManager.getControllerFocusGroup(controllerIdx);
            this.setActualFocusDisplayObject(focusGroupIdx, newFocus);
            var currentFocus:InteractiveObject = this.getCurrentFocusDisplayObject(focusGroupIdx);
            if (((((((((!((newFocus == null))) && ((newFocus is TextField)))) && (!((newFocus.parent == null))))) && ((currentFocus == newFocus.parent)))) && ((currentFocus == oldFocus))))
            {
                return;
            };
            var isActualFocusTextField:Boolean = (newFocus is TextField);
            var isCurrentFocusUIComponent:Boolean = (currentFocus is UIComponent);
            if (newFocus != currentFocus)
            {
                if (((!(((isActualFocusTextField) && (isCurrentFocusUIComponent)))) || ((newFocus == null))))
                {
                    if (((!(this.preventStageFocusChanges)) || (isActualFocusTextField)))
                    {
                        this.setFocus(newFocus, focusGroupIdx);
                    };
                };
            };
        }

        protected function handleTextFieldInput(nav:String, controllerIdx:uint):Boolean
        {
            var actualFocus:TextField = (this.getActualFocusDisplayObject(controllerIdx) as TextField);
            if (actualFocus == null)
            {
                return (false);
            };
            var position:int = actualFocus.caretIndex;
            var focusIdx:Number = 0;
            switch (nav)
            {
                case NavigationCode.UP:
                    if (!(actualFocus.multiline))
                    {
                        return (false);
                    };
                case NavigationCode.LEFT:
                    return ((position > 0));
                case NavigationCode.DOWN:
                    if (!(actualFocus.multiline))
                    {
                        return (false);
                    };
                case NavigationCode.RIGHT:
                    return ((position < actualFocus.length));
            };
            return (false);
        }


    }
}//package scaleform.clik.managers
